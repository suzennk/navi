//
//  OnYourOwnTableVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/02.
//

import UIKit
import SnapKit
import PanModal

private let cellId = "cellId"

class OnYourOwnTableVC: UITableViewController {
    
    var heads: [Head] = DataBaseService.shared.oyoHeads
    
    var oyoVerses: [Head : [Verse]] = DataBaseService.shared.categorizedOyoVerses {
        didSet {
            headerView.text = "전체 OYO - \(oyoVerses.count)개"
        }
    }
    
    let addVC = AddOnYourOwnVC()
    
    lazy var headerView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "OYO"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OnYourOwnCell.self, forCellReuseIdentifier: cellId)
        
        configurConstraints()
        setupBarButtonItems()
    }
    
    func configurConstraints() {
        tableView.tableHeaderView = headerView
        
        let total = oyoVerses.reduce(0) { $0 + $1.value.count }
        headerView.text = "전체 OYO - \(total)개"
        
        headerView.snp.makeConstraints { make in
            make.leading.equalTo(tableView.snp.leading).offset(16)
        }
        
        view.layoutIfNeeded()
    }
    
    func setupBarButtonItems() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddTapped))
        
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc func handleAddTapped() {
        presentPanModal(addVC)
    }
    
    // MARK: - UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return heads.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let theme = heads[section]
        return theme
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let theme = heads[section]
        return oyoVerses[theme]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? OnYourOwnCell else { return UITableViewCell() }
        
        let theme = heads[indexPath.section]
        if let verse = oyoVerses[theme]?[indexPath.row] {
            cell.viewModel = VerseViewModel(verse)
        }
        
        
        return cell
    }
}
