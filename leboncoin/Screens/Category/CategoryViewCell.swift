//
//  CategoryViewCell.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation
import UIKit

class CategoryViewCell: UITableViewCell, ReusableView {
    
    fileprivate let label: PaddingLabel = {
        let label = PaddingLabel()
        label.paddingVertical = Spacing.extraSmall
        label.paddingHorizontal = Spacing.small
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        label.fillParent(parent: contentView)
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func configure(with category: Category, isSelected: Bool) {
        label.text = category.name
        if isSelected {
            label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        }
        
    }
    
}
