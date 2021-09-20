//
//  TestListViewController.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 02.09.2021.
//

import UIKit

class TestListViewController: UIViewController {
    var presenter: TestListPresenter = TestListPresenter()
    
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .black
        }
    }
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        } 
        view.backgroundColor = .white
        titleLabel.text = "Для возможности использования инструмента пройдите тест"
        setupTableView()
        startLoader()
        presenter.getToken(parentVC: self)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: String(describing: TestListCell.self), bundle: nil), forCellReuseIdentifier: TestListCell.reuseIdentifier)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func startLoader() {
        loader.startAnimating()
    }
    
    func stopLoader() {
        loader.stopAnimating()
    }
}

extension TestListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TestListCell.reuseIdentifier) as? TestListCell {
            if let model = presenter.getTestModel(indexPath.row) {
                cell.setup(model)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(indexPath.row)
    }
}
