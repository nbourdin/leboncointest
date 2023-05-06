//
//  ArticleListItemViewCell.swift
//  leboncoin
//
//  Created by Nicolas on 01/05/2023.
//

import Foundation
import UIKit
import Combine

class ArticleCellView: UICollectionViewCell, ReusableView {
    
    lazy var infoPreview = ArticleInfoPreview(mode: .cell)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(infoPreview)
        infoPreview.fillParent(parent: contentView)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }

    private func cancelImageLoading() {
        infoPreview.clearImage()
    }
    
    private func setupConstraints() {
        infoPreview.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)
    }

    
    func bind(to article: Article) {
        cancelImageLoading()
        infoPreview.configure(title: article.title, price: article.price.formattedPrice, date: article.creationDate.formattedString, isUrgent: article.isUrgent, category: article.category?.name)
        if let image = article.imagesUrl.small {
            infoPreview.imageView.imageFromURL(image)
        }
    }
    
}
