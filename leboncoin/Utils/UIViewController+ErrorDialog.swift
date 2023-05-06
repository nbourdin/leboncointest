//
//  UIViewController+Extension.swift
//  leboncoin
//
//  Created by Nicolas on 07/05/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorDialog() {
        let dialogMessage = UIAlertController(title: "error.title".localized, message: "error.description".localized, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "ok".localized, style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true)
         })
        dialogMessage.addAction(ok)

        self.present(dialogMessage, animated: true, completion: nil)
    }
}
