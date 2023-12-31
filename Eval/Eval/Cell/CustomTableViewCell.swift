//
//  CustomTableViewCell.swift
//  Eval
//
//  Created by Student09 on 14/09/2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelAmount: UILabel!
    @IBOutlet var labelDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(item: Expense){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        labelName.text = item.name
        labelDate.text = dateFormatter.string(from: item.date)
        labelAmount.text = "\(item.value) €"
        
    }
    
}
