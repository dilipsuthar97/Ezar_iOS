//
//  INNotification.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import UIKit

class INNotification: UIView {
    var data: INotificationData
    let titleLabel: UILabel = UILabel()
    let descriptionLabel: UILabel = UILabel()
    let iconImageView: UIImageView = UIImageView()
    let titleDescriptionStackView: UIStackView = UIStackView()

    var verticalMargin: CGFloat = 0.0
    var imageSize: CGSize = CGSize(width: 0, height: 0)

    lazy var viewsDict = ["titleLabel": titleLabel,
                          "descriptionLabel": descriptionLabel,
                          "iconImageView": iconImageView,
                          "titleDescriptionStack": titleDescriptionStackView]

    var viewConstraints: [NSLayoutConstraint] = []
    let type: INNotificationType
    let customStyle: INNotificationStyle?

    public required init?(coder _: NSCoder) {
        fatalError("Not implemented.")
    }

    public init(with data: INotificationData = INotificationData(),
                type: INNotificationType,
                customStyle: INNotificationStyle? = nil) {
        self.data = data
        self.type = type
        self.customStyle = customStyle

        super.init(frame: CGRect.zero)

        configureUI()
        setupGestures()
    }

    private func setupConstraints() {
        addSubview(iconImageView)
        addSubview(titleDescriptionStackView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        setupImageView()
        setupStackView()
        setupTitleDescriptionLabel()
        NSLayoutConstraint.activate(viewConstraints)
        sizeToFit()
    }

    private func setupImageView() {
        viewConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[iconImageView(\(imageSize.width))]-10-[titleDescriptionStack]-10-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: viewsDict)
        viewConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10@750-[iconImageView(\(imageSize.height))]",
                                                          options: [],
                                                          metrics: nil,
                                                          views: viewsDict)
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        setupImage()

        if let image = data.image {
            iconImageView.image = image
        }
    }

    private func setupImage() {
        iconImageView.contentMode = .center
        iconImageView.isHidden = true
        switch type {
        case .success:
            iconImageView.image = "✅".image(size: imageSize)
        case .warning:
            iconImageView.image = "⚠️".image(size: imageSize)
        case .error:
            iconImageView.image = "❌".image(size: imageSize)
        case .custom:
            break
        }
    }

    private func setupStackView() {
        titleDescriptionStackView.axis = NSLayoutConstraint.Axis.vertical
        titleDescriptionStackView.distribution = UIStackView.Distribution.fill
        titleDescriptionStackView.alignment = UIStackView.Alignment.leading
        titleDescriptionStackView.spacing = 8.0

        //titleDescriptionStackView.addArrangedSubview(titleLabel)
        titleDescriptionStackView.addArrangedSubview(descriptionLabel)

        viewConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleDescriptionStack(>=iconImageView)]-10-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: viewsDict)

        titleDescriptionStackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupTitleDescriptionLabel() {
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0

        titleLabel.text = data.title
        descriptionLabel.text = data.description

        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 250.0), for: .vertical)
        descriptionLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251.0), for: .vertical)

        titleLabel.font = FontType.bold(size: 20)
        descriptionLabel.font = FontType.regular(size: 17)
    }

    private func configureUI() {
        
        switch type {
        case .success:
            backgroundColor = Theme.greenColor
        case .warning:
            backgroundColor = Theme.blackColor
        case .error:
            backgroundColor = Theme.redColor
        default:
            backgroundColor = Theme.blackColor
        }
        
        titleLabel.textColor = .white
        descriptionLabel.textColor = .white
        setupCustomStyle()

        switch type {
        case let .custom(view):
            setupCustomView(view: view)
        case .error, .success, .warning:
            setupNormalView()
        }

        setupShadow()
    }

    private func setupNormalView() {
        layer.cornerRadius = 6
        setupConstraints()
    }

    private func setupShadow() {
        layer.shadowColor = Theme.blackColor.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
    }

    private func setupCustomView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(view)

        view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true

        sizeToFit()
        layoutIfNeeded()
    }

    private func setupCustomStyle() {
        guard let customStyle = customStyle else {
            return
        }

        layer.cornerRadius = 6
        backgroundColor = .white
        titleLabel.textColor = .white
        descriptionLabel.textColor = .white
        imageSize = customStyle.imageSize ?? imageSize
    }

    private func setupGestures() {
//        NotificationCenter.default.addObserver(self, selector: #selector(rotateView), name: UIDevice.NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(tappedNotification))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self,
                                                       action: #selector(hideNotification))
        swipeRecognizer.direction = .up

        addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(swipeRecognizer)
    }

    @objc internal func rotateView() {
        UIView.animate(withDuration: 0.2) {
            self.center.x = UIScreen.main.bounds.width / 2
            self.center.y = self.safeAreaInsets.top + self.verticalMargin + self.frame.height / 2
        }
    }

    @objc internal func hideNotification() {
        let translate = CGAffineTransform(translationX: 0, y: -frame.height - 100)

        UIView.animate(withDuration: 0.3, animations: {
            self.transform = translate
        }, completion: { [weak self] (_: Bool) in
            self?.removeFromSuperview()
        })
    }

    @objc internal func removeNotification() {
        let translate = CGAffineTransform(translationX: 0, y: -frame.height - 100)

        UIView.animate(withDuration: 0, animations: {
            self.transform = translate
        }, completion: { [weak self] (_: Bool) in
            self?.removeFromSuperview()
        })
    }

    @objc internal func tappedNotification() {
        hideNotification()
        data.completionHandler?()
    }

    public func showNotification() {
        Timer.scheduledTimer(timeInterval: Double(data.delay),
                             target: self,
                             selector: #selector(hideNotification),
                             userInfo: nil,
                             repeats: false)

        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 0.68,
                       initialSpringVelocity: 0.1,
                       options: UIView.AnimationOptions(),
                       animations: {
                           self.frame.origin.y = self.safeAreaInsets.top + self.verticalMargin
        })
    }
}
