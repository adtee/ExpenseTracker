//
//  CategoryCell.swift
//  ExpenseTracker
//
//  Created by Aditi Pancholi on 12/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var viewWrapper: UIView!
    
    var categoryInfo : CategoryModel?{
        didSet{
            self.labelCategory.text = categoryInfo?.categoryName
            setupCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewWrapper.backgroundColor = .clear
    }
    
    func setupCell(){
        viewWrapper.layer.borderColor = UIColor.black.cgColor
        viewWrapper.layer.borderWidth = 2
        viewWrapper.layer.cornerRadius = 5
    }
}
