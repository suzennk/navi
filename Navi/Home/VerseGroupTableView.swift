//
//  VerseGroupTableView.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

class VerseGroupTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    let groupNames = ["LOA", "LOC", "60구절", "180구절", "DEP", "OYO"]
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
        super.init(frame: frame, style: style)
        
        backgroundColor = .white
        
        delegate = self
        dataSource = self
        
        tableHeaderView = verseView
        verseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        verseView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        verseView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        // Header View가 바로 나타나지 않는 현상 해결
        if let headerView = self.tableHeaderView {

            // Update the size of the header based on its internal content.
            headerView.layoutIfNeeded()

            // ***Trigger table view to know that header should be updated.
            let header = self.tableHeaderView
            self.tableHeaderView = header
        }

        register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected item at section: \(indexPath.section) row: \(indexPath.row)")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
