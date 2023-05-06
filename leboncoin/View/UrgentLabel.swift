//
//  UrgentLabel.swift
//  leboncoin
//
//  Created by Nicolas on 05/05/2023.
//

import Foundation
import UIKit

class UrgentLabel: PaddingLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        paddingHorizontal = Spacing.small
        font = UIFont.systemFont(ofSize: 14,weight: UIFont.Weight.medium)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemOrange
        textColor = .white
        layer.cornerRadius = 4
        layer.masksToBounds = true
        text = "URGENT"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
