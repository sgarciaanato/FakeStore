//
//  HomeViewController.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

protocol HomeViewControllerDelegate {
    func setDataSource(_ dataSource: ProductsDataSource)
}

final class HomeViewController: UIViewController {
    let presenter: HomePresenterDelegate
    
    lazy var homeView: HomeView = {
       let view = HomeView()
        return view
    }()
    
    required init(presenter: HomePresenterDelegate) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear(animated)
    }
    
    override func loadView() {
        super.loadView()
        view = homeView
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    func setDataSource(_ dataSource: ProductsDataSource) {
        homeView.setDataSource(dataSource)
    }
}
