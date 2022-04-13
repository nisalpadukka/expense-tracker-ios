//
//  AnalyzedData.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-13.
//

import Foundation


class ChartData{
    var x: [String] = []
    var y: [Double] = []
    var precentages: [Double] = []
    
    init(){
        x.append("")
        precentages.append(0.0)
    }

    func calcPrecentages(){
        let sum = y.reduce(0, +)
        for val in y {
            precentages.append(val/sum * 100)
        }
    }
    
}


