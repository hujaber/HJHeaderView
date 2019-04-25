//
//  HeaderView.swift
//  HeaderView
//
//  Created by Hussein Jaber on 23/4/19.
//  Copyright © 2019 Hussein Jaber. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class HJHeaderView: UIView {
    
    enum ProfilePictureAlignment {
        case leading
        case center
    }
    
    private let disposeBag: DisposeBag = .init()
    
    // button that will be added at the left of the view
    private lazy var leftBarButton: UIButton = {
        let leftButton = UIButton()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        leftButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 100)
        leftButton.contentHorizontalAlignment = .leading
        return leftButton
    }()
    
    // title label, centered horizontally
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = self.titleColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.title
        return label
    }()
    
    // blur view behind the main elements
    private lazy var blurView: UIVisualEffectView = {
        let blurVw = UIVisualEffectView()
        blurVw.translatesAutoresizingMaskIntoConstraints = false
        blurVw.effect = UIBlurEffect(style: self.blurEffect)
        return blurVw
    }()
    
    // image view behind the blur view
    private lazy var backgroundImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        return bgImageView
    }()
    
    // profile image view holder
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 82.5 / 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.clipsToBounds = true
        imageView.addParallaxWithMinMax(10)
        imageView.image = profileImage
        return imageView
    }()
    
    // label holding the name (or anything else)
    private lazy var nameLabel: UILabel = {
        let nLabel = UILabel.init(frame: .zero)
        nLabel.translatesAutoresizingMaskIntoConstraints = false
        nLabel.textAlignment = .natural
        nLabel.textColor = self.nameColor
        nLabel.text = "Name Label"
        nLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nLabel.numberOfLines = 1
        return nLabel
    }()

    private lazy var nicknameLabel: UILabel = {
        let nnLabel = UILabel(frame: .zero)
        nnLabel.translatesAutoresizingMaskIntoConstraints = false
        nnLabel.textColor = self.nicknameColor
        nnLabel.textAlignment = .natural
        nnLabel.font = UIFont.systemFont(ofSize: 15)
        nnLabel.numberOfLines = 1
        nnLabel.text = "Nickname Label"
        return nnLabel
    }()
    
    // bar button added at the right side of the view
    private lazy var rightBarButton: UIButton = {
        let rightButton = UIButton(frame: .zero)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.setTitle("Edit", for: .normal)
        return rightButton
    }()
    
    // inclosure image
    private lazy var inclosureImageView: UIImageView = {
        let inclosure = UIImageView()
        inclosure.translatesAutoresizingMaskIntoConstraints = false
        inclosure.isUserInteractionEnabled = true
        inclosure.contentMode = UIView.ContentMode.right
        return inclosure
    }()
    
    private lazy var inclosureTapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        inclosureImageView.addGestureRecognizer(tap)
        inclosureImageView.image = UIImage(named: "inclosureArrow")
        return tap
    }()
    
    var inclosureTap: Observable<UITapGestureRecognizer> {
        return self.inclosureTapGesture.rx.event.asObservable()
    }
    
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var blurEffect: UIBlurEffect.Style = .dark {
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
    
    var name: String = "" {
        didSet {
            if !nameLabel.isDescendant(of: self), profilePictureAlignment != .center {
                addNameLabel()
            }
            nameLabel.text = name
        }
    }
    
    var nameColor: UIColor = .white {
        didSet {
            nameLabel.textColor = nameColor
        }
    }
    
    var nickname: String = "" {
        didSet {
            if !nicknameLabel.isDescendant(of: self), profilePictureAlignment != .center {
                addNicknameLabel()
            }
            nicknameLabel.text = nickname
        }
    }
    
    var nicknameColor: UIColor = UIColor.init(white: 180.0/255, alpha: 0.98) {
        didSet {
            nicknameLabel.textColor = nicknameColor
        }
    }
    
    var leftButtonIsBack: Bool = true {
        didSet {
            if leftButtonIsBack {
                leftBarButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
                leftBarButton.setTitle(nil, for: .normal)
            } else {
                leftBarButton.setImage(nil, for: .normal)
            }
        }
    }
    
    var hasRightInclosureButton: Bool = false {
        didSet {
            if hasRightInclosureButton {
                addRightInclosure()
            } else {
                inclosureImageView.removeFromSuperview()
            }
        }
    }
    
    var leftButtonAction: Observable<Void> {
        return leftBarButton.rx.tap.asObservable()
    }
    
    var rightButtonAction: Observable<Void> {
        return rightBarButton.rx.tap.asObservable()
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
            rightBarButton.setTitle(rightButtonTitle, for: .normal)
        }
    }
    
    var rightButtonTextColor: UIColor? {
        didSet {
            rightBarButton.setTitleColor(rightButtonTextColor, for: .normal)
        }
    }
    
    var leftButtonTitle: String? {
        didSet {
            leftBarButton.setTitle(leftButtonTitle, for: .normal)
            leftButtonIsBack = false
        }
    }
    
    var leftButtonTextColor: UIColor? {
        didSet {
            leftBarButton.setTitleColor(leftButtonTextColor, for: .normal)
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIApplication.shared.keyWindow?.tintColor ?? .black
        translatesAutoresizingMaskIntoConstraints = false
    }

    @discardableResult
    convenience init(in controller: UIViewController) {
        self.init(frame: .zero)
        // add the header to the controllers view
        controller.view.addSubview(self)
        // add constraints to the header taking the following into consideration:
        // 1. the top of the header must be the top of the controllers view
        // 2. leading and trailing constraints have to take into consideration the safe area
        // 3. the bottom anchor is let free until the profile image view is set,
        // since the bottom anchor must be x points far from the images bottom anchor
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: controller.view.topAnchor),
            leadingAnchor.constraint(equalTo: controller.safeLeadingAnchor),
            trailingAnchor.constraint(equalTo: controller.safeTrailingAnchor)
            ])
        // add all views
        addBlurView()
        addImageView()
        // the back button is the reference for all the other labels and buttons aligned at the
        // top of the view. this has to take into consideration the safe area of the controller
        // thus the button is laid out according to the controllers top and not that of the
        // header view
        addBackButton(in: controller)
        addTitleLabel()
        addProfileImageView()
        addNameLabel()
        addNicknameLabel()
        
        // update the bottom anchor of the header, since the profile image has been added and
        // laid out
        bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        // set the navigation bar of the controller to be hiddin
        handleControllerNavigationBarAppearance(controller)
        
    }
    
    private func handleControllerNavigationBarAppearance(_ controller: UIViewController) {
        guard let navigationController = controller.navigationController else {
            Logger.log(type: .info, "Controller is not in a navigation controller stack")
            return
        }
        Logger.log(type: .info, "Navigation controller exists")
        navigationController.setNavigationBarHidden(true, animated: false)
        Logger.log(type: .info, "Navigation bar is hidden? \(navigationController.isNavigationBarHidden) in controller: \(controller.description)")
        // setting the navigation bar to hidden disables the swipe back gesture
        // the following two lines re-enable it
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        navigationController.interactivePopGestureRecognizer?.delegate = self
        
        // listen to the controllers viewWillDisappear function call to show the
        // navigation bar again
        controller
            .rx
            .viewWillDisappear
            .bind { _ in
                if let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    nav.setNavigationBarHidden(false, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // make sure that the view was released from memory and no leaks are found
        print("did deinit view")
    }
}


private extension HJHeaderView {
    private func addRightBarBtn() {
        if !rightBarButton.isDescendant(of: self) {
            addRightBarButton()
        }
    }
    
    private func setProfileInMiddle() {
        self.nameLabel.removeFromSuperview()
        self.nicknameLabel.removeFromSuperview()
        self.profileImageView.removeFromSuperview()
        self.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: leftBarButton.bottomAnchor, constant: 8),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13.5),
            profileImageView.heightAnchor.constraint(equalToConstant: 82.5),
            profileImageView.widthAnchor.constraint(equalToConstant: 82.5),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
    }
    
    private func addBlurView() {
        addSubview(blurView)
        blurView.fillInSuperView()
    }
    
    private func addBackButton(in controller: UIViewController) {
        addSubview(leftBarButton)
        NSLayoutConstraint.activate([
            leftBarButton.topAnchor.constraint(equalTo: controller.safeTopAnchor, constant: 0),
            leftBarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  UIScreen.main.scale * 4),
            leftBarButton.heightAnchor.constraint(equalToConstant: 36)
            ])
    }
    
    private func addTitleLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: leftBarButton.centerYAnchor, constant: -1)
            ])
    }
    
    private func addImageView() {
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        backgroundImageView.fillInSuperView()
    }
    
    private func addProfileImageView() {
        profilePictureAlignment = .leading
        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: leftBarButton.bottomAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: 82.5),
            profileImageView.widthAnchor.constraint(equalToConstant: 82.5)
            ])
    }
    
    private func addNameLabel() {
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor,
                                               constant: -10),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 11),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
            ])
    }
    
    private func addNicknameLabel() {
        self.addSubview(nicknameLabel)
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,
                                                   constant: 11),
            nicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
            ])
    }
    
    private func addRightBarButton() {
        addSubview(rightBarButton)
        NSLayoutConstraint.activate([
            rightBarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightBarButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
    }
    
    private func addRightInclosure() {
        if !inclosureImageView.isDescendant(of: self) {
            addSubview(inclosureImageView)
            NSLayoutConstraint.activate([
                inclosureImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                inclosureImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
                inclosureImageView.heightAnchor.constraint(equalToConstant: 50),
                inclosureImageView.widthAnchor.constraint(equalToConstant: 50)
                ])
        }
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

extension UIViewController {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11, *) {
            return view.safeAreaLayoutGuide.topAnchor
        } else {
            return topLayoutGuide.bottomAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomLayoutGuide.topAnchor
        }
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, *) {
            return view.safeAreaLayoutGuide.leadingAnchor
        } else {
            return view.leadingAnchor
        }
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, *) {
            return view.safeAreaLayoutGuide.trailingAnchor
        } else {
            return view.trailingAnchor
        }
    }
}

extension UIView {
    func fillInSuperView() {
        if let superView = superview {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superView.topAnchor),
                bottomAnchor.constraint(equalTo: superView.bottomAnchor),
                leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                trailingAnchor.constraint(equalTo: superView.trailingAnchor)
                ])
        }
    }
}


extension HJHeaderView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}
