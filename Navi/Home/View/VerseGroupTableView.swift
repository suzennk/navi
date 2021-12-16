//
//  VerseGroupTableView.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

class VerseGroupTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    var homeDelegate: HomeVC?
    
    private var themes: [String] {
        get {
            return DataBaseService.shared.themes
        }
    }
    
    private var categories: [String: [String]] {
        get {
            return DataBaseService.shared.categories
        }
    }
    
    /**
     Headers for each section.
     Since we do not use reusable headers here each section headers are stored in this property.
     Could be inefficient memorywise if number of themes is large ...
     */
    private var headerViews = [Int : ThemeHeaderView]()
    private lazy var folded = [Bool](repeating: true, count: themes.count)
    
    
    var selectedHeads: [(Theme, Head)] {
        get {
            return indexPathsForSelectedRows?.compactMap({ indexPath -> (Theme, Head)? in
                let theme = themes[indexPath.section]
                if let head = categories[theme]?[indexPath.row] {
                    return (theme, head)
                } else {
                    return nil
                }
            }) ?? [(Theme, Head)]()
        }
    }
    
    private let reuseIdentifier = "cellId"
    private let headerIdentifier = "headerId"
    
    private let verseView: VerseView = {
        let v = VerseView()
        v.translatesAutoresizingMaskIntoConstraints = false
        let todayVerse = DataBaseService.shared.todayVerse
        v.viewModel = OYOCellViewModel(todayVerse)
        return v
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        backgroundColor = .systemBackground
        showsVerticalScrollIndicator = false
        
        delegate = self
        dataSource = self
        
        tableHeaderView = verseView
        verseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        // Header View가 바로 나타나지 않는 현상 해결
        if let headerView = self.tableHeaderView {

            // Update the size of the header based on its internal content.
            headerView.layoutIfNeeded()

            // ***Trigger table view to know that header should be updated.
            let header = self.tableHeaderView
            self.tableHeaderView = header
        }
        
        // Footer View
        let footerView = UIView()
        footerView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        self.tableFooterView = footerView
        
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
        if let headerView = headerViews[section] {      // reuse custom-stored headers
            return headerView
        } else {                                        // instantiate new section header
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
        return 80
    }
    
    @objc func handleFoldUnfold(button: UIButton) {
        let section = button.tag
        let theme = themes[section]
        folded[section] = !folded[section]

        let nDelete = numberOfRows(inSection: section)
        guard let nInsert = categories[theme]?.count else { return  }
        
        let deleteIndexPaths = (0..<nDelete).map { return IndexPath(row: $0, section: section) }
        let insertIndexPaths = (0..<nInsert).map { return IndexPath(row: $0, section: section) }
        
        if folded[section] {
            // update header selected status caused by folding section
             guard let header = headerViews[section] else { return }
             header.isSelected = false
            
            // delete rows
            deleteRows(at: deleteIndexPaths, with: .automatic)
        } else {
            // insert rows
            insertRows(at: insertIndexPaths, with: .automatic)
        }
        
        // notify homeVC
        homeDelegate?.updateView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? HeadCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = tableView.backgroundColor
        
        let theme = themes[indexPath.section]
        if let heads = categories[theme] {
            let head = heads[indexPath.row]
            cell.theme = theme
            cell.head = head
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
        
        if let selectedRows = indexPathsForSelectedRows {
            if selectedRows.contains(where: { $0.section == indexPath.section }) {
                header.isSelected = true
            }
        }

        // notify homeVC
        homeDelegate?.updateView()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let header = headerViews[indexPath.section] else {
            debugPrint("Header not found for section: \(indexPath.section)")
            return
        }
        
        if let selectedRows = indexPathsForSelectedRows {
            if !selectedRows.contains(where: { $0.section == indexPath.section }) {
                header.isSelected = false
            }
        } else {
            header.isSelected = false
        }
        
        // notify homeVC
        homeDelegate?.updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
