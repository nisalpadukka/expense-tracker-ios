//
//  ReportViewController.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-11.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var tableViewIncome: UITableView!
    @IBOutlet weak var txnTypeLable: UITextField!
    
  
    var weeklyExpenses = [Double]()
    var monthlyExpenses = [Double]()
    var weeklyIncomes = [Double]()
    var monthlyIncomes = [Double]()
    
    let txnTypes = ["Income", "Expense"]
    let expenses = ["Transport", "Grocery", "Utilities", "Entertainment" , "Cloths", "Other"]
    let incomes = ["Salary", "Savings", "Interest", "Benifits" , "Investments", "Other"]
    var totalMonthly = 0.0
    var totalWeekly = 0.0
    
    var dbHandler = DBHandler()
    var pickerView = UIPickerView()
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return txnTypes.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return txnTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        txnTypeLable.text = txnTypes[row]
        tableViewIncome.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (txnTypeLable.text == "Expense"){
            return expenses.count + 2
        }
        
        return incomes.count + 2
    }
    @IBAction func onSelectPicker(_ sender: UITextField) {
    }
    

    @IBAction func pickerClick(_ sender: UITextField) {
        pickerView.delegate?.pickerView?(pickerView, didSelectRow: 0, inComponent: 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell")as! ReportExpenseViewCell
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
    
        if (indexPath.row == 0){
            totalMonthly = 0.0
            totalWeekly = 0.0
            cell.category.text = "Catagory"
            cell.monthly.text = "Monthly"
            cell.weekly.text = "Weekly"
            setCellBGColorBlue(cell)
            setCellCollerWhite(cell)
            return cell
        }
        
        setCellColorBGWhite(cell)
        
        //last cell
        if (indexPath.row == expenses.count + 1){
            cell.category.text = "Total"
            cell.monthly.text = String(totalMonthly)
            cell.weekly.text = String(totalWeekly)
            return cell
        }
        
        cell.category.text = expenses[indexPath.row - 1]
        setCellColorGrey(cell)
        
        var category = ""
        
        if (txnTypeLable.text == "Expense"){
            category = expenses[indexPath.row - 1]
        }
        else{
            category = incomes[indexPath.row - 1]
        }
        
        var monthly = dbHandler.getSubTotal(type: txnTypeLable.text ?? "Expense", category: category, dateFilter: getDateFilter(), period: "Monthly")
        
        var weekly = dbHandler.getSubTotal(type: txnTypeLable.text ?? "Expense", category: category, dateFilter: getDateFilter(), period: "Weekly")
        
        cell.category.text = String(category)
        cell.monthly.text = String(monthly)
        cell.weekly.text = String(weekly)
        totalMonthly = totalMonthly + monthly
        totalWeekly = totalWeekly + weekly
        
        return cell
            
    }
    
    fileprivate func getDateFilter() -> DateFilter {
        var dateFilter = DateFilter()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        dateFilter.year =  Int(formatter.string(from:date)) ?? 0
        
        formatter.dateFormat = "MM"
        dateFilter.month =  Int(formatter.string(from:date)) ?? 0
        
        let calendar = Calendar.current
        dateFilter.week = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        return dateFilter
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        txnTypeLable.inputView = pickerView
        
        dbHandler = DBHandler()
        txnTypeLable.text = txnTypes[0]
        if (dbHandler.open()){
            dbHandler.createTable()
        }

        // Do any additional setup after loading the view.
    }
    
    fileprivate func setCellCollerWhite(_ cell: ReportExpenseViewCell) {
        cell.category.textColor = UIColor.white
        cell.monthly.textColor = UIColor.white
        cell.weekly.textColor = UIColor.white
    }
    
    fileprivate func setCellColorGrey(_ cell: ReportExpenseViewCell) {
        cell.category.textColor = UIColor.darkGray
        cell.monthly.textColor = UIColor.darkGray
        cell.weekly.textColor = UIColor.darkGray
    }
    
    fileprivate func setCellColorBGWhite(_ cell: ReportExpenseViewCell) {
        cell.backgroundColor = UIColor.white
    }
    
    fileprivate func setCellBGColorBlue(_ cell: ReportExpenseViewCell) {
        cell.backgroundColor = UIColorFromRGB(rgbValue:0x077991)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
