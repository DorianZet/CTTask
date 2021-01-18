//
//  DetailVCHeaderView.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 17/01/2021.
//

import UIKit

class DetailVCHeaderView: UIView {
    
    var avatarImageView = CTAvatarImageView(cornerRadius: .boxy)
    var repoByLabel = CTUniversalLabel(textAlignment: .left, alpha: 0.6, textStyle: .headline, textColor: .white)
    var repoAuthorLabel = CTTitleLabel(textAlignment: .left, fontSize: 28, weight: .bold)
    var starImageView = CTSmallImageView(image: .starFull)
    var starCountLabel = CTUniversalLabel(textAlignment: .left, alpha: 0.5, textStyle: .caption2, textColor: .white)
        
    override init(frame: CGRect) {
        super .init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(avatarImageView, repoByLabel, repoAuthorLabel, starImageView, starCountLabel)
        avatarImageView.pinToEdges(of: self)
        starImageView.alpha = 0.5
        repoByLabel.text = "REPO BY"
        repoAuthorLabel.textColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            starImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            starImageView.heightAnchor.constraint(equalToConstant: 13),
            starImageView.widthAnchor.constraint(equalToConstant: 13),
            starImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            
            starCountLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            starCountLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 5),
            starCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            starCountLabel.heightAnchor.constraint(equalToConstant: 18),
            
            repoAuthorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            repoAuthorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            repoAuthorLabel.heightAnchor.constraint(equalToConstant: 34),
            repoAuthorLabel.bottomAnchor.constraint(equalTo: starCountLabel.topAnchor, constant: -6),
            
            repoByLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            repoByLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            repoByLabel.heightAnchor.constraint(equalToConstant: 20),
            repoByLabel.bottomAnchor.constraint(equalTo: repoAuthorLabel.topAnchor, constant: -4),
        ])
    }
}


