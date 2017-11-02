//
//  MyMessageTableViewCell.swift
//  LemonadeAssignment
//
//  Created by Tal Cohen on 02/11/2017.
//  Copyright © 2017 Tal Cohen. All rights reserved.
//

import UIKit

class MyMessageTableViewCell: UITableViewCell {
    static let identifier = "MyMessageTableViewCell"
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(text: String) {
        self.label.text = text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
