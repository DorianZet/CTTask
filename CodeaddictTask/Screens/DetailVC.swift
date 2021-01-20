//
//  DetailVC.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import UIKit

class DetailVC: CTDataLoadingVC {
    
    var headerView = DetailVCHeaderView(frame: .zero)
    var repoTitleLabel = CTTitleLabel(textAlignment: .left, fontSize: 17, weight: .semibold)
    var viewOnlineButton = CTButton(backgroundColor: .systemGray6, title: "VIEW ONLINE", cornerRadius: .verySmooth, font: UIFont.systemFont(ofSize: 15, weight: .semibold))
    var tableView = UITableView(frame: .zero, style: .grouped)
    var shareRepoButton = CTButton(backgroundColor: .systemGray6, title: "", cornerRadius: .smooth, font: UIFont.systemFont(ofSize: 17, weight: .semibold))
    let shareButtonContentView = ShareRepoButtonContentView(frame: .zero)
    
    var tableRepo: Repo!
    var downloadedRepo: Repo?
    
    var commits: [Commit] = []
   
    init(repo: Repo) {
        super.init(nibName: nil, bundle: nil)
        self.tableRepo = repo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureViewController()
        configureUILayout()
        configureTableView()
        configureButtons()
        getRepoAndRepoCommits(from: tableRepo.url)
    }
    
    func configureButtons() {
        shareButtonContentView.isUserInteractionEnabled = false
        viewOnlineButton.addTarget(self, action: #selector(viewRepoOnlineTapped), for: .touchUpInside)
        shareRepoButton.addTarget(self, action: #selector(shareRepoTapped), for: .touchUpInside)
    }
    
    @objc func viewRepoOnlineTapped() {
        guard let downloadedRepo = downloadedRepo else { return }
        
        let repoUrl = URL(string: downloadedRepo.htmlUrl)
        presentSafariVC(with: repoUrl ?? URL(string: "https://github.com")!)
    }
    
    @objc func shareRepoTapped() {
        guard let downloadedRepo = downloadedRepo else { return }

        let items: [Any] = ["\(downloadedRepo.name)", URL(string: "\(downloadedRepo.htmlUrl)") as Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    func configureHeaderViewAndRepoTitleLabel(with repo: Repo) {
        headerView.avatarImageView.downloadImage(from: repo.owner.avatarUrl)
        headerView.repoAuthorLabel.text = repo.owner.login
        headerView.starCountLabel.text = "Number of Stars (\(repo.stargazersCount))"
        repoTitleLabel.text = "\(repo.name)"
    }
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureUILayout() {
        view.addSubviews(headerView, viewOnlineButton, repoTitleLabel, shareRepoButton, tableView)
        shareRepoButton.addSubview(shareButtonContentView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.701333),
            
            viewOnlineButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 21),
            viewOnlineButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewOnlineButton.heightAnchor.constraint(equalToConstant: 30),
            viewOnlineButton.widthAnchor.constraint(equalToConstant: 118),
            
            repoTitleLabel.centerYAnchor.constraint(equalTo: viewOnlineButton.centerYAnchor),
            repoTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repoTitleLabel.trailingAnchor.constraint(equalTo: viewOnlineButton.leadingAnchor, constant: -20),
            repoTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            shareRepoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shareRepoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareRepoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44),
            shareRepoButton.heightAnchor.constraint(equalToConstant: 50),
            
            shareButtonContentView.centerXAnchor.constraint(equalTo: shareRepoButton.centerXAnchor),
            shareButtonContentView.topAnchor.constraint(equalTo: shareRepoButton.topAnchor, constant: 14),
            shareButtonContentView.bottomAnchor.constraint(equalTo: shareRepoButton.bottomAnchor, constant: -14),
            
            tableView.topAnchor.constraint(equalTo: repoTitleLabel.bottomAnchor, constant: 39),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: shareRepoButton.topAnchor, constant: -24),
        ])
    }
    
    func configureTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 111
        tableView.removeSeparatorsOfEmptyCellsAndLastCell()
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = false
        tableView.register(DetailVCCell.self, forCellReuseIdentifier: DetailVCCell.reuseID)
        tableView.register(CTTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CTTableViewHeader.reuseIdentifier)
    }
    
    func getRepoAndRepoCommits(from stringUrl: String) {
        showLoadingView()
        NetworkManager.shared.getRepo(fromUrlString: tableRepo.url) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let repo):
                self.downloadedRepo = repo
                DispatchQueue.main.async {
                    self.configureHeaderViewAndRepoTitleLabel(with: repo)
                }
                self.getCommits(from: repo)

            case .failure(let error):
                DispatchQueue.main.async {
                    self.dismissLoadingView()
                }
                self.presentGFAlertOnMainThread(title: "Oops!", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func getCommits(from repo: Repo) {
        NetworkManager.shared.getFirstThreeCommits(from: repo) { [weak self] (result) in
            guard let self = self else { return }
           
            DispatchQueue.main.async {
                self.dismissLoadingView()
            }
            
            switch result {
            case .success(let commits):
                self.commits = commits
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                    
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Oops!", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}


extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailVCCell.reuseID, for: indexPath) as! DetailVCCell
        cell.set(with: commits[indexPath.row])
        cell.cellNumberLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CTTableViewHeader.reuseIdentifier) as! CTTableViewHeader
        headerView.titleLabel.text = "Commits History"
        headerView.tintColor = .clear
        
        return headerView
    }
}
