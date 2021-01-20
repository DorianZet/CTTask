//
//  MainVC.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import UIKit

class MainVC: CTDataLoadingVC {
    
    enum Section {
        case main
    }

    var currentQuery = ""
    var repos: [Repo] = []
    var page = 1
    var isMoreRepos = true
    var isSearching = false
    var isLoadingMoreRepos = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Repo>!
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setBackButtonTitle()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getRepos(query: "stars:%3E1&sort=stars", page: 1) // getting the most popular repos at the app launch.
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    func setBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.configureCollectionViewLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.delaysContentTouches = false

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(MainVCCell.self, forCellWithReuseIdentifier: MainVCCell.reuseID)
        collectionView.register(CTCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CTCollectionViewHeader.reuseIdentifier)
    }
    
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a repo"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getRepos(query: String, page: Int) {
        showLoadingView()
        isLoadingMoreRepos = true
        currentQuery = query
        
        NetworkManager.shared.getRepos(for: query, page: page) { [weak self] (result) in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let repos):
                self.updateUI(with: repos)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Oops!", message: error.rawValue, buttonTitle: "OK")
            }
            
            self.isLoadingMoreRepos = false
        }
    }
    
    func updateUI(with repos: [Repo]) {
        if repos.count < NetworkManager.numberOfObjectsFetched {
            isMoreRepos = false
        }
        self.repos.append(contentsOf: repos)
        
        if repos.isEmpty {
            let message = "No repos found"
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message)
                return
            }
        }
        updateData(on: self.repos)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Repo>(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, repo) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainVCCell.reuseID, for: indexPath) as! MainVCCell
            cell.set(repo: repo)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CTCollectionViewHeader.reuseIdentifier, for: indexPath) as? CTCollectionViewHeader
            view?.titleLabel.text = "Repositories"
            return view
        }
    }
    
    func updateData(on repos: [Repo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Repo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repos)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}


extension MainVC: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        guard offsetY > contentHeight - height else { return }
        guard isMoreRepos, isLoadingMoreRepos == false else { return }
        
        page += 1
        getRepos(query: currentQuery, page: page)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedRepo = repos[indexPath.item]
        let destVC = DetailVC(repo: tappedRepo)
        navigationController?.pushViewController(destVC, animated: true)
    }
}


extension MainVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard isLoadingMoreRepos == false else { return }
        
        dismissEmptyStateView()
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        page = 1
        repos.removeAll()
        collectionView.scrollToTheTopOfHeader()
        getRepos(query: searchBar.text!, page: page)
    }
}

