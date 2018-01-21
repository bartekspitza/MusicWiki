//
//  ImageCell.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-20.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.clear.cgColor, themeColor.withAlphaComponent(0.2).cgColor, themeColor.cgColor]
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: Int(self.frame.width), height: Int(self.view.frame.height*0.4))
//        gradientLayer.locations = [0.0, 0.6, 1.0]
//
//        imgView.layer.addSublayer(gradientLayer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
