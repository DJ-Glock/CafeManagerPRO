//
//  LoadingOverlay.swift
//  CafeManager
//
//  Created by Denis Kurashko on 26.09.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay{
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    /// Function to display overlay with activity indicator.
    /// UIView as an input parameter.
    /// Example: LoadingOverlay.shared.showOverlay(view: self.view)
    public func showOverlay(view: UIView) {
        overlayView.frame = view.frame
        overlayView.center = view.center
        overlayView.backgroundColor = ColorThemes.backgroundColor
        overlayView.alpha = 0.7
        overlayView.clipsToBounds = false
        //overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = view.frame
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.lightGray
        activityIndicator.center = view.center
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        view.bringSubview(toFront: overlayView)
        activityIndicator.startAnimating()
    }
    
    /// Function to hide overlay with activity indicator.
    /// Example: LoadingOverlay.shared.hideOverlayView()
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
