//
//  ViewController.swift
//  leboncoin
//
//  Created by Nicolas on 01/05/2023.
//

import UIKit
import Combine

class ArticleListViewController: UIViewController {

    let viewModel: ArticleListViewModel
    init(viewModel: ArticleListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var collectionViewFlowLayout : CustomCollectionViewFlowLayout = {
        let layout = CustomCollectionViewFlowLayout(display: .grid(columns: 2), containerWidth: self.view.bounds.width)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.registerClass(cellClass: ArticleCellView.self)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: Spacing.regular, left: Spacing.regular, bottom: Spacing.regular, right: Spacing.regular)
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = collectionViewFlowLayout
        
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var loadingView = SpinnerViewController()
    
    private var cancellables = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settingsButton = UIBarButtonItem(title: NSString(string: "\u{2699}\u{0000FE0E}") as String, style: .plain, target: self, action: #selector(onCategoryButtonTapped))
            let font = UIFont.systemFont(ofSize: 28) // adjust the size as required
            let attributes = [NSAttributedString.Key.font : font]
            settingsButton.setTitleTextAttributes(attributes, for: .normal)
            self.navigationItem.rightBarButtonItem = settingsButton

        setupView()
        viewModel.fetch()
        viewModel.$viewState.sink(receiveValue: self.handleViewState).store(in: &cancellables)
    }
    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.reloadCollectionViewLayout(self.view.bounds.size.width)
    }
    
    private func reloadCollectionViewLayout(_ width: CGFloat) {
         
        self.collectionViewFlowLayout.containerWidth = width
        self.collectionViewFlowLayout.display = self.view.traitCollection.horizontalSizeClass == .compact && self.view.traitCollection.verticalSizeClass == .regular ? CollectionDisplay.grid(columns: 2) : CollectionDisplay.grid(columns: 4)
     
    }

}

extension ArticleListViewController {
    
    func setupView() {
        addChild(loadingView)
        loadingView.view.frame = view.frame
        view.addSubview(loadingView.view)
        loadingView.didMove(toParent: self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor
        )
    }
    
    @objc func onCategoryButtonTapped(sender: UIBarButtonItem) {
        viewModel.showCategories()
    }
    
    private func handleViewState(_ state: ArticleListViewState) {
        DispatchQueue.main.async {
            switch state {
            case .idle:
                self.loadingView.view.isHidden = true
                self.update(with: [], animate: true)
            case .loading:
                self.loadingView.view.isHidden = false
                self.update(with: [], animate: true)
            case .failure:
                self.showErrorDialog()
                self.loadingView.view.isHidden = true
                self.update(with: [], animate: true)
            case .data(let categories):
                self.loadingView.view.isHidden = true
                self.update(with: categories, animate: true)
            }
        }
    }
}

extension ArticleListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.viewModel.showArticleDetails(at: indexPath.row)
    }
}

extension ArticleListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if case let .data(articles) = viewModel.viewState {
            return articles.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if case let .data(articles) = viewModel.viewState {
            let cell = collectionView.dequeueReusableCell(withClass: ArticleCellView.self, forIndexPath: indexPath)
            cell.bind(to: articles[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
        
    }
    
}


fileprivate extension ArticleListViewController {
    enum Section: CaseIterable {
        case articles
    }

    func update(with items: [Article], animate: Bool = true) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
