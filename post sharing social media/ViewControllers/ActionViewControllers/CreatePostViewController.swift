//
//  CreatePostViewController.swift
//  post sharing social media
//
//  Created by Вадим on 28.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreatePostViewController: UIViewController {

    var viewModelBuilder: CreatePostViewModel.ViewModelBuilder!
    
    let scrollView = UIScrollView()
    
    var activeTextContainer: UITextInputTraits?
    
    fileprivate var viewModel: CreatePostViewModel!
    
    fileprivate let titleTextField = UITextField()
    fileprivate let bodyTextView: CreatePostTextView! = {
        let placeholder = NSLocalizedString("What do you wanna say?", comment: "post's body text view placeholder :)")
        let textView = CreatePostTextView(placeholderText: placeholder)
        return textView
    }()
    
    fileprivate let resignFirstInputTapGestureRecognizer = UITapGestureRecognizer()

    fileprivate let confirmButton = UIButton()
    fileprivate let cancelButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewModel()
        setupBindings()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        
        scrollView.constraints.forEach({
            if $0.firstAttribute == .height {
                $0.constant = -CreatePostConstants.bodyHeight(with: titleTextField.bounds.height)
            }
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.constraints.forEach({
            if $0.firstAttribute == .height {
                $0.constant = -CreatePostConstants.bodyHeight(with: titleTextField.bounds.height)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeForKeyboardNotifications()
        navigationController?.view.removeGestureRecognizer(resignFirstInputTapGestureRecognizer)
    }
    
    fileprivate func buildViewModel() {
        viewModel = viewModelBuilder(CreatePostViewModel.Input(
            cancelTrigger: cancelButton.rx.tap.asDriver(),
            confirmTrigger: confirmButton.rx.tap.asDriver()
        ))
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.02479641512, green: 0.4400438964, blue: 0.8626013398, alpha: 1)
        setupNavbar()
        setupScrollView()
        setupTitleTextField()
        setupBodyTextView()
    }
    
    fileprivate func setupBindings() {
        
    }
    
    fileprivate func setupNavbar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.02489590272, green: 0.3996174932, blue: 0.7851334214, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        let verifyImg = UIImage(named: "correct"),
            cancelImg = UIImage(named: "cancel")
        
        confirmButton.setBackgroundImage(verifyImg, for: .normal)
        cancelButton.setBackgroundImage(cancelImg, for: .normal)
        
        confirmButton.showsTouchWhenHighlighted = true
        cancelButton.showsTouchWhenHighlighted = true
        
        let barButtonVerify = UIBarButtonItem(customView: confirmButton),
            barButtonCancel = UIBarButtonItem(customView: cancelButton)
        
        navigationItem.setLeftBarButtonItems([barButtonCancel], animated: true)
        navigationItem.setRightBarButtonItems([barButtonVerify], animated: true)
        
    }
    
    func setupScrollView() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(bodyTextView)
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentSize = self.view.frame.size
        scrollView.bounces = true
        
        scrollView.showsVerticalScrollIndicator = false

        scrollView.delegate = self
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        let constraints = [scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                           scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                           scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                           scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func setupTitleTextField() {
        titleTextField.font = UIFont.preferredFont(forTextStyle: .title3)
        titleTextField.adjustsFontForContentSizeCategory = true
        
        titleTextField.placeholder = NSLocalizedString("Your Title here", comment: "placeholder text for post create text field")
        titleTextField.borderStyle = .roundedRect
        
        titleTextField.delegate = self
        
        titleTextField.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8745098039, blue: 0.8941176471, alpha: 1)
        
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = #colorLiteral(red: 0.01884338818, green: 0.2417946458, blue: 0.4914121032, alpha: 1)
        titleTextField.layer.cornerRadius = 5
        
        titleTextField.clipsToBounds = true
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let contentLayoutGuide = scrollView.contentLayoutGuide
        let constraints = [titleTextField.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: CreatePostConstants.titleTop),
                           titleTextField.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: CreatePostConstants.titleLeft)]
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func setupBodyTextView() {
        bodyTextView.font = UIFont.preferredFont(forTextStyle: .body)
        bodyTextView.adjustsFontForContentSizeCategory = true
        
        bodyTextView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8745098039, blue: 0.8941176471, alpha: 1)
        
        bodyTextView.layer.cornerRadius = 8
        bodyTextView.layer.borderWidth = 1
        bodyTextView.layer.borderColor = #colorLiteral(red: 0.01884338818, green: 0.2417946458, blue: 0.4914121032, alpha: 1)
        
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        
        bodyTextView.delegate = self
        
        let contentLayoutGuide = scrollView.contentLayoutGuide
        let constraints = [bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: CreatePostConstants.bodyTopToTitleBottom),
                           bodyTextView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: CreatePostConstants.bodyHorizontal),
                           bodyTextView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor, constant: CreatePostConstants.bodyHorizontal),
                           bodyTextView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: CreatePostConstants.bodyBottom),
                           bodyTextView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, constant: -(CreatePostConstants.bodyHeight(with: titleTextField.bounds.height))),
                           bodyTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -CreatePostConstants.bodyHorizontal * 2)]
        NSLayoutConstraint.activate(constraints)
        
        setupDismissingKeyboardGesture()
    }
    
    fileprivate func setupDismissingKeyboardGesture() {
        resignFirstInputTapGestureRecognizer.addTarget(self, action: #selector(hideKeyboard))
        navigationController?.view.addGestureRecognizer(resignFirstInputTapGestureRecognizer)
    }
    
    @objc fileprivate func hideKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func registerForKeyboardNotifications() {
        
           NotificationCenter.default.addObserver(self, selector:#selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object:nil);
        
           NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object:nil);
    }
    
    fileprivate func removeForKeyboardNotifications() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object:nil);
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object:nil);
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
