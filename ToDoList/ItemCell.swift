//
//  ItemCell.swift
//  ToDoList
//
//  Created by Marco Almeida on 12/29/16.
//  Copyright © 2016 THE IRON YARD. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell
{
    @IBOutlet weak var counterTitle: UITextField!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var toDoCheckBox: UISwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
