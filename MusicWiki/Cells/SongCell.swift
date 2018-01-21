//
//  SongCell.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-19.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var featured: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5
    }
}
