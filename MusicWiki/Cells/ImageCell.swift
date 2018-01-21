//
//  ImageCell.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-20.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    var isGradientActive = false
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var parallaxTopCostraint: NSLayoutConstraint!
    @IBOutlet weak var parallaxImageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
    }

    func addGradient(frame: CGRect) {

        if !isGradientActive {
            isGradientActive = true
            let gradientLayer: CAGradientLayer = CAGradientLayer()
            gradientLayer.frame = frame
            gradientLayer.colors = [UIColor.clear.cgColor, themeColor.withAlphaComponent(0.2).cgColor, themeColor.cgColor]
            gradientLayer.locations = [0.0, 0.6, 1.0]
            
            self.layer.addSublayer(gradientLayer)
        }
    }
}
