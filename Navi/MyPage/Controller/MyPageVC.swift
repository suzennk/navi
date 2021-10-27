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
            let gradientImageView = UIImageView(image: gradientImage)
            gradientImageView.contentMode = .scaleToFill
            view.addSubview(gradientImageView)
            gradientImageView.snp.makeConstraints { make in
                make.edges.equalTo(view.snp.edges)
            }
            
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
        cell.backgroundColor = .clear
        
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        let blurView = BlurredView()
        let label = UILabel()
        label.text = "암송 현황"
        label.font = .preferredFont(forTextStyle: .headline)
        
        cell.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalTo(cell.snp.edges).inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
            make.height.greaterThanOrEqualTo(300)
        }

        let chartView = ChartView()
        chartView.viewModel = MemorizeStatusViewModel()
        
        blurView.addSubview(label) // MARK: - 원래는 contentView에 올려야 하는데 버그있는듯..
        label.snp.makeConstraints { make in
            make.top.equalTo(blurView.snp.top).offset(30)
            make.leading.equalTo(blurView.snp.leading).offset(30)
            make.trailing.equalTo(blurView.snp.trailing).offset(-30)
        }
        
        blurView.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.leading.equalTo(blurView.snp.leading).offset(30)
            make.trailing.equalTo(blurView.snp.trailing).offset(-30)
            make.bottom.equalTo(blurView.snp.bottom).offset(-30)
        }
        
        return cell
    }
}
