//
//  PostsViewController.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    @IBOutlet weak var postsTableView: UITableView!
    //External Parameters
    var postViewModel = PostsViewModel()
    let activityIndicator = ActivityIndicator.sharedInstance
    let refreshControl  = RefreshControl.sharedInstance
    let networkManager = NetworkManager()
    var currentPage = 1
    var totalPages = 0
    var selectedCount = 0 {
        didSet {
            self.navigationItem.title = "Selected Posts: \(selectedCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setUpInitialUi()
        getPosts(with: 1)
    }
    //MARK: Register Cells
    func registerCells() {
        self.postsTableView.register(UINib(nibName: POST_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: POST_CELL_IDENTIFIER)
    }
    //Setup required Parameters
    func setUpInitialUi() {
        selectedCount = 0
        postViewModel.delegate = self
        postViewModel.selectionDelegate = self
        networkManager.networkDelegate = self
        refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Data..")
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.postsTableView.addSubview(refreshControl!)
        hideORUnhideActivity(baseView: self.view, postion: .center, isHide: false)
    }
    //MARK: Pull to rfresh
    @objc func pullToRefresh() {
        postViewModel.rows = 0
        selectedCount = 0
        currentPage = 0
        getPosts(with: currentPage)
    }
    //MARK: Api Call
    func getPosts(with offset:Int) {
        if networkManager.hasActiveConnection() {
            currentPage += 1
            let baseUrl = "https://hn.algolia.com/api/v1/search_by_date?tags=story&page=\(offset)"
            postViewModel.fetchPosts(baseUrl: baseUrl, offset: offset, parametres: [:]) { (response, status) in
            }
        }else {
            Helper.showAlert(title: "No Internet Connection..", message: "")
        }
    }
    //MARK: Hide/Unhide Activity
    func hideORUnhideActivity(baseView: UIView, postion: IndicatorPosition, isHide: Bool) {
        if isHide {
            self.activityIndicator?.isHidden = true
            self.activityIndicator?.stopAnimating()
            self.postsTableView.tableFooterView = UIView()
        }else {
            self.activityIndicator?.isHidden = false
            self.activityIndicator?.addToView(baseView: baseView, postion: postion)
            self.activityIndicator?.startAnimating()
        }
    }
}
//MARK: Uitableview methods
extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postViewModel.rows > 0 {
            return postViewModel.rows
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POST_CELL_IDENTIFIER, for: indexPath) as? PostsCell
        cell?.setupDataFromModel(with: postViewModel.posts[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postViewModel.didSelectPost(with: indexPath)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentPage <= totalPages - 1 {
            if indexPath.row == postViewModel.posts.count - 1 {
                hideORUnhideActivity(baseView: tableView.tableFooterView!, postion: .bottom, isHide: false)
                getPosts(with: currentPage)
            }
        }else {
            hideORUnhideActivity(baseView: self.view, postion: .bottom, isHide: true)
        }
    }
}
//MARK: Reload Table if data is available
extension PostsViewController: ReloadDelegate {
    func getTotalPagesCount(count: Int) {
        self.totalPages = count
    }
    func reloadTable(reload: Bool) {
        if reload {
            DispatchQueue.main.async {
                if self.refreshControl!.isRefreshing {
                    self.refreshControl?.endRefreshing()
                }
                self.hideORUnhideActivity(baseView: self.view, postion: .bottom, isHide: true)
                self.postsTableView.reloadData()
            }
        }else{
            hideORUnhideActivity(baseView: self.view, postion: .bottom, isHide: true)
        }
    }
}
//MARK: Get toggle status
extension PostsViewController: SelectionDelegate {
    func getSelectedPosts(count: Int?, indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.selectedCount = count ?? 0
            self.postsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
//MARK: Network Changes
extension PostsViewController: NetworkDelegate {
    func respondsToNetworkChages(isActive: Bool) {
        if isActive {
            getPosts(with: self.currentPage)
        }
    }
}
