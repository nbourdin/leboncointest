//
//  SpinnerViewController.swift
//  leboncoin
//
//  Created by Nicolas on 07/05/2023.
//

import Foundation
import UIKit

class SpinnerViewController: UIViewController {
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.hidesWhenStopped = true
    }
}
