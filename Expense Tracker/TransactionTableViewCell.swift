//
//  TransactionTableViewCell.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-11.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
    }
    
}
