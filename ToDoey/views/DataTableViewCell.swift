//
//  SectionTableViewCell.swift
//  ToDoey
//
//  Created by Nuradinov Adil on 04/03/23.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    static let identifier = "SectionTableViewCell"

    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Section"
        label.font = UIFont.systemFont(ofSize: 23)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with name: String) {
        nameLabel.text = name
    }
    
}

private extension DataTableViewCell {
    func setupViews() {
        contentView.addSubview(nameLabel)
    }
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
    }
}
