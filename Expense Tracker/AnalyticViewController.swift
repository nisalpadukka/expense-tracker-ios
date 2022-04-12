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
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
    let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
    let goals = [6, 8, 26, 30, 8, 10]

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reportType.text = reportTypes[row]
        setChart(dataPoints: months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry1 = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
          dataEntries.append(dataEntry1)
        }
        print(dataEntries[0].data)
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
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
    
    @IBAction func onSelectChart(_ sender: UITextField) {
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
