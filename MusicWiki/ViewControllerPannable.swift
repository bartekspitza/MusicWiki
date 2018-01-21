//
//  ViewControllerPannable.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-19.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class ViewControllerPannable: UIViewController {
    var panGesture: UIPanGestureRecognizer?
    var originalPos: CGPoint?
    var currentPosTouched: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture!)
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPos = view.center
            currentPosTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            if translation.y > 0 {
                view.frame.origin.y = translation.y
                print(translation.y)
            }
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1000 {
                UIView.animate(withDuration: 0.25
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.center = self.originalPos!
                })
            }
        }
    }
}
