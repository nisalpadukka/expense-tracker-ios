//
//  TransactionTableViewController.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-09.
//

import UIKit


class TransactionTableViewController: UITableViewController{
    @IBOutlet var transactionTable: UITableView!
    
    var transactionType:String = ""
    var dbHandler:DBHandler!
    var transactions:[Transaction] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = transactionType + "s List"
        
        dbHandler = DBHandler()
        dbHandler.open()
        
        populateData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            populateData()
    
    }
    
    func populateData(){
        transactions = dbHandler.getAllTransactions(type:transactionType)
        transactionTable.reloadData()
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        populateData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return dbHandler.getCount(transactionType)
        print("Transaction count " + String(transactions.count))
        return transactions.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as? TransactionViewController
        vc?.transactionType = transactionType
        vc?.operationType = "Add"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transaction", for: indexPath) as! TransactionTableViewCell

        cell.type.text = transactions[indexPath.row].catagory
        cell.value.text = String(transactions[indexPath.row].value)
        cell.date.text =  transactions[indexPath.row].date
        
        cell.editButton.tag = transactions[indexPath.row].id
        cell.editButton.addTarget(self, action: #selector(editTapped(sender:)), for: .touchUpInside)
        
        cell.deleteButton.tag = transactions[indexPath.row].id
        cell.deleteButton.addTarget(self, action: #selector(deleteTapped(sender:)), for: .touchUpInside)
        

        //Design
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true

        return cell
    }
    
    @objc func editTapped(sender: UIButton) {

        print("Tapped")
    }

    @objc func deleteTapped(sender: UIButton) {
        
        let txnId = sender.tag;
        print("Removing txn id " + String(txnId))

        let alertController = UIAlertController(
               title: "Confirmation", message: "Are you sure you want to remove the " + transactionType + "?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Remove", style: .cancel, handler: { (action: UIAlertAction!) in
             
        }))
        
        let defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
