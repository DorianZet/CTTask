//
//  CTTableViewHeader.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 17/01/2021.
//

import UIKit

class CTTableViewHeader: UITableViewHeaderFooterView {
   
    static var reuseIdentifier: String {
      return String(describing: CTTableViewHeader.self)
    }
    
    let titleLabel = CTTitleLabel(textAlignment: .left, fontSize: 22, weight: .bold)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
