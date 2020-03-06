//
//  PostsViewModel.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation

protocol ReloadDelegate {
    func reloadTable(reload: Bool)
    func getTotalPagesCount(count: Int)
}
protocol SelectionDelegate {
    func getSelectedPosts(count: Int?, indexPath:IndexPath)
}

class PostsViewModel {
    
    var posts = [PostsModel]()
    let serviceManger = ServiceManager.sharedInstance
    var delegate:ReloadDelegate?
    var selectionDelegate:SelectionDelegate?
    var rows = 0
    
    func fetchPosts(baseUrl: String?, offset:Int?, parametres: [String:Any]?, completionHandler:([String:Any]?, StatusMessage?)->()) {
        serviceManger?.makeServerRequest(with: baseUrl, parameters: parametres, completionHandler: { (response, statusMsg) in
            switch statusMsg {
            case .success:
                if offset == 0 || offset == 1 {
                    self.posts.removeAll()
                    guard let count = response?["nbPages"] as? Int else { return }
                    self.delegate?.getTotalPagesCount(count: count)
                }
                guard let hits = response?["hits"] as? NSArray else { return }
                for post in hits {
                    var mutablePost = post as? [String:Any]
                    mutablePost?["isSelected"] = false
                    let model = PostsModel(with: mutablePost)
                    self.posts.append(model)
                }
                self.rows = self.posts.count
                if hits.count > 0 {
                    self.delegate?.reloadTable(reload: true)
                }else {
                   self.delegate?.reloadTable(reload: false)
                }
            case .failure:
                Helper.showAlert(title: "Data Error", message: "")
            case .error:
                Helper.showAlert(title: "Error", message: "")
            case .none:
               Helper.showAlert(title: "Error", message: "")
            }

        })
    }
    func didSelectPost(with indexPath: IndexPath) {
        var post = self.posts[indexPath.row]
        if post.postSelected == true {
            post.postSelected = false
        }else {
            post.postSelected = true
        }
        self.posts[indexPath.row] = post
        let filtered = self.posts.filter { $0.postSelected == true }
        let count = filtered.count
        self.selectionDelegate?.getSelectedPosts(count: count, indexPath: indexPath)
    }
}
