//
//  ViewController.swift
//  HeaderView
//
//  Created by Hussein Jaber on 8/8/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import RxSwift

// TODO: Add parallax to profile image
// TODO: add RTL support

class ViewController: UIViewController {
    private let disposeBag: DisposeBag = .init()

    private var headerView: HJHeaderView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = .init(in: self)
        headerView.profileImage = UIImage(named: "huj.jpg")
        headerView.title = "Profile"
        
        headerView
            .leftButtonAction
            .bind { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        headerView.name = "Hussein Jaber"
        headerView.profilePictureAlignment = .leading
        headerView.rightButtonTitle = "Edit"
        headerView.hasRightInclosureButton = true
        
        headerView
            .inclosureTap
            .bind { [weak self] tap in
                guard let self = self else { return }
                Logger.log(type: .info, "did tap inclosure button")
//                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController_2") as! ViewController_2
//                
//                self.navigationController?.pushViewController(controller, animated: true)
            }
            .disposed(by: disposeBag)
    }

    
    deinit {
        print("view controller is now nil")
    }
}
