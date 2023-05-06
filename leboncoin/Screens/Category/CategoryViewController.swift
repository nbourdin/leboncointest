//
//  CategoryViewController.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation
import UIKit
import Combine

class CategoryViewController: UIViewController {
    
    static let kRowHeight: CGFloat = 50;
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClass(cellClass: CategoryViewCell.self)
        tableView.estimatedRowHeight = CategoryViewController.kRowHeight
        tableView.rowHeight = CategoryViewController.kRowHeight
        return tableView
    }()
    private var cancellables = Set<AnyCancellable>()
    private lazy var loadingView = SpinnerViewController()
    
    private lazy var dataSource = makeDataSource()
    let viewModel: CategoryListViewModel
    
    init(
        viewModel: CategoryListViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
      
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.$viewState.sink(receiveValue: self.handleViewState).store(in: &cancellables)
        viewModel.fetch()
        setupView()
        
    }
    
    @objc private func applyFilter() {
        viewModel.applyCurrentFilter()
    }
}

fileprivate extension CategoryViewController {
    func setupView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.fillSafeAreaLayout(parent: view)
        
        addChild(loadingView)
        loadingView.view.frame = view.frame
        view.addSubview(loadingView.view)
        loadingView.didMove(toParent: self)
    }
    
    private func handleViewState(_ state: CategoryViewState) {
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
    
    enum Section: CaseIterable {
        case categories
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, Category> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, category in
                let cell = tableView.dequeueReusableCell(withClass: CategoryViewCell.self, forIndexPath: indexPath)
                cell.configure(with: category, isSelected: self.viewModel.selectedCategory == category.id)
                return cell
            }
        )
    }

    func update(with categories: [Category], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Category>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(categories, toSection: .categories)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath.row)
        self.dismiss(animated: true)
    }
}

