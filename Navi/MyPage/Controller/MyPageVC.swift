//
//  MyPageVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/13.
//

import UIKit

class MyPageVC: ViewController {
    
    private let cellId = "cellId"
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gradientImage = UIImage(named: "mypage-bg") {
            view.backgroundColor = UIColor(patternImage: gradientImage)
            
            // dark overlay view for dark mode support
            let overlayView = UIView()
            overlayView.backgroundColor = UIColor(named: "overlay")
            view.addSubview(overlayView)
            overlayView.snp.makeConstraints { make in
                make.edges.equalTo(self.view.snp.edges)
            }
        } else {
            view.backgroundColor = .systemBackground
        }
        
        // 여기서는 예외적으로 navitaion title 검정색
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        navigationItem.title = "마이페이지"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        setupTableview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}

extension MyPageVC: UITableViewDelegate, UITableViewDataSource {

    func setupTableview() {
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let view = BlurredView()
        cell.backgroundColor = .clear
        
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.addSubview(view)

        view.snp.makeConstraints { make in
            make.edges.equalTo(cell.snp.edges).inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
            make.height.greaterThanOrEqualTo(200)
        }
        
        return cell
    }
}
