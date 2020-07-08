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
import RxDataSources

class HallViewController: UIViewController {
    
    var viewModelBuilder: HallViewModel.ViewModelBuilder!
    
    fileprivate lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = #colorLiteral(red: 0.02188301831, green: 0.3246959746, blue: 0.6436251998, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        layout.scrollDirection = .vertical
        return layout
    }()
    
    fileprivate let createPostButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    fileprivate var viewModel: HallViewModel!
    
    fileprivate let dataSource = RxCollectionViewSectionedAnimatedDataSource<PostSection>(configureCell: {
        (dataSource, collectionView, indexPath, post) -> PostCollectionViewCell in
        
        let postCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellsConstants.postCellIdentifier, for: indexPath) as! PostCollectionViewCell
        
        postCollectionViewCell.configureUI(withModel: post)
        
        return postCollectionViewCell
    })
    
    fileprivate let bag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewModel()
        setupBindings()
        setupUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let widthWithSafeArea = view.safeAreaLayoutGuide.layoutFrame.size.width
        
        layout.estimatedItemSize = CGSize(width: widthWithSafeArea, height: 10)
        layout.invalidateLayout()
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    fileprivate func buildViewModel() {
        viewModel = viewModelBuilder(
            HallViewModel.Input(triggerToFetchPosts: Observable.just(fake()).asDriver(onErrorJustReturn: ()),
                                triggerToCreatePost: createPostButton.rx.tap.asDriver()))
    }
    
    func fake() -> Void {
        
    }
    
    fileprivate func setupUI() {
        setupNavbar()
        setupTableView()
    }
    
    fileprivate func setupBindings() {
        viewModel
            .output
            .posts
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    fileprivate func setupNavbar() {
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.8666666667, green: 0.8745098039, blue: 0.8941176471, alpha: 1)
        //self.navigationController?.navigationBar.isTranslucent = true
        setupNavbarRightItems()
    }
    
    fileprivate func setupNavbarRightItems() {
        // let img = UIImage(named: "exam")
        
        createPostButton.tintColor = #colorLiteral(red: 0, green: 0.09277493507, blue: 0.2684116662, alpha: 1)
        createPostButton.title = "Add post"
        createPostButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.07141517848, blue: 0.2006644607, alpha: 1)], for: .normal)
        
        // createPostButton.setBackgroundImage(img, for: .normal)
        // createPostButton.showsTouchWhenHighlighted = true
        
        // let barButton = UIBarButtonItem(customView: createPostButton)
        
        navigationItem.setLeftBarButtonItems([createPostButton], animated: true)
    }
    
    fileprivate func setupTableView() {
        view.addSubview(collectionView)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        
        collectionView.allowsSelection = false
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCellsConstants.postCellIdentifier)
        
        collectionView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8745098039, blue: 0.8941176471, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        view.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8745098039, blue: 0.8941176471, alpha: 1)
        
        //let heightOffset = self.navigationController?.navigationBar.frame.height ?? 0.0
        
        let constrains = [
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor)]
        NSLayoutConstraint.activate(constrains)
        
        // rx
        
        collectionView
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

extension HallViewController: UICollectionViewDelegateFlowLayout {

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(100)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(100)
//    }
}
