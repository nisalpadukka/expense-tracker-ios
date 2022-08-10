//
//  ViewController.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-03-26.
//

import UIKit
import WidgetKit

class ViewController: UIViewController, UITableViewDataSource {
    
    //OUTLETS: - UI Table
    @IBOutlet weak var mainTableView: UITableView!
    
    var dbHandler:DBHandler!
    let defaults = UserDefaults.standard
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:150, height:150))
        imageView.image = UIImage(named : "ExpenseLogosblack2")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
        // Do any additional setup after loading the view.
        dbHandler = DBHandler()
        if (dbHandler.open()){
            dbHandler.createTable()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    func animate(){
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height -  size
            self.imageView.frame = CGRect(x:-diffX/2, y:diffY/2, width:size, height:size)
            self.imageView.alpha = 0
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            mainTableView.reloadData()
            dbHandler.refreshWidget()
    }
    
    //MARK:- Implementing tableview datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableHeader")
            return cell!
        }
        
        if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableEntry")as! MainTableViewCell
            cell.incomeLabel?.text = "Total"
            cell.incomeValue?.text = "$ " +  String(dbHandler.getTotal(type:"Income"))
            cell.expenseLabel?.text = "Total"
            cell.expenseValue?.text = "$ " + String(dbHandler.getTotal(type:"Expense"))
            return cell
        }
        
        if (indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableEntry")as! MainTableViewCell
            cell.incomeLabel?.text = "Latest"
            cell.incomeValue?.text = "$ " + String(dbHandler.getLatest(type:"Income"))
            cell.expenseLabel?.text = "Latest"
            cell.expenseValue?.text = "$ " + String(dbHandler.getLatest(type:"Expense"))
            return cell
        }
        
        //Default
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableEntry")
       
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is TransactionTableViewController {
            let vc = segue.destination as? TransactionTableViewController
            vc?.transactionType = String(segue.identifier ?? "Transaction")
        }
    }
}

