//
//  OnYourOwnTableVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/02.
//

import UIKit
import SnapKit

private let cellId = "cellId"

class OnYourOwnTableVC: UITableViewController {
    var heads: [Head] = []
    var oyoVerses: [Head : [Verse]] = [:] {
        didSet {
            heads = Set(oyoVerses.map { $0.key }).sorted(by: { $0 < $1 })
            headerView.text = "전체 OYO - \(verseCount)개"
        }
    }
    var verseCount: Int {
        return oyoVerses.reduce(0) { $0 + $1.value.count }
    }
    
    var addVC = AddOnYourOwnVC(nibName: "AddOnYourOwnVC", bundle: nil)
    
    lazy var addButton: UIButton = {
        let b = AddButton()
        b.addTarget(self, action: #selector(handleAddTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var headerView: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "OYO"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OnYourOwnCell.self, forCellReuseIdentifier: cellId)
        
        configureConstraints()
        
        oyoVerses = DataBaseService.shared.categorizedOyoVerses
    }
    
    func configureConstraints() {
        // Add add button
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        tableView.tableHeaderView = headerView
        
        let total = oyoVerses.reduce(0) { $0 + $1.value.count }
        headerView.text = "전체 OYO - \(total)개"
        
        headerView.snp.makeConstraints { make in
            make.leading.equalTo(tableView.snp.leading).offset(16)
        }
        
        view.layoutIfNeeded()
    }
    
    @objc func handleAddTapped() {
        addVC.delegate = self
        addVC.modalPresentationStyle = .fullScreen
        self.present(addVC, animated: true, completion: nil)
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
        
        let head = heads[indexPath.section]
        if let verse = oyoVerses[head]?[indexPath.row] {
            cell.viewModel = VerseViewModel(verse)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let head = heads[indexPath.section]
        if let verse = oyoVerses[head]?[indexPath.row] {
            let oyoDetailVC = OYODetailVC()
            oyoDetailVC.viewModel = OYODetailViewModel(verse: verse)
            self.navigationController?.pushViewController(oyoDetailVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let head = heads[indexPath.section]
            if let verse = oyoVerses[head]?[indexPath.row] {
                let res = DataBaseService.shared.remove(verse)
                switch res {
                case .success(_):
                    oyoVerses[head]?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    oyoVerses = DataBaseService.shared.categorizedOyoVerses
                    tableView.reloadData()
                default:
                    break
                }
            }
        }
    }
}
