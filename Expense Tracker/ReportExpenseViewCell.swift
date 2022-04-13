//
//  ReportExpenseViewCell.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-13.
//

import UIKit

class ReportExpenseViewCell: UITableViewCell {

    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var monthly: UILabel!
    
    @IBOutlet weak var weekly: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
