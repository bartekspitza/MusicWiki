//
//  PopularCell.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-20.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class PopularCell: UITableViewCell {
    var seperator: UIView!
    let gradient = CAGradientLayer()
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seperator = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.frame.width), height: 1))
        seperator.center = CGPoint(x: self.center.x, y: self.frame.height-4)
        self.addSubview(seperator)
        
        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5)
        gradient.colors = [UIColor.clear.cgColor, buttonColor.cgColor, buttonColor.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.locations = [0.0, 0.4, 0.6, 1.0]
        seperator.layer.addSublayer(gradient)
    }
    
    func correctSeperator(width: CGFloat) {
        seperator.frame = CGRect(x: 0, y: 0, width: width, height: 1)
        seperator.center = CGPoint(x: width/2, y: self.frame.height-4)
        gradient.frame = CGRect(x: 0, y: 0, width: width, height: 0.5)
    }
}
