//
//  ChartView.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/22.
//

import UIKit

class ChartView: UIView {
    var viewModel: MemorizeStatusViewModel? {
        didSet {
            updateView()
        }
    }
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    func configureConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges)
        }
    }
    
    func updateView() {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        
        guard let vm = viewModel else { return }
        vm.memorizeStatus.enumerated().forEach { (index, status) in
            let barView = UIView()
            
            let totalBar = UIView()
            totalBar.snp.makeConstraints { make in make.width.equalTo(16) }
            totalBar.layer.cornerRadius = 8
            totalBar.clipsToBounds = true
            totalBar.backgroundColor = .systemBackground.withAlphaComponent(0.8)
            
            let memorizedBar = UIView()
            memorizedBar.layer.cornerRadius = 8
            memorizedBar.backgroundColor = .systemPurple
            
            totalBar.addSubview(memorizedBar)
            memorizedBar.snp.makeConstraints { make in
                make.bottom.equalTo(totalBar.snp.bottom)
                make.leading.equalTo(totalBar.snp.leading)
                make.trailing.equalTo(totalBar.snp.trailing)
                make.height.equalTo(totalBar.snp.height).multipliedBy(status.memorizedPercentage)
            }
            
            barView.addSubview(totalBar)
            totalBar.snp.makeConstraints { make in
                make.bottom.equalTo(barView.snp.bottom)
                make.leading.equalTo(barView.snp.leading)
                make.trailing.equalTo(barView.snp.trailing)
                make.height.equalTo(barView.snp.height).multipliedBy(status.totalPercentage)
            }
            
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .caption2)
            label.text = status.theme
            label.snp.makeConstraints { make in make.height.equalTo(20) }
            
            let barSV = UIStackView(arrangedSubviews: [barView, label])
            barSV.axis = .vertical
            barSV.spacing = 8
            barSV.alignment = .center
            barSV.snp.makeConstraints { make in
                make.width.equalTo(40)
            }
            
            stackView.addArrangedSubview(barSV)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
