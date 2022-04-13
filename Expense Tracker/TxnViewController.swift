//
//  TransactionViewController.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-09.
//

import UIKit

class TransactionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var transactionMenu: UITextField!
    @IBOutlet weak var transactionTitle: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var detail: UITextField!
    
    
    var transactionType:String = ""
    var operationType:String = ""
    var txnId:String = "nil"
    
    let expenses = ["Transport", "Grocery", "Utilities", "Entertainment" , "Cloths", "Other"]
    let incomes = ["Salary", "Savings", "Interest", "Benifits" , "Investments", "Other"]
    
    var pickerView = UIPickerView()
    var dbHandler = DBHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        transactionTitle.text = operationType + " an " + transactionType
        transactionMenu.inputView = pickerView

        if (dbHandler.open()){
            dbHandler.createTable()
        }
        
        if (operationType == "Edit"){
            if (txnId != "nil"){
                populateEditData(id:txnId)
            }
            else{
                print("Invalid transaction")
                performSegue(withIdentifier: "tableView", sender: self)
            }
        }
        
    }
    
    func populateEditData(id:String){
        var transaction = dbHandler.getTxn(id:id)
        transactionMenu.text = transaction.catagory
        amount.text = String(transaction.value)
        detail.text = transaction.description
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (transactionType == "Expense"){
            return expenses.count
        }
        return incomes.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (transactionType == "Expense"){
            return expenses[row]
        }
        return incomes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if (transactionType == "Expense"){
            transactionMenu.text = expenses[row]
        }
        else{
            transactionMenu.text = incomes[row]
        }
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        let newTransaction = Transaction()
        newTransaction.catagory = transactionMenu.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Other"
        newTransaction.value = Double(amount.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0.0") ?? 0.0
        newTransaction.type = transactionType
        newTransaction.description = detail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "NA"
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM HH:mm"
        newTransaction.date = formatter.string(from: date)
        
        formatter.dateFormat = "yyyy"
        newTransaction.year =  Int(formatter.string(from:date)) ?? 0
        
        formatter.dateFormat = "MM"
        newTransaction.month =  Int(formatter.string(from:date)) ?? 0
        
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        newTransaction.week =  weekOfYear
        
        if (operationType == "Add"){
            dbHandler.insertTransaction(transaction: newTransaction)
        }
        else{
            
            newTransaction.id = Int(txnId) ?? -1
            dbHandler.updateTransaction(transaction: newTransaction)
        }
        
        print("User entered " + newTransaction.toString())
        performSegue(withIdentifier: "tableView", sender: self)
    }
    
    @IBAction func onSelect(_ sender: UITextField) {
        pickerView.delegate?.pickerView?(pickerView, didSelectRow: 0, inComponent: 0)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "tableView", sender: self)
        //self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
