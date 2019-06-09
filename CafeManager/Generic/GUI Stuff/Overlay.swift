//
//  Overlay.swift
//  CafeManager
//
//  Created by Denis Kurashko on 04.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation
import UIKit

public class Overlay{
    var overlayView = UIView()
    
    class var shared: Overlay {
        struct Static {
            static let instance: Overlay = Overlay()
        }
        return Static.instance
    }
    
    /// Function to display overlay with activity indicator.
    /// UIView as an input parameter.
    /// Example: LoadingOverlay.shared.showOverlay(view: self.view)
    public func showOverlay(view: UIView) {
        overlayView.frame = view.frame
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor.lightGray
        overlayView.alpha = 0.7
        overlayView.clipsToBounds = false
        view.addSubview(overlayView)
    }
    
    /// Function to hide overlay with activity indicator.
    /// Example: LoadingOverlay.shared.hideOverlayView()
    public func hideOverlayView() {
        overlayView.removeFromSuperview()
    }
}
