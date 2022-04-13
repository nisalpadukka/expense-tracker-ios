//
//  DBHandler.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-09.
//

import Foundation
import SQLite3

class DBHandler {
    
    private var connection: OpaquePointer?
    private var statement: OpaquePointer?
    
    func open() -> Bool {
        // Create connection to database
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("expenseTracker2.sqlite")
            
        sqlite3_open(fileUrl.path, &connection)
            
        if sqlite3_open(fileUrl.path, &connection) != SQLITE_OK{
            print("Error Opening Database")
            return false
        }
        print("Connection opened succefully")
        return true
    }
    
    func createTable() -> Bool{

        let createTaleQuerry = "CREATE TABLE IF NOT EXISTS Transactions ( id    INTEGER, type    TEXT, value    REAL, category    TEXT, description    TEXT, date    TEXT, year INT, month INT, week INT, PRIMARY KEY(id AUTOINCREMENT))"
        
        if sqlite3_exec(connection, createTaleQuerry, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return false
        }
        
        print("Table created")
        return true
    }
    
    func cleanTable(){
        let cleanQuerry = "DROP table Transactions"
        
        if sqlite3_prepare(connection, cleanQuerry, -1,&statement, nil) != SQLITE_OK{
            print("Error creating querry " + cleanQuerry)
        }
        sqlite3_step(statement)
        sqlite3_reset(statement)
        
    }
    
    func getTotal(type:String)->Double{
     
        let typeNs = type as NSString
        let getTotalQuerry = "SELECT sum(value) from Transactions where type =?"
        
        if sqlite3_prepare(connection, getTotalQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return 0.0
        }
    
        if sqlite3_bind_text(statement, 1, typeNs.utf8String ,-1, nil) != SQLITE_OK{
            print("Error Binding " + type)
            sqlite3_reset(statement)
            return 0.0
        }
     
        if sqlite3_step(statement) == SQLITE_ROW {
            let value = sqlite3_column_double(statement, 0)
            sqlite3_reset(statement)
            print(value)
            return value
        }
        sqlite3_reset(statement)
        return 0.0
    }
    
    func getAllTransactions(type:String)-> [Transaction]{
        
        print ("GetAllTransactions " + type)
        
        let typeNs = type as NSString
        
        var transactions =  [Transaction]()
        
        //let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
     
        let getTotalQuerry = "SELECT * from Transactions where type =?"
        //let getTotalQuerry = "SELECT * from Transactions order by date desc"
        
        if sqlite3_prepare(connection, getTotalQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return transactions
        }
        
        if sqlite3_bind_text(statement, 1, typeNs.utf8String ,-1, nil) != SQLITE_OK{
            print("Error Binding " + type)
            sqlite3_reset(statement)
            return transactions
        }
     
        while sqlite3_step(statement) == SQLITE_ROW {
            var transaction = Transaction()
            transaction.id = Int(sqlite3_column_int(statement, 0))
            transaction.type =  String(cString:sqlite3_column_text(statement, 1))
            transaction.value = sqlite3_column_double(statement, 2)
            transaction.catagory =  String(cString:sqlite3_column_text(statement, 3))
            transaction.description =  String(cString:sqlite3_column_text(statement, 4))
            transaction.date =  String(cString:sqlite3_column_text(statement, 5))
            transactions.append(transaction)
            print("Retrieved " + transaction.toString())
        }
        sqlite3_reset(statement)
        return transactions
    }
    
    func getChartData(type:String, dateFilter:DateFilter, period:String)-> ChartData{
        
        print ("Get ChartData  " + type + " " + period)
        
        let typeNs = type as NSString
        
        var chartData =  ChartData()
        var getGroupedData = ""
        
        if (period == "Monthly"){
            getGroupedData = "SELECT category, sum(value) from Transactions  where type =? and year =? and month = ? group by category"
        }
        else{
            getGroupedData = "SELECT category, sum(value) from Transactions where type =? and year =? and month = ? and week = ? group by category"
        }
        
        print(getGroupedData)

        if sqlite3_prepare(connection, getGroupedData,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return chartData
        }
        
        if sqlite3_bind_text(statement, 1, typeNs.utf8String ,-1, nil) != SQLITE_OK{
            print("Error Binding " + type)
            sqlite3_reset(statement)
            return chartData
        }
        
        if sqlite3_bind_int(statement, 2, Int32(dateFilter.year)) != SQLITE_OK{
            print("Error Binding " + String(dateFilter.year))
            sqlite3_reset(statement)
            return chartData
        }
        
        if sqlite3_bind_int(statement, 3, Int32(dateFilter.month)) != SQLITE_OK{
            print("Error Binding " + String(dateFilter.month))
            sqlite3_reset(statement)
            return chartData
        }
        
        if (period == "Weekly"){
            if sqlite3_bind_int(statement, 4, Int32(dateFilter.week)) != SQLITE_OK{
                print("Error Binding " + String(dateFilter.month))
                sqlite3_reset(statement)
                return chartData
            }
        }
     
        while sqlite3_step(statement) == SQLITE_ROW {
            var x = String(cString:sqlite3_column_text(statement, 1))
            var y = sqlite3_column_double(statement, 1)
            
            chartData.x.append(x)
            chartData.y.append(y)
            print("Chart Data x:" + x + " y:" + String(y))
        }
        sqlite3_reset(statement)
        return chartData
    }
    
    func getSubTotal(type:String, category:String, dateFilter:DateFilter, period:String)-> Double{
        
        print ("Get sub Total  " + type + " " + period + " " + category)
        
        let typeNs = type as NSString
        let categoryNs = category as NSString
        
        var val = 0.0
        var getGroupedData = ""
        
        if (period == "Monthly"){
            getGroupedData = "SELECT sum(value) from Transactions  where type =? and year =? and month = ? and category = ?"
        }
        else{
            getGroupedData = "SELECT sum(value) from Transactions where type =? and year =? and month = ? and category = ? and week = ?"
        }
        
        print(getGroupedData)

        if sqlite3_prepare(connection, getGroupedData,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return val
        }
        
        if sqlite3_bind_text(statement, 1, typeNs.utf8String ,-1, nil) != SQLITE_OK{
            print("Error Binding " + type)
            sqlite3_reset(statement)
            return val
        }
        
    
        if sqlite3_bind_int(statement, 2, Int32(dateFilter.year)) != SQLITE_OK{
            print("Error Binding " + String(dateFilter.year))
            sqlite3_reset(statement)
            return val
        }
        
        if sqlite3_bind_int(statement, 3, Int32(dateFilter.month)) != SQLITE_OK{
            print("Error Binding " + String(dateFilter.month))
            sqlite3_reset(statement)
            return val
        }
        
        if sqlite3_bind_text(statement, 4, categoryNs.utf8String ,-1, nil) != SQLITE_OK{
            print("Error Binding " + String(dateFilter.week))
            sqlite3_reset(statement)
            return val
        }
        
        if (period == "Weekly"){
            if sqlite3_bind_int(statement, 5, Int32(dateFilter.week)) != SQLITE_OK{
                print("Error Binding " + String(dateFilter.week))
                sqlite3_reset(statement)
                return val
            }
        }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let value = sqlite3_column_double(statement, 0)
            sqlite3_reset(statement)
            print(value)
            return value
        }
        sqlite3_reset(statement)
        return 0.0
    }
    
    func getTxn(id:String)-> Transaction{
        
        print ("Get Transaction " + id)
        
        let transaction = Transaction()
        
        //let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
     
        let getTotalQuerry = "SELECT * from Transactions where id =?"
        //let getTotalQuerry = "SELECT * from Transactions order by date desc"
        
        if sqlite3_prepare(connection, getTotalQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return transaction
        }
        
        if sqlite3_bind_int(statement, 1, Int32(id) ?? 0) != SQLITE_OK{
            print("Error Binding " + id)
            sqlite3_reset(statement)
            return transaction
        }
     
        if sqlite3_step(statement) == SQLITE_ROW {
            transaction.id = Int(sqlite3_column_int(statement, 0))
            transaction.type =  String(cString:sqlite3_column_text(statement, 1))
            transaction.value = sqlite3_column_double(statement, 2)
            transaction.catagory =  String(cString:sqlite3_column_text(statement, 3))
            transaction.description =  String(cString:sqlite3_column_text(statement, 4))
            transaction.date =  String(cString:sqlite3_column_text(statement, 5))
            print("Retrieved " + transaction.toString())
        }
        
        sqlite3_reset(statement)
        return transaction
    }
    
    
    func getLatest(type:String)->Double{
     
        let typeNs = type as NSString
        let getTotalQuerry = "SELECT value from Transactions where type = ? order by date DESC LIMIT 1"
        
        if sqlite3_prepare(connection, getTotalQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return 0.0
        }
    
        if sqlite3_bind_text(statement, 1, typeNs.utf8String ,-1, nil) != SQLITE_OK{
            print("Error Binding " + type)
            sqlite3_reset(statement)
            return 0.0
        }
     
        if sqlite3_step(statement) == SQLITE_ROW {
            let value = sqlite3_column_double(statement, 0)
            sqlite3_reset(statement)
            print(value)
            return value
        }
        sqlite3_reset(statement)
        return 0.0
    }
    
    func removeTxn(id:Int) -> Bool{
        
        print("Removing transaction " + String(id))
        
        
        let removeQuerry = "DELETE from Transactions where id =?"
        
        if sqlite3_prepare(connection, removeQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return false
        }
    
        if sqlite3_bind_int(statement, 1, Int32(id)) != SQLITE_OK{
            print("Error Binding " + String(id))
            sqlite3_reset(statement)
        }
        sqlite3_step(statement)
        sqlite3_reset(statement)
        return true
        
    }
    
    func insertTransaction(transaction:Transaction) -> Bool{
        
        print("Inserting " + transaction.toString())
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let insertQuerry = "INSERT INTO Transactions (type, value, category, description, date, year, month, week) VALUES (?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(connection, insertQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_text(statement, 1, transaction.type ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.type)
            sqlite3_reset(statement)
            return false
        }
     
        if sqlite3_bind_double(statement, 2, transaction.value) != SQLITE_OK{
            print("Error Binding " + String(transaction.value))
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_text(statement, 3, transaction.catagory ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.catagory)
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_text(statement, 4, transaction.description ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.description)
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_text(statement, 5, transaction.date ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.date)
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_int(statement, 6, Int32(transaction.year)) != SQLITE_OK{
            print("Error Binding " + String(transaction.year))
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_int(statement, 7, Int32(transaction.month)) != SQLITE_OK{
            print("Error Binding " + String(transaction.month))
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_int(statement, 8, Int32(transaction.week)) != SQLITE_OK{
            print("Error Binding " + String(transaction.week))
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_step(statement) != SQLITE_DONE{
            print("Saving failed " + String(cString: sqlite3_errmsg(connection)))
            sqlite3_reset(statement)
            return false
        }
        
        sqlite3_reset(statement)
        print("Saved succefully ")
        return true
    }
    
    func updateTransaction(transaction:Transaction) -> Bool{
        
        print("Inserting " + transaction.toString())
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let updateQuerry = "Update Transactions set value = ?, category = ?, description = ? where id = ?"
        
        if sqlite3_prepare(connection, updateQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_double(statement, 1, transaction.value) != SQLITE_OK{
            print("Error Binding " + String(transaction.value))
            sqlite3_reset(statement)
            return false
        }
     
        
        if sqlite3_bind_text(statement, 2, transaction.catagory ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.catagory)
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_text(statement, 3, transaction.description ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.description)
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_int(statement, 4, Int32(transaction.id)) != SQLITE_OK{
            print("Error Binding " + String(transaction.id))
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_step(statement) != SQLITE_DONE{
            print("Editing failed " + String(cString: sqlite3_errmsg(connection)))
            sqlite3_reset(statement)
            return false
        }
        
        sqlite3_reset(statement)
        print("Edited succefully ")
        return true
    }

    
}
