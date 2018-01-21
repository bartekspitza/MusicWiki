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
    @IBOutlet weak var lyricsbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5
        lyricsbtn.backgroundColor = .gray
        lyricsbtn.setTitleColor(.white, for: UIControlState.normal)
        lyricsbtn.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        lyricsbtn.layer.cornerRadius = lyricsbtn.frame.width/4
        lyricsbtn.center = CGPoint(x: self.frame.width - 20 - lyricsbtn.frame.width/2, y: self.center.y)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
