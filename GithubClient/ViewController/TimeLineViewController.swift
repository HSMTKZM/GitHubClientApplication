//
//  TimeLineViewController.swift
//  GithubClient
//
//  Created by 倉田　隆成 on 2018/06/29.
//  Copyright © 2018年 倉田　隆成. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

final class TimeLineViewController: UIViewController {
    
    fileprivate var viewModel: UserListViewModel!
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        //tableViewを作成
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeLineCell.self, forCellReuseIdentifier: "TimeLineCell")
        view.addSubview(tableView)
        
        //UIRefreshControlを生成し、リフレッシュした時に呼ばれるメソッドを定義し、tableview.refreshControlにセットしている
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        //UserListViewModelを生成し、通知を受け取った時の処理を定義している
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = {[weak self] state in
            switch state {
            case .loading:
                self?.tableView.isUserInteractionEnabled = false
                break
            case .finish:
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                break
            case .error(let error):
                self?.tableView.isUserInteractionEnabled = true
                self?.refreshControl.endRefreshing()
                
                let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                
                alertController.addAction(alertAction)
                self?.present(alertController, animated: true, completion: nil)
                break
            }
        }
            //ユーザー一覧取得
            viewModel.getUsers()
        }
        
        @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
            //リフレッシュした時、ユーザー一覧取得している
            viewModel.getUsers()
    }
    
}


extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    //viewModel.usersCountをtableViewのcellの数として設定している
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let timelineCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineCell {
            //そのcellのUserCellViewModelを取得、timeLineCellに対して、nicknameとiconをセットしている
            let cellViewModel = viewModel.cellViewModels[indexPath.row]
            timelineCell.setNickName(nickname: cellViewModel.nickName)
            
            cellViewModel.downloadImage{ (progress) in
                switch progress {
                case .loading(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .finish(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .error:
                    break
                }
            }
            return timelineCell
        }
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    
    
    //そのcellのUserCellViewModelを取得し、そのユーザーのgithubページへ画面遷移している
    let cellViewModel = viewModel.cellViewModels[indexPath.row]
    let webURL = cellViewModel.webURL
    let webViewController = SFSafariViewController(url: webURL)
    navigationController?.pushViewController(webViewController,
    animated: true)
        
    }
}

