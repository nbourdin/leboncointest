//
//  ArticleDetailsViewController.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation
import UIKit
import Combine

class ArticleDetailsViewController: UIViewController {
    
    // Views
    
    private lazy var bottomBar: UIStackView = {
        let contactButton = UIButton()
        contactButton.setTitle("button.contact".localized, for: .normal)
        contactButton.setTitleColor(.black, for: .normal)
        contactButton.layer.cornerRadius = CornerRadiusSize.small
        contactButton.layer.masksToBounds = true
        contactButton.backgroundColor = .white
        contactButton.layer.borderWidth = 1
        contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        contactButton.layer.borderColor = UIColor.black.cgColor
        contactButton.translatesAutoresizingMaskIntoConstraints = true
        contactButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let buyButton = UIButton()
        buyButton.setTitle("button.buy".localized, for: .normal)
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.backgroundColor = .systemOrange
        buyButton.layer.cornerRadius = CornerRadiusSize.small
        buyButton.layer.masksToBounds = true
        buyButton.translatesAutoresizingMaskIntoConstraints = true
        buyButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        buyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [contactButton, buyButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Spacing.regular
        stackView.layoutMargins = UIEdgeInsets(top: Spacing.regular, left: Spacing.regular, bottom: Spacing.regular, right: Spacing.regular)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var infoPreview: ArticleInfoPreview = {
        let preview = ArticleInfoPreview(mode: .page)
        preview.translatesAutoresizingMaskIntoConstraints = false
        return preview
    }()
    
    
    private lazy var descriptionLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.paddingHorizontal = Spacing.small
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        return label
    }()
    
    
    private func separator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .lightGray
        return view
    }
    
    private lazy var descriptionSectionTitle: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "label.description".localized
        label.paddingHorizontal = Spacing.small
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return label
    }()
    
    private lazy var siretLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.paddingHorizontal = Spacing.small
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return label
    }()
    
    private var cancellables = Set<AnyCancellable>()

    
    let viewModel: ArticleDetailsViewModel
    init(viewModel: ArticleDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .white
        fillInformations()
    }
}

fileprivate extension ArticleDetailsViewController {
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(bottomBar)
        bottomBar.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
        bottomBar.backgroundColor = .white
        bottomBar.layer.zPosition = 999

        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: bottomBar.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [
            infoPreview,
            separator(),
            descriptionSectionTitle,
            descriptionLabel,
            separator(),
            siretLabel
        ])

        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Spacing.regular
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
                
    }
    
    private func fillInformations() {
        infoPreview.configure(title: viewModel.article.title, price: viewModel.article.price.formattedPrice, date: viewModel.article.creationDate.formattedString, isUrgent: viewModel.article.isUrgent, category: viewModel.article.category?.name)
        descriptionLabel.text = viewModel.article.description
        if let image = viewModel.thumbnailPublisher {
            image.sink(receiveValue: {image in
                self.infoPreview.imageView.animateImage(image: image, duration: 0.1)
            }).store(in: &cancellables)
        }
        if let siret = viewModel.article.siret {
            siretLabel.text = String(format: "article.siret".localized, siret)
            siretLabel.isHidden = false
        }
    }
}
