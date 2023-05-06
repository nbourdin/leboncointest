//
//  UIView+Extension.swift
//  leboncoin
//
//  Created by Nicolas on 01/05/2023.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

extension UICollectionView {
    func registerClass<T: UICollectionViewCell>(cellClass `class`: T.Type) where T: ReusableView {
        register(`class`, forCellWithReuseIdentifier: `class`.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass `class`: T.Type, forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: `class`.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(`class`.reuseIdentifier) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
}

// Cell
extension UITableView {
    func registerClass<T: UITableViewCell>(cellClass `class`: T.Type) where T: ReusableView {
        register(`class`, forCellReuseIdentifier: `class`.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(withClass `class`: T.Type) -> T? where T: ReusableView {
        return self.dequeueReusableCell(withIdentifier: `class`.reuseIdentifier) as? T
    }

    func dequeueReusableCell<T: UITableViewCell>(withClass `class`: T.Type, forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: `class`.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(`class`.reuseIdentifier) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func fillParent(parent: UIView, padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: parent.leftAnchor, constant: padding).isActive = true
        rightAnchor.constraint(equalTo: parent.rightAnchor, constant: padding).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: padding).isActive = true
        topAnchor.constraint(equalTo: parent.topAnchor, constant: padding).isActive = true
    }
    
    func fillSafeAreaLayout(parent: UIView, padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leftAnchor, constant: padding).isActive = true
        rightAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.rightAnchor, constant: padding).isActive = true
        bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: padding).isActive = true
        topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: padding).isActive = true
    }
}


extension UIImageView {
    func animateImage(image: UIImage?, duration: Double = 0.3) {
        UIView.transition(with: self,
        duration: duration,
        options: [.curveEaseOut, .transitionCrossDissolve],
        animations: {
            self.image = image
        })
    }
    
    func imageFromURL(_ URLString: String) {
        guard let imageUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            
            DispatchQueue.main.async {
                guard error == nil, let data = data, let downloadedImage = UIImage(data: data) else { return }
                
                self.image = downloadedImage
            }
        }).resume()
    }
}
