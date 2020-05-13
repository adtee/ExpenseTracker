//
//  ExpenseReportDetailTableViewCell.swift
//  ExpenseTracker
//
//  Created by Aditi Pancholi on 12/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import UIKit

class ExpenseReportDetailTableViewCell: UITableViewCell {
    
    //MARK: Outlates
    
    @IBOutlet weak var labelExpenseTitle: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    
    
    
    //MARK: Variables
    var expenseObject : ExpenseModel?{
        didSet{
            labelExpenseTitle.text = expenseObject?.title ?? ""
            labelAmount.text = "\(expenseObject?.amount ?? 0.0)"
            labelDate.text = Date(milliseconds: Int64(expenseObject!.date)).formateDateIn()
            labelNote.text = expenseObject?.notes ?? ""
            labelCategory.text = expenseObject?.category?.components(separatedBy: ",").compactMap({ (id) -> String in
                return  DatabaseManager.shared.categories.first { (categoryObj) -> Bool in
                    return categoryObj.categoryId == Int(id)
                    }?.categoryName ?? ""
            }).joined(separator: ", ") ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
