//
//  CategoriesViewController.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol CategoriesViewControllerDelegate {
    func reloadData()
}

final class CategoriesViewController: UIViewController {
    let presenter: CategoriesPresenterDelegate
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()
    
    required init(presenter: CategoriesPresenterDelegate) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Categories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        view.backgroundColor = .secondarySystemBackground
        
        configureViews()
    }
}

private extension CategoriesViewController {
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    func configureViews() {
        view.addSubview(tableView)
        configureConstraints()
        view.backgroundColor = .secondarySystemBackground
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CategoriesViewController: CategoriesViewControllerDelegate {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presenter.select(nil)
        } else {
            presenter.select(presenter.categories[indexPath.row])
        }
        dismiss(animated: true)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = presenter.categories[indexPath.row]
        return cell
    }
}
