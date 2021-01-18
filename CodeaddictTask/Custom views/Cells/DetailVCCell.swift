//
//  DetailVCCell.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 17/01/2021.
//

import UIKit

class DetailVCCell: UITableViewCell {
    static let reuseID = "DetailVCCell"
    
    var cellNumberLabel = CTCellNumberLabel(textAlignment: .center)
    var commitAuthorLabel = CTBlueLabel(textAlignment: .left, fontSize: 11, weight: .semibold)
    var emailLabel = CTUniversalLabel(textAlignment: .left, alpha: 1, textStyle: .body, textColor: .label)
    var commitMessageLabel = CTUniversalLabel(textAlignment: .left, alpha: 1, textStyle: .body, textColor: .secondaryLabel)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        contentView.addSubviews(cellNumberLabel, commitAuthorLabel, emailLabel, commitMessageLabel)
        layoutUI()
        configureViews()
    }
    
    private func layoutUI() {
        NSLayoutConstraint.activate([
            cellNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            cellNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cellNumberLabel.heightAnchor.constraint(equalToConstant: 36),
            cellNumberLabel.widthAnchor.constraint(equalToConstant: 36),
            
            commitMessageLabel.leadingAnchor.constraint(equalTo: cellNumberLabel.trailingAnchor, constant: 20),
            commitMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commitMessageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            emailLabel.leadingAnchor.constraint(equalTo: cellNumberLabel.trailingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emailLabel.heightAnchor.constraint(equalToConstant: 22),
            emailLabel.bottomAnchor.constraint(equalTo: commitMessageLabel.topAnchor, constant: -2),
            
            commitAuthorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            commitAuthorLabel.leadingAnchor.constraint(equalTo: cellNumberLabel.trailingAnchor, constant: 20),
            commitAuthorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commitAuthorLabel.heightAnchor.constraint(equalToConstant: 13),
            commitAuthorLabel.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -2),
        ])
        
    }
    
    private func configureViews() {
        commitMessageLabel.numberOfLines = 0
        commitMessageLabel.minimumScaleFactor = 1
    }
    
    func set(with commit: Commit) {
        commitAuthorLabel.text = commit.commit.committer.name.uppercased()
        emailLabel.text = commit.commit.committer.email
        commitMessageLabel.text = getFirstTwoLinesFromCommitMessage(in: commit)
    }
    
    func getFirstTwoLinesFromCommitMessage(in commit: Commit) -> String {
        let message = commit.commit.message
        let arrayOfStrings = message.components(separatedBy: "\n")
        let firstTwoLines = arrayOfStrings[0]
        
        return firstTwoLines
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            if view == contentView {
                continue
            }
            view.isHidden = view.bounds.size.width == bounds.size.width
        }
    }
    
}
