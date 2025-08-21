//
//  INNotifications.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import UIKit

public class INotifications {
    public static func show(message: String, type: INNotificationType = .warning) {
        INotifications.configure( type: type, data: INotificationData(description: message))
    }

    public static func configure(type: INNotificationType = .warning, data: INotificationData? = nil, customStyle: INNotificationStyle? = nil, position: INNotificationPosition = .top) {
        let notificationView = INNotification(with: data ?? INotificationData(), type: type, customStyle: customStyle)

        guard let window = APP_DELEGATE.window else {
            print("Failed to show. No window available")
            return
        }

        notificationView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.tag = 999_000
        window.viewWithTag(999_000)?.removeFromSuperview()
        window.addSubview(notificationView)

        var constraints = [
            NSLayoutConstraint(item: notificationView, attribute: .leading, relatedBy: .equal, toItem: window, attribute: .leadingMargin, multiplier: 1.0, constant: 10.0),
            NSLayoutConstraint(item: notificationView, attribute: .trailing, relatedBy: .equal, toItem: window, attribute: .trailingMargin, multiplier: 1.0, constant: -10.0),
        ]

        switch position {
        case .top:
            constraints.append(NSLayoutConstraint(item: notificationView, attribute: .top, relatedBy: .equal, toItem: window, attribute: .topMargin, multiplier: 1.0, constant: 10.0))
        case .bottom:
            constraints.append(NSLayoutConstraint(item: notificationView, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottomMargin, multiplier: 1.0, constant: 10.0))
        }

        NSLayoutConstraint.activate(constraints)
        notificationView.showNotification()
    }
}
