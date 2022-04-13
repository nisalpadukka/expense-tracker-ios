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
    var year:Int = 0
    var month:Int = 0
    var week:Int = 0
    
    func toString() ->String{
        var str:String = ""
        str = "ID:" + String(id) + " Type: " + type + " Category:" + catagory
        str =  str + " Description:" + description + " Value:" + String(value) + " Date:" + date
        return str + " year " + String(year) + " week :" + String(week) + " month " + String(month)
        
    }
}

