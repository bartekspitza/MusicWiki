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
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seperator = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.frame.width*0.75), height: 1))
        seperator.backgroundColor = .darkGray
        self.addSubview(seperator)
        
        seperator.center = CGPoint(x: self.center.x, y: self.frame.height-4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
