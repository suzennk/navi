//
//  VerseGroupTableView.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

class VerseGroupTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    let themes = DataBaseService.shared.themes
    let categories = DataBaseService.shared.categories
    
    var headerViews = [Int : ThemeHeaderView]()
    lazy var folded = [Bool](repeating: true, count: themes.count)
    
    let reuseIdentifier = "cellId"
    let headerIdentifier = "headerId"
    
    let verseView: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "오늘날 내게 네게 명하는 이 말씀을 너는 마음에 새기고 (신6:6)"
        l.numberOfLines = 2
        return l
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        backgroundColor = .white
        
        delegate = self
        dataSource = self
        
        tableHeaderView = verseView
        verseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        verseView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Header View가 바로 나타나지 않는 현상 해결
        if let headerView = self.tableHeaderView {

            // Update the size of the header based on its internal content.
            headerView.layoutIfNeeded()

            // ***Trigger table view to know that header should be updated.
            let header = self.tableHeaderView
            self.tableHeaderView = header
        }
        
        // register cells
        register(HeadCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // allow multiple selection
        allowsMultipleSelection = true
        
        // remove separator
        separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let theme = themes[section]
        let isFolded = folded[section]
        
        if isFolded {
            return 0
        } else {
            return categories[theme]?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = headerViews[section] {
            return headerView
        } else {
            let headerView = ThemeHeaderView()
            headerView.backgroundColor = tableView.backgroundColor
            
            let theme = themes[section]
            
            headerView.theme = theme
            headerView.tag = section
            headerView.addTarget(self, action: #selector(handleFoldUnfold(button:)), for: .touchUpInside)

            headerViews[section] = headerView

            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    @objc func handleFoldUnfold(button: UIButton) {
        let section = button.tag
        let theme = themes[section]
        folded[section] = !folded[section]

        guard let nRows = categories[theme]?.count else {
            debugPrint("error loading categories")
            return
        }
        
        let indexPaths = (0..<nRows).map { return IndexPath(row: $0, section: section) }
                
        if folded[section] {
            deleteRows(at: indexPaths, with: .automatic)
            
            // update header selected status caused by folding section
             guard let header = headerViews[section] else { return }
             header.isSelected = false
        } else {
            insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? HeadCell else {
            return UITableViewCell()
        }
        
        let theme = themes[indexPath.section]
        if let heads = categories[theme] {
            let head = heads[indexPath.row]
            cell.head = head
            cell.isChecked = false
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let header = headerViews[indexPath.section] else {
            debugPrint("Header not found for section: \(indexPath.section)")
            return
        }
        
        if let cell = cellForRow(at: indexPath) as? HeadCell {
            cell.isChecked = true
        }
        
        if let selectedRows = indexPathsForSelectedRows {
            print(selectedRows)
            if selectedRows.contains(where: { $0.section == indexPath.section }) {
                header.isSelected = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let header = headerViews[indexPath.section] else {
            debugPrint("Header not found for section: \(indexPath.section)")
            return
        }
        
        if let cell = cellForRow(at: indexPath) as? HeadCell {
            cell.isChecked = false
        }
        
        if let selectedRows = indexPathsForSelectedRows {
            print(selectedRows)
            if !selectedRows.contains(where: { $0.section == indexPath.section }) {
                header.isSelected = false
            }
        } else {
            header.isSelected = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
