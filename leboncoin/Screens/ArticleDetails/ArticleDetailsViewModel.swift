//
//  ArticleDetailsViewModel.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation
import Combine
import UIKit.UIImage

class ArticleDetailsViewModel {
    let article: Article
    private let imageLoaderService: ImageLoader
    
    init(article: Article, imageLoaderService: ImageLoader) {
        self.article = article
        self.imageLoaderService = imageLoaderService
    }
    
    var thumbnailPublisher: AnyPublisher<UIImage?, Never>? {
        if let image = article.imagesUrl.thumb, let url = URL(string: image) {
            return imageLoaderService.loadImage(from: url).receive(on: RunLoop.main).eraseToAnyPublisher()
        }
        return nil
    }
}
