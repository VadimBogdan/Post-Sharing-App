//
//  HallVC.swift
//  post sharing social media
//
//  Created by Вадим on 26.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

class HallViewController: UIViewController {
    
    var viewModelBuilder: HallViewModel.ViewModelBuilder!
    
    fileprivate let tableView = UITableView()
    fileprivate let createPostButton = UIButton()
    
    fileprivate var viewModel: HallViewModel!
    
    fileprivate let dataSource = RxTableViewSectionedAnimatedDataSource<PostSection>(configureCell: {
        (dataSource, tableView, indexPath, post) -> PostTableViewCell in
        
        let postTableViewCell = tableView.dequeueReusableCell(withIdentifier:
            TableViewCellsConstants.postCellIdentifier, for: indexPath) as! PostTableViewCell
        
        postTableViewCell.configureUI(withModel: post)
        
        return postTableViewCell
    })
    
    fileprivate let bag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewModel()
        setupBindings()
        setupUI()
    }
    
    fileprivate func buildViewModel() {
        viewModel = viewModelBuilder(
            HallViewModel.Input(triggerToFetchPosts: Observable.just(fake()).asDriver(onErrorJustReturn: ()),
                                triggerToCreatePost: createPostButton.rx.tap.asDriver()))
    }
    
    func fake() -> Void {
        
    }
    
    fileprivate func setupBindings() {
        viewModel.output.posts.drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    fileprivate func setupUI() {
        setupNavbar()
        setupTableView()
    }
    
    fileprivate func setupNavbar() {
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.isTranslucent = true
        setupNavbarRightItems()
    }
    
    fileprivate func setupNavbarRightItems() {
        let img = UIImage(named: "exam")
        createPostButton.setImage(img, for: .normal)
        createPostButton.showsTouchWhenHighlighted = true
        let barButton = UIBarButtonItem(customView: createPostButton)
        
        navigationItem.setLeftBarButtonItems([barButton], animated: true)
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.refreshControl = UIRefreshControl()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: TableViewCellsConstants.postCellIdentifier)
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
        //let heightOffset = self.navigationController?.navigationBar.frame.height ?? 0.0
        
        let constrains = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)]
        NSLayoutConstraint.activate(constrains)
        
        // rx
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HallViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //PostTableViewCell.calculateExpectedHeightOfViews()
    }
}
