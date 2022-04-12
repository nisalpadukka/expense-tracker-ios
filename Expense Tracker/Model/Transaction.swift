//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-09.
//

import Foundation

class Transaction{
    var id: Int = 0
    var value: Double = 0.0
    var catagory: String = ""
    var description: String = ""
    var date:String = ""
    var type:String = ""
    
    func toString() ->String{
        var str:String = ""
        str = "ID:" + String(id) + " Type: " + type + " Category:" + catagory
        return  str + " Description:" + description + " Value:" + String(value) + " Date:" + date
    }
}

