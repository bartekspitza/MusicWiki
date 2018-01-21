//
//  BackCell.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-21.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class BackCell: UITableViewCell {
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        btn.backgroundColor = buttonColor
        btn.setTitleColor(.white, for: UIControlState.normal)
        btn.layer.cornerRadius = 20
    }
}
