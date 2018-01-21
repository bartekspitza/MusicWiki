//
//  DescCell.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-19.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class DescCell: UITableViewCell {


    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moreBtn.backgroundColor = .gray
        moreBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        moreBtn.layer.cornerRadius = moreBtn.frame.width/4
        moreBtn.center = CGPoint(x: self.frame.width - 20 - moreBtn.frame.width/2, y: self.center.y)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
