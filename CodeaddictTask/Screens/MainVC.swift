//
//  MainVC.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import UIKit

class MainVC: CTDataLoadingVC {
    
    enum Section {
        case main // main section of our collection view. we create it in enum, because it's hashable (needs to be hashable for the diffableDataSource)
    }

    var currentQuery = ""
    var repos: [Repo] = []
    var page = 1
    var isMoreRepos = true
    var isSearching = false // a boolean which checks if we are in a search mode or just browse all the repos.
    var isLoadingMoreRepos = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Repo>! // Diffable Data Source has to know about the section where it should work (Section) and about our collection view items (Follower)
    
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
        navigationController?.setNavigationBarHidden(false, animated: true) // this gets rid of a bug with navbar when transitioning between this VC and searchVC by dragging your finger from the left edge of the screen.
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

        view.addSubview(collectionView)
        collectionView.delegate = self // now our VC "listens" to the collectionView and will execute code once it meets its requirements set in its extension.
        collectionView.register(MainVCCell.self, forCellWithReuseIdentifier: MainVCCell.reuseID)
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
    }
    
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a repo"
        searchController.obscuresBackgroundDuringPresentation = false // now the collection view is not greyed-out when we activate the search bar.
        navigationItem.searchController = searchController // setting search controller in the navigation controller.
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
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier, for: indexPath) as? SectionHeaderReusableView
            view?.titleLabel.text = "Repositories"
            return view
        }
    }
    
    func updateData(on repos: [Repo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Repo>() //
        snapshot.appendSections([.main])
        snapshot.appendItems(repos)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
}


extension MainVC: UICollectionViewDelegate {
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y // the y offset that gets incremented the more we scroll down.
//        let contentHeight = scrollView.contentSize.height // height of our content view (for example, if we had 3000 followers, the content view height would be thousands of points!)
//        let height = scrollView.frame.height // height of our screen
//
//        if offsetY > contentHeight - height {
//            guard isMoreRepos, isLoadingMoreRepos == false else { return } // execute the code below only if the user has more followers than 50 AND when loading more followers is NOT in a process.
//            page += 1
//            getRepos(query: currentQuery, page: page)
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y // the y offset that gets incremented the more we scroll down.
        let contentHeight = scrollView.contentSize.height // height of our content view (for example, if we had 3000 followers, the content view height would be thousands of points!)
        let height = scrollView.frame.height // height of our screen
        
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let activeArray = isSearching ? filteredFollowers : followers // if 'isSearching' is true, activeArray = filteredFollowers. if its false, activeArray = followers. it's easier to remember just as W?T:F.
//        let follower = activeArray[indexPath.item]
//
//        let destVC = UserInfoVC()
//        destVC.username = follower.login // passing the tapped follower's login to the 'username' property in destVC.
//        destVC.delegate = self // FollowerListVC is now "listening" to the UserInfoVC
//        destVC.isDogModeOn = isDogModeOn
//        let navController = UINavigationController(rootViewController: destVC) // create the navigation controller for our destVC.
//        present(navController, animated: true) // instead of just presenting destVC, show the navigation controller that our destVC is embedded in.
//    }
}

extension MainVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard isLoadingMoreRepos == false else { return }
        
        dismissEmptyStateView()
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        page = 1
        repos.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true) // scroll up to the first row of items.
        getRepos(query: searchBar.text!, page: page)
    }
}

//extension MainVC: UISearchResultsUpdating { // anytime we change the search results, it's letting us know that something has changed.
////    func updateSearchResults(for searchController: UISearchController) {
////        guard let filter = searchController.searchBar.text, !filter.isEmpty else { // our filter is the text in the search bar. once we have that filter, we want to check if it's not empty. if it is (whether by deleting the text or tapping the 'cancel' button), go back to the original state of collection view.
////            filteredRepos.removeAll()
////            updateData(on: repos)
////            isSearching = false
////            return
////        }
////
////        isSearching = true
////        filteredRepos = repos.filter { $0.login.lowercased().contains(filter.lowercased()) } // we are going through our 'followers' array and we are filtering out based on our 'filter' text. because we iterate through all the followers, '$0' is each follower. as we're going through the followers, we want to check their login, make it lowercased so casing is irrelevant when matching, and see if it contains our 'filter' text (also lowercased, for matching purposes).
////        updateData(on: filteredRepos)
////    }
//
//}

//extension FollowerListVC: UserInfoVCDelegate {
//    func didRequestFollowers(for username: String) {
//        self.username = username // update our VC with new username from didRequestFollowers() method.
//        title = username
//        page = 1
//        followers.removeAll() // reset the followers array
//        filteredFollowers.removeAll()
//        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true) // scroll up to the first row of items.
//        getFollowers(username: username, page: page)
//    }
//}

