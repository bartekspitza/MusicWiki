//
//  Functions.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-15.
//  Copyright © 2017 Bartek . All rights reserved.
//

import Foundation
import UIKit

func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Float = 1.0) -> UIColor {
//    return UIColor.init(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: CGFloat(alpha))
    return UIColor(
        red: CGFloat(red) / 255.0,
        green: CGFloat(green) / 255.0,
        blue: CGFloat(blue) / 255.0,
        alpha: CGFloat(alpha)
    )
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        for url in link {
            guard let url = URL(string: link) else { return }
            downloadedFrom(url: url, contentMode: mode)
        }
    }
}

extension UIButton {
    
    func shake(direction: String, swings: Float) {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = swings
        shake.autoreverses = true
        
        var fromPoint: CGPoint!
        var fromValue: NSValue!
        var toPoint: CGPoint!
        var toValue: NSValue!
        
        
        if direction == "vertical" {
            fromPoint = CGPoint(x: center.x, y: center.y)
            fromValue = NSValue(cgPoint: fromPoint)
            
            toPoint = CGPoint(x: center.x, y: center.y+5)
            toValue = NSValue(cgPoint: toPoint)
        } else if direction == "horizontal" {
            fromPoint = CGPoint(x: center.x, y: center.y)
            fromValue = NSValue(cgPoint: fromPoint)
            
            toPoint = CGPoint(x: center.x+10, y: center.y)
            toValue = NSValue(cgPoint: toPoint)
        }
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
