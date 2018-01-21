//
//  Artist.swift
//  MusicWiki
//
//  Created by Bartek  on 2018-01-21.
//  Copyright © 2018 Bartek . All rights reserved.
//

import Foundation

class Artist {
    var name: String!
    var desc: [String]!
    var imageURL: String!
    var topSongs: [[String]]!
    
    func makeFromJson(json: NSDictionary) {
        self.name = json.value(forKey: "name") as! String
        self.desc = json.value(forKey: "description") as! [String]
        self.imageURL = json.value(forKey: "imageURL") as! String
        self.topSongs = json.value(forKey: "Top Songs") as! [[String]]
    }
    
    func reset() {
        self.name = ""
        self.desc = [""]
        self.imageURL = ""
        self.topSongs = [[String]]()
    }
}
