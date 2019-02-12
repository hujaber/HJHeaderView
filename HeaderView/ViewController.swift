//
//  ViewController.swift
//  HeaderView
//
//  Created by Hussein Jaber on 8/8/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit

// TODO: Add parallax to profile image
// TODO: add RTL support

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let myView = HJHeaderView(in: view)
        myView.profileImage = #imageLiteral(resourceName: "huj.jpg")
        myView.title = "Hello"
        myView.leftBarButtonTargetAction = (self, #selector(back))
        myView.name = "Hussein Jaber"
        myView.nickname = "iOS at Vinelab"
        myView.nicknameColor = UIColor.init(white: 180.0/255, alpha: 0.98)
        myView.profilePictureAlignment = .center
        myView.rightButtonTitle = "Edit"
        myView.profilePictureAlignment = .leading
        myView.rightBarButtonTargetAction = (self, #selector(edit))
    }
    
    @objc func back() {
        print("Back")
    }
    
    @objc func edit() {
        print("edit")
    }
}

class HJHeaderView: UIView {

    enum ProfilePictureAlignment {
        case leading
        case center
    }
    
    private var leftBarButton: UIButton!
    private var titleLabel: UILabel!
    private var blurView: UIVisualEffectView!
    private var backgroundImageView: UIImageView!
    private var profileImageView: UIImageView!
    private var nameLabel: UILabel!
    private var nicknameLabel: UILabel!
    private var rightBarButton: UIButton!
    private var inclosureImageView: UIImageView!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var blurEffect: UIBlurEffectStyle = .dark {
        didSet {
            blurView.effect = UIBlurEffect(style: blurEffect)
        }
    }
    
    var titleColor: UIColor = .white {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var profileImage: UIImage? {
        didSet {
            profileImageView.image = profileImage
            backgroundImageView.image = profileImage
        }
    }
    
    var name: String? {
        didSet {
            if nameLabel == nil, profilePictureAlignment != .center {
                addNameLabel()
            }
            nameLabel.text = name
        }
    }
    
    var nameColor: UIColor? {
        didSet {
            nameLabel.textColor = nameColor
        }
    }
    
    var nickname: String? {
        didSet {
            if nicknameLabel == nil, profilePictureAlignment != .center {
                addNicknameLabel()
            }
            nicknameLabel.text = nickname
        }
    }
    
    var nicknameColor: UIColor? {
        didSet {
            nicknameLabel.textColor = nicknameColor
        }
    }
    
    var shouldLeftBarButtonBeBack: Bool = true {
        didSet {
            if shouldLeftBarButtonBeBack {
                leftBarButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
                leftBarButton.setTitle(nil, for: .normal)
            } else {
                leftBarButton.setImage(nil, for: .normal)
            }
        }
    }
    
    var leftBarButtonTargetAction: (target: Any, action: Selector)? {
        didSet {
            if let target = leftBarButtonTargetAction?.target, let action = leftBarButtonTargetAction?.action {
                leftBarButton.addTarget(target, action: action , for: .touchUpInside)
            }
        }
    }
    
    var rightBarButtonTargetAction: (target: Any, action: Selector)? {
        didSet {
            if rightBarButton == nil {
                addRightBarBtn()
            }
            if let target = rightBarButtonTargetAction?.target, let action = rightBarButtonTargetAction?.action {
                rightBarButton.addTarget(target, action: action, for: .touchUpInside)
            }
        }
    }
    
    var profilePictureAlignment: ProfilePictureAlignment = .leading {
        didSet {
            switch profilePictureAlignment {
            case .center:
                if oldValue == .center { break }
                setProfileInMiddle()
            case .leading:
                if oldValue == .leading { break }
                profileImageView.removeFromSuperview()
                addProfileImageView()
                addNameLabel()
                addNicknameLabel()
            }
        }
    }
    
    var rightButtonTitle: String? {
        didSet {
            addRightBarBtn()
            guard let rightButton = rightBarButton else { return }
            rightButton.setTitle(rightButtonTitle, for: .normal)
        }
    }
    
    var rightButtonColor: UIColor? {
        didSet {
            rightBarButton.setTitleColor(rightButtonColor, for: .normal)
        }
    }
    
    var leftButtonTitle: String? {
        didSet {
            leftBarButton.setTitle(leftButtonTitle, for: .normal)
            shouldLeftBarButtonBeBack = false
        }
    }
    
    var leftButtonColor: UIColor? {
        didSet {
            leftBarButton.setTitleColor(leftButtonColor, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        addBlurView()
        addImageView()
        addBackButton()
        addTitleLabel()
        addProfileImageView()
        addNameLabel()
        addNicknameLabel()
    }
    
    @discardableResult
    convenience init(in view: UIView) {
        self.init(frame: .zero)
        let constraints = self.getConstraintsForView(view)
        view.addSubview(self)
        view.addConstraints(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addRightBarBtn() {
        if rightBarButton == nil {
            addRightBarButton()
        }
    }
    
    private func setProfileInMiddle() {
        self.nameLabel.removeFromSuperview()
        self.nicknameLabel.removeFromSuperview()
        self.profileImageView.removeFromSuperview()
        
        let top = NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: leftBarButton, attribute: .bottom, multiplier: 1, constant: 8)
        let bottom = NSLayoutConstraint(item: profileImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -13.5)
        let height = NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 82.5)
        let width = NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 82.5)
        let center = NSLayoutConstraint(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        self.addSubview(profileImageView)
        self.addConstraints([top, bottom, height, width, center])
    }
    
    private func addBlurView() {
        blurView = UIVisualEffectView(frame: .zero)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 1.0
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let top = NSLayoutConstraint(item: blurView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: blurView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: blurView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: blurView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        self.addSubview(blurView)
        self.addConstraints([top, bottom, leading, trailing])
    }

    func getConstraintsForView(_ view: UIView) -> [NSLayoutConstraint] {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 164)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        return [heightConstraint, leadingConstraint, trailingConstraint, topConstraint]
    }
    
    private func addBackButton() {
        leftBarButton = UIButton(frame: .zero)
        leftBarButton.translatesAutoresizingMaskIntoConstraints = false
        leftBarButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        leftBarButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 100)
        
        let top = NSLayoutConstraint(item: leftBarButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 24)
        let leading = NSLayoutConstraint(item: leftBarButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 8)
        let height = NSLayoutConstraint(item: leftBarButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 36)
        self.addSubview(leftBarButton)
        self.addConstraints([top, leading, height])
    }
    
    private func addTitleLabel() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: leftBarButton, attribute: .centerY, multiplier: 1, constant: -1)
        self.addSubview(titleLabel)
        self.addConstraints([centerX, centerY])
    }
    
    private func addImageView() {
        backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        let top = NSLayoutConstraint.constraint(attribute: .top, firstItem: backgroundImageView, secondItem: self)
        let bottom = NSLayoutConstraint.constraint(attribute: .bottom, firstItem: backgroundImageView, secondItem: self)
        let trailing = NSLayoutConstraint.constraint(attribute: .trailing, firstItem: backgroundImageView, secondItem: self)
        let leading = NSLayoutConstraint.constraint(attribute: .leading, firstItem: backgroundImageView, secondItem: self)
        self.addSubview(backgroundImageView)
        self.sendSubview(toBack: backgroundImageView)
        self.addConstraints([top, bottom, trailing, leading])
    }
    
    private func addProfileImageView() {
        profilePictureAlignment = .leading
        profileImageView = UIImageView(frame: .zero)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 82.5 / 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 1.0
        profileImageView.clipsToBounds = true
        profileImageView.addParallaxWithMinMax(10)
        profileImageView.image = profileImage
        
        let top = NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: leftBarButton, attribute: .bottom, multiplier: 1, constant: 8)
        let bottom = NSLayoutConstraint(item: profileImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -13.5)
        let leading = NSLayoutConstraint(item: profileImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20)
        let height = NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 82.5)
        let width = NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 82.5)
        self.addSubview(profileImageView)
        self.addConstraints([top, bottom, leading, width, height])
    }
    
    private func addNameLabel() {
        nameLabel = UILabel.init(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .natural
        nameLabel.textColor = .white
        nameLabel.text = "Name Label"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.numberOfLines = 1
    
        let centerY = NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: profileImageView, attribute: .centerY, multiplier: 1, constant: -10)
        let leading = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 11)
        let trailing = NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -32)
        self.addSubview(nameLabel)
        self.addConstraints([centerY, leading, trailing])
    }
    
    private func addNicknameLabel() {
        nicknameLabel = UILabel(frame: .zero)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.textColor = .white
        nicknameLabel.textAlignment = .natural
        nicknameLabel.font = UIFont.systemFont(ofSize: 15)
        nicknameLabel.numberOfLines = 1
        nicknameLabel.text = "Nickname Label"
        
        let top = NSLayoutConstraint(item: nicknameLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: -2)
        let leading = NSLayoutConstraint(item: nicknameLabel, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 11)
        let trailing = NSLayoutConstraint(item: nicknameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -32)
        self.addSubview(nicknameLabel)
        self.addConstraints([top, leading, trailing])
    }
    
    private func addRightBarButton() {
        rightBarButton = UIButton(frame: .zero)
        rightBarButton.translatesAutoresizingMaskIntoConstraints = false
        rightBarButton.setTitleColor(UIColor.white, for: .normal)
        rightBarButton.setTitle("Edit", for: .normal)
        
        let trailing = NSLayoutConstraint(item: rightBarButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16)
        let centerY = NSLayoutConstraint(item: rightBarButton, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0)
        addSubview(rightBarButton)
        addConstraints([trailing, centerY])
    }
    
    private func addRightInclosure() {
        inclosureImageView = UIImageView(frame: .zero)
        inclosureImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let trailing = NSLayoutConstraint(item: inclosureImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16)
        let centerY = NSLayoutConstraint(item: inclosureImageView, attribute: .centerY, relatedBy: .equal, toItem: profileImageView, attribute: .centerY, multiplier: 1, constant: 0)
        addSubview(inclosureImageView)
        addConstraints([trailing, centerY])
    }
    
}

extension UIView {
    func addParallaxWithMinMax(_ minMax: CGFloat) {
        let min: CGFloat = -minMax
        let max: CGFloat = minMax
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion, yMotion]
        
        self.addMotionEffect(motionEffectGroup)
    }
}

extension NSLayoutConstraint {
    
    static func constraint(attribute: NSLayoutAttribute, firstItem: Any, secondItem: Any?) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: firstItem, attribute: attribute, relatedBy: .equal, toItem: secondItem, attribute: attribute, multiplier: 1, constant: 0)
        return constraint
    }
}
