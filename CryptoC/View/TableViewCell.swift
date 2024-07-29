//
//  TableViewCell.swift
//  CryptoC
//
//  Created by Daniil Kim on 28.07.2024.
//

import UIKit
import SnapKit

class TableCell: UITableViewCell {

    static let identifyer = "TableCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var rateLabel: UILabel = {
        let rateLabel = UILabel()
        rateLabel.text = ""
        rateLabel.textColor = UIColor.white
        rateLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return rateLabel
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = ""
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return nameLabel
    }()
    
    private lazy var hTableStack: UIStackView = {
        let hTableStack = UIStackView()
        hTableStack.axis = .horizontal
        hTableStack.alignment = .fill
        hTableStack.distribution = .fill
        hTableStack.spacing = 10
        return hTableStack
    }()

    private func setupUI() {
        hTableStack.addArrangedSubview(rateLabel)
        hTableStack.addArrangedSubview(nameLabel)
        
        contentView.addSubview(hTableStack)
    }

    private func setupConstraints() {
        hTableStack.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }

    public func setupCell(name: String, rate: String) {
        rateLabel.text = rate
        nameLabel.text = name
    }
}


