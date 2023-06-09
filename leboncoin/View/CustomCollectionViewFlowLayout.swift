//
//  CustomCollectionViewFlowLayout.swift
//  leboncoin
//
//  Created by Nicolas on 03/05/2023.
//

import Foundation
import UIKit

enum CollectionDisplay {
    case inline
    case list
    case grid(columns: Int)
}

extension CollectionDisplay : Equatable {
    
    public static func == (lhs: CollectionDisplay, rhs: CollectionDisplay) -> Bool {
        
        switch (lhs, rhs) {
        case (.inline, .inline),
             (.list, .list):
            return true
            
        case (.grid(let lColumn), .grid(let rColumn)):
            return lColumn == rColumn
            
        default:
            return false
        }
    }
}

class CustomCollectionViewFlowLayout : UICollectionViewFlowLayout {
    
    var display : CollectionDisplay = .list {
        didSet {
            if display != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    var containerWidth: CGFloat = 0.0 {
        didSet {
            if containerWidth != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    convenience init(display: CollectionDisplay, containerWidth: CGFloat) {
        self.init()
        
        self.display = display
        self.containerWidth = containerWidth
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.configLayout()
    }
    
    func configLayout() {
        switch display {
        case .inline:
            self.scrollDirection = .horizontal
            self.itemSize = CGSize(width: containerWidth * 0.9, height: 300)
            
        case .grid(let column):
            self.scrollDirection = .vertical
            let spacing = CGFloat(column - 1) * minimumLineSpacing
            let optimisedWidth = (containerWidth - spacing) / CGFloat(column)
            self.itemSize = CGSize(width: optimisedWidth - 20 , height: 300) // keep as square
            
        case .list:
            self.scrollDirection = .vertical
            self.itemSize = CGSize(width: containerWidth, height: 100)
        }
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        self.configLayout()
    }
}
