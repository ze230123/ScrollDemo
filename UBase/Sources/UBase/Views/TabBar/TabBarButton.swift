//
//  TabBarButton.swift
//  
//
//  Created by 张泽群 on 2022/11/15.
//

import UIKit
import Lottie

/// Tabbar中选项按钮数据
public class TabBarItem: Equatable {
    public static func == (lhs: TabBarItem, rhs: TabBarItem) -> Bool {
        return lhs.id == rhs.id
    }
    /// id
    public let id: String
    /// 标题
    public let title: String
    /// 图标
    public let image: String
    /// 选中图标
    public let selectedImage: String
    /// 是否是大图标（true：会隐藏`title`）
    public let isBigIcon: Bool
    /// 路由地址
    public let routerUrl: String
    /// 图标大小
    public let iconSize: CGFloat

    public let speed: CGFloat
    public let loopMode: AnimateLoopMode

    public let selectedSpeed: CGFloat
    public let selectedLoopMode: AnimateLoopMode

    public var badgeValue: String? {
        didSet {
            badgeChanged?(badgeValue)
        }
    }

    var badgeChanged: ((String?) -> Void)?
    /// 重复点击选中TabBarButton
    public var repeatClickHandler: (() -> Void)?

    deinit {
        debugPrint("TabBarItem deinit")
    }

    public init(id: String, title: String, image: String, selectedImage: String, isBigIcon: Bool, routerUrl: String, iconSize: CGFloat, speed: CGFloat, loopMode: AnimateLoopMode, selectedSpeed: CGFloat, selectedLoopMode: AnimateLoopMode, badgeValue: String? = nil) {
        self.id = id
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.isBigIcon = isBigIcon
        self.routerUrl = routerUrl
        self.iconSize = iconSize
        self.speed = speed
        self.loopMode = loopMode
        self.selectedSpeed = selectedSpeed
        self.selectedLoopMode = selectedLoopMode
        self.badgeValue = badgeValue
    }
}

public enum AnimateLoopMode: Codable {
    case playOne
    case loop
    case `repeat`(count: Float)

    var asLottieLoopMode: LottieLoopMode {
        switch self {
        case .playOne:
            return .playOnce
        case .loop:
            return .loop
        case .repeat(let count):
            return .repeat(count)
        }
    }
}

/// Tabbar中的按钮
public class TabBarButton: UIControl, NibLoadable {
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var imageView: ImageContentView = {
        let imageView = ImageContentView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var badgeView: BadgeView = {
        let view = BadgeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public let item: TabBarItem

    public init(item: TabBarItem) {
        self.item = item
        super.init(frame: .zero)

        addSubview(imageView)

        var layoutConstraints: [NSLayoutConstraint] = [
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: item.iconSize),
            imageView.heightAnchor.constraint(equalToConstant: item.iconSize)
        ]

        if !item.isBigIcon {
            addSubview(titleLabel)
            layoutConstraints.append(contentsOf: [
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
                imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4),
            ])
        } else {
            layoutConstraints.append(imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1))
        }
        NSLayoutConstraint.activate(layoutConstraints)

        item.badgeChanged = { [weak self] (badge) in
            self?.setbadge(badge)
        }
    }

    func setbadge(_ badge: String?) {
        guard let badge = badge else { return }
        if badgeView.superview == nil {
            addSubview(badgeView)
            NSLayoutConstraint.activate([
                badgeView.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 10),
                badgeView.centerXAnchor.constraint(equalTo: imageView.rightAnchor, constant: 3),
            ])
        }
        badgeView.isHidden = badge.intValue <= 0
        var text = badge
        if badge.intValue > 99 {
            text = "99+"
        }
        badgeView.value = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabBarButton {
    class BadgeView: UIView {
        private let label = UILabel()

        var value: String? {
            get {
                return label.text
            }
            set {
                label.text = newValue
                invalidateIntrinsicContentSize()
            }
        }

        override var intrinsicContentSize: CGSize {
            let count = label.text?.count ?? 0
            if count >= 2 {
                return CGSize(width: label.intrinsicContentSize.width + 10, height: 16)
            } else {
                return CGSize(width: 16, height: 16)
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.cornerRadius = 8
            backgroundColor = .red

            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .white
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false

            addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor),
                label.leftAnchor.constraint(equalTo: leftAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),
                label.rightAnchor.constraint(equalTo: rightAnchor)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension TabBarButton {
    public class ImageContentView: UIView {
        private let imageView = UIImageView()
        private let lottieView = LottieAnimationView()

        override init(frame: CGRect) {
            super.init(frame: frame)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)

            lottieView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(lottieView)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.leftAnchor.constraint(equalTo: leftAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.rightAnchor.constraint(equalTo: rightAnchor),
                lottieView.topAnchor.constraint(equalTo: topAnchor),
                lottieView.leftAnchor.constraint(equalTo: leftAnchor),
                lottieView.bottomAnchor.constraint(equalTo: bottomAnchor),
                lottieView.rightAnchor.constraint(equalTo: rightAnchor)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public func load(url: String, speed: CGFloat, loopMode: AnimateLoopMode) {
            guard let source = URL(string: url) else {
                debugPrint("TabBarButton load remote content failure", url)
                return
            }

            let isLottieSource: Bool = url.isLottie || url.isLottie

            lottieView.isHidden = !isLottieSource
            imageView.isHidden = isLottieSource

            lottieView.animationSpeed = speed

            if url.isLottie {
                DotLottieFile.loadedFrom(url: source) { [weak lottieView] result in
                    switch result {
                    case .success(let lottie):
                        lottieView?.loadAnimation(from: lottie)
                        lottieView?.play(toProgress: 1, loopMode: loopMode.asLottieLoopMode)
                    case .failure(let error):
                        debugPrint("TabBarButton load remote lottie file failure", error.localizedDescription)
                    }
                }
            } else if url.isJson {
                LottieAnimation.loadedFrom(url: source) { [weak lottieView] animate in
                    lottieView?.animation = animate
                    lottieView?.play(toProgress: 1, loopMode: loopMode.asLottieLoopMode)
                }
            } else {
                assert(downloader != nil)
                downloader.setImage(url, at: imageView)
            }
        }
    }
}

private extension String {
    var isLottie: Bool {
        return hasSuffix("lottie")
    }

    var isJson: Bool {
        return hasSuffix("json")
    }
}
