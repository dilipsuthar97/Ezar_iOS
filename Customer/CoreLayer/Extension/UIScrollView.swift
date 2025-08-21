//
//  UIScrollView.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

extension UIScrollView {
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    /// Animate scroll to bottom with completion
    ///
    ///   - Parameters:
    ///   - duration:   TimeInterval
    ///   - completion: Completion block
    public func animateScrollToBottom(withDuration duration:  TimeInterval,
                               completion:             (()->())? = nil) {
        
        UIView.animate(withDuration: duration,
                       animations: { [weak self] in
            self?.setContentOffset(CGPoint.zero, animated: false)
            }, completion: { finish in
                if finish { completion?() }
        })
    }
    
    /// Animate scroll to top with completion
    ///
    ///   - Parameters:
    ///   - duration:   TimeInterval
    ///   - completion: Completion block
    public func animateScrollToTop(withDuration duration:  TimeInterval,
                                   yValues: CGFloat = 0,
                                  completion: (()->())? = nil) {
        UIView.animate(withDuration: duration,
                       animations: { [weak self] in
            guard let `self` = self else {
                return
            }
            let desiredOffset = CGPoint(x: 0, y: -self.contentInset.top - yValues)
            self.setContentOffset(desiredOffset, animated: false)
            
            }, completion: { finish in
                if finish { completion?() }
        })
    }
}
