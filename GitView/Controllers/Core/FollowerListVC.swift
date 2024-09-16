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
    var filteredFollowers : [Follower] = []
    var userHaveMoreFollowers : Bool = true
    var page = 1
    let followersCollection = UICollectionView(frame: .zero ,collectionViewLayout: UICollectionViewLayout())
    let emptyStateView = EmptyStateView()
    enum Section {
        case main
    }
    var dataSource : UICollectionViewDiffableDataSource<Section, Follower>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollectionView()
        configureDataSource()
        getFollowers(username: username, page: page)
        configureSearchController()

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
        followersCollection.delegate = self

    }
    
    private func configureSearchController (){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for User"
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username : String , page:Int){
        showLoadingView()
        Task{
            do{
                let result = try await NetworkManager.shared.getFollowers(for: username, page: page)
                await MainActor.run {
                    dismissLoadingView()
                    followers.append(contentsOf: result)
                    if followers.isEmpty {
                        showEmptyStateView(message: "This user has no followers.🤕", view: self.view)
                    }
                }
                if result.count < 100 {userHaveMoreFollowers = false}
                updateData(on: followers)
            }catch let error as NetworkManager.NetworkError{
                presentGitAlertOnMainThread(title: "Oops!", massage: error.localizedDescription, buttonTitle: "OK")
                dismissLoadingView()
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureDataSource (){
        dataSource = UICollectionViewDiffableDataSource(collectionView: followersCollection, cellProvider: { collectionView, indexPath, follower in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCollectionViewCell.identifier, for: indexPath) as? FollowersCollectionViewCell else {return UICollectionViewCell()}
            cell.configureUser(follower: follower)
            
            return cell
        })
    }
    
    private func updateData(on followers:[Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
            self.dataSource?.apply(snapshot , animatingDifferences: true)
    }
}

extension FollowerListVC : UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollHeight = scrollView.contentSize.height
        let contentOffset = scrollView.contentOffset.y
        let height = view.bounds.height
        if  contentOffset > (scrollHeight - height ) {
            guard userHaveMoreFollowers else {return}
            page += 1
            getFollowers(username: username, page: page)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UserInfoViewController()
        let navController = UINavigationController(rootViewController: vc)
        if let searchText = navigationItem.searchController?.searchBar.text , !searchText.isEmpty{
            vc.getUserInfo(userName: filteredFollowers[indexPath.row].login)
        }else{
            vc.getUserInfo(userName: followers[indexPath.row].login)
        }
        
        present(navController, animated: true)
    }
}

extension FollowerListVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else {return}
        if filter.isEmpty{
            updateData(on: followers)
            return
        }
        filteredFollowers = followers.filter({$0.login.lowercased().contains (filter.lowercased())})
        
        updateData(on: filteredFollowers)
    }
    
    
}
