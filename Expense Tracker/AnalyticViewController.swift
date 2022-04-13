//
//  AnalyticViewController.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-11.
//

import UIKit
import Charts

class AnalyticViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    @IBOutlet weak var reportType: UITextField!
    @IBOutlet weak var pieChartView: PieChartView!
    var pickerView = UIPickerView()
    
    let WEEKLY_EXPEND = "Weekly Expending"
    let MONTHLY_EXPEND = "Monthly Expending"
    let WEEKLY_INCOME = "Weekly Income"
    let MONTHLY_INCOME = "Monthly Income"
    
    var reportTypes = [(String)]()
    var dbHandler:DBHandler!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbHandler = DBHandler()
        if (dbHandler.open()){
            dbHandler.createTable()
        }
        
        reportTypes.append(WEEKLY_EXPEND)
        reportTypes.append(MONTHLY_EXPEND)
        reportTypes.append(WEEKLY_INCOME)
        reportTypes.append(MONTHLY_INCOME)
        pickerView.delegate = self
        pickerView.dataSource = self
        reportType.inputView = pickerView
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reportTypes.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reportTypes[row]
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
    
    func populateChart(_ report: Int) {
        var chartData = ChartData()
        var dateFilter = getDateFilter()
        var typeTxn:String = "Expense"
        var period = "Weekly"

        if(reportTypes[report] == WEEKLY_INCOME || reportTypes[report] == MONTHLY_INCOME){
            typeTxn = "Income"
        }
        
        if(reportTypes[report] == MONTHLY_INCOME || reportTypes[report] == MONTHLY_EXPEND){
            period = "Monthly"
        }
        
        chartData = dbHandler.getChartData(type: typeTxn, dateFilter: dateFilter, period: period)
        chartData.calcPrecentages()
        setChart(dataSet:reportTypes[report], dataPoints: chartData.x, values: chartData.precentages)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reportType.text = reportTypes[row]
        
        populateChart(row)
    
    }
    
    func setChart(dataSet:String, dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry1 = PieChartDataEntry(value: Double(values[i]), label: dataPoints[i])
          dataEntries.append(dataEntry1)
        }
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: dataSet)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))

        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
          let red = Double(arc4random_uniform(256))
          let green = Double(arc4random_uniform(256))
          let blue = Double(arc4random_uniform(256))
            
          let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
          colors.append(color)
        }
        pieChartDataSet.colors = colors
      }
    
    @IBAction func onSelect(_ sender: UITextField) {
        pickerView.delegate?.pickerView?(pickerView, didSelectRow: 0, inComponent: 0)
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
