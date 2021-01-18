//
//  CTDataLoadingVC.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import UIKit

class CTDataLoadingVC: UIViewController { // GDDataLoadingVC is a superclass, which will be inherited by all VCs that load the data - FavoritesListVC, FollowerListVC and UserInfoVC.
    
    var containerLoadingView: UIView!
    var containerEmptyView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showLoadingView() {
        containerLoadingView = UIView(frame: view.bounds)
        view.addSubview(containerLoadingView)
        
        containerLoadingView.backgroundColor = .systemBackground
        containerLoadingView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.containerLoadingView.alpha = 0.8
        }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerLoadingView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerLoadingView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerLoadingView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerLoadingView?.removeFromSuperview()
            self.containerLoadingView = nil
        }
    }
    
//    func showEmptyStateView(with message: String, in view: UIView) {
//        let emptyStateView = CTEmptyStateView(message: message)
//        emptyStateView.frame = view.bounds
//        view.addSubview(emptyStateView)
//    }
    
    func showEmptyStateView(with message: String) {
        containerEmptyView = UIView(frame: view.bounds)
        view.addSubview(containerEmptyView)
        
        containerEmptyView.backgroundColor = .systemBackground
        containerEmptyView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.containerEmptyView.alpha = 0.8
        }
        let emptyView = CTEmptyStateView(message: "No repos found")
        containerEmptyView.addSubview(emptyView)
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.pinToEdges(of: containerEmptyView)
    }
    
    func dismissEmptyStateView() {
        DispatchQueue.main.async {
            self.containerEmptyView?.removeFromSuperview()
            self.containerEmptyView = nil
        }
    }

}
