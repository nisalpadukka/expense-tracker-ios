//
//  MainTableViewCell.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-08.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var incomeValue: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var expenseValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
