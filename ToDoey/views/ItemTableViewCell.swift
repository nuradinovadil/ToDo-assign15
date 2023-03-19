//
//  SectionTableViewCell.swift
//  ToDoey
//
//  Created by Nuradinov Adil on 04/03/23.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    static let identifier = "ItemTableViewCell"

    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Section"
        label.font = UIFont.systemFont(ofSize: 23)
        return label
    }()
    
    private lazy var cellImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with name: String, image: Data?) {
        let imageDefault = UIImage(named: "default-image")
        let imageData = imageDefault!.pngData()!
        nameLabel.text = name
        cellImageView.image = UIImage(data: image ?? imageData)
    }
}

private extension ItemTableViewCell {
    func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(cellImageView)
    }
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        cellImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.top.bottom.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(15)
        }
    }
}
