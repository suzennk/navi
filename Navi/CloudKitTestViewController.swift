//
//  CloudKitTestViewController.swift
//  Navi
//
//  Created by Susan Kim on 2022/09/05.
//

import UIKit
import SnapKit
import CloudKit

private let cellId = "cellId"

class CloudKitTestViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    
    var items = [(String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "CloudKit Test"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        setupTableView()
        
        fetchItems()
    }
    
    override func configureConstraints() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @objc func fetchItems() {
        let query = CKQuery(recordType: "Verse",
                            predicate: NSPredicate(value: true))
        CloudService.shared.privateDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            guard let records = records, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.items = records.compactMap({ (
                    ($0.value(forKey: "BIBLE")),
                    ($0.value(forKey: "CONTENT"))
                ) as? (String, String) })
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func pullToRefresh() {
        tableView.refreshControl?.beginRefreshing()
        let query = CKQuery(recordType: "Verse",
                            predicate: NSPredicate(value: true))
        CloudService.shared.privateDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            guard let records = records, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.items = records.compactMap({ (
                    ($0.value(forKey: "BIBLE")),
                    ($0.value(forKey: "CONTENT"))
                ) as? (String, String) })
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    @objc func didTapAdd() {
        let alert = UIAlertController(title: "Add Item",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter Content."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            if let field = alert.textFields?.first, let text = field.text, !text.isEmpty {
                self?.addItem(title: text)
            }
        }))
        present(alert, animated: true)
    }
    
    @objc func addItem(title: String) {
        let record = CKRecord(recordType: "Verse")
        record.setValue("custom", forKey: "BIBLE")
        record.setValue(title, forKey: "CONTENT")
        CloudService.shared.privateDatabase.save(record) { record, error in
            if record != nil && error == nil {
                NSLog("Saved")
                self.fetchItems()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = items[indexPath.row].0
        content.secondaryText = items[indexPath.row].1
        
        cell.contentConfiguration = content
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
