//
//  FollowerListVC.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/24/1403 AP.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var username: String = ""
    var followers : [Follower] = []
    let followersCollection = UICollectionView(frame: .zero ,collectionViewLayout: UICollectionViewLayout())
    enum Section {
        case main
    }
    var dataSource : UICollectionViewDiffableDataSource<Section, Follower>?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollectionView()
        configureDataSource()
        Task{
            do{
                let result = try await NetworkManager.shared.getFollowers(for: username, page: 1)
                followers = result
                updateData()
            }catch let error as NetworkManager.NetworkError{
                presentGitAlertOnMainThread(title: "Oops!", massage: error.localizedDescription, buttonTitle: "OK")
                print(error.localizedDescription)
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        followersCollection.frame = view.bounds
    }
    
    private func configureVC (){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView () {
        followersCollection.register(FollowersCollectionViewCell.self, forCellWithReuseIdentifier: FollowersCollectionViewCell.identifier)
        followersCollection.setCollectionViewLayout(UIHelper.configureCollectionFlowLayout(view: view), animated: true)
        view.addSubview(followersCollection)

    }
    
    private func configureDataSource (){
        dataSource = UICollectionViewDiffableDataSource(collectionView: followersCollection, cellProvider: { collectionView, indexPath, follower in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCollectionViewCell.identifier, for: indexPath) as? FollowersCollectionViewCell else {return UICollectionViewCell()}
            cell.configureUser(follower: follower)
            return cell
        })
    }
    
    private func updateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource?.apply(snapshot , animatingDifferences: true)
    }
}

