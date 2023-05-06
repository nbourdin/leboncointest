//
//  ArticleInfoPreview.swift
//  leboncoin
//
//  Created by Nicolas on 06/05/2023.
//

import Foundation
import UIKit


enum ArticleInfoPreviewMode {
    case cell, page
}
class ArticleInfoPreview: UIView {
    
    private let mode: ArticleInfoPreviewMode
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = mode == .cell ? CornerRadiusSize.regular : 0
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: mode == .cell ? 150 : 400).isActive = true
        return imageView
    }()
    
    private lazy var urgentLabel: UrgentLabel = {
        let label = UrgentLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.paddingVertical = Spacing.extraSmall
        label.paddingHorizontal = Spacing.small
        label.font = UIFont.systemFont(ofSize: 14,weight: UIFont.Weight.semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.paddingVertical = Spacing.extraSmall
        label.paddingHorizontal = Spacing.small
        label.font = UIFont.systemFont(ofSize: 14,weight: UIFont.Weight.semibold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    private lazy var dateLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.paddingVertical = Spacing.extraSmall
        label.paddingHorizontal = Spacing.small
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var categoryLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.paddingVertical = Spacing.extraSmall
        label.paddingHorizontal = Spacing.small
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        return label
    }()
    
    init(mode: ArticleInfoPreviewMode) {
        self.mode = mode
        super.init(frame: .zero)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView, titleLabel, priceLabel, dateLabel, categoryLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        imageView.addSubview(urgentLabel)
        urgentLabel.anchor(top: imageView.topAnchor, right: imageView.rightAnchor, paddingTop: Spacing.regular, paddingRight: Spacing.regular)
        
        addSubview(stackView)
        stackView.fillParent(parent: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, price: String, date: String, isUrgent: Bool, category: String?) {
        titleLabel.text = title
        priceLabel.text = price
        dateLabel.text = date
        urgentLabel.isHidden = !isUrgent
        if let category = category {
            categoryLabel.text = category
        }
        
    }
    
    func clearImage() {
        imageView.image = nil
    }
}
