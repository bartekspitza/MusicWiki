//
//  ArtistVC.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-15.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit


class ArtistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    var gradientOverImage = UIView()
    
    let titles = ["ABOUT THE ARTIST", "POPULAR SONGS"]
    var thumbnails = [UIImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getThumbnails()
        placeImageView()
        placeArtistLbl()
        configureTable()
        self.view.backgroundColor = themeColor
        descLbl.isHidden = true
        backButton.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width*0.33), height: Int(self.view.frame.height*0.065))
        backButton.backgroundColor = .gray
        backButton.setTitleColor(.white, for: UIControlState.normal)
        backButton.layer.cornerRadius = self.view.frame.height*0.0325
        backButton.setTitle("BACK", for: UIControlState.normal)
        backButton.center = CGPoint(x: Int(self.view.center.x), y: Int(self.view.frame.height*0.95))
        backButton.layer.zPosition = 2
        
    }
    
    func getThumbnails() {
        for i in 0..<5 {
            do {
                let url = URL(string: artist.topSongs[i][2])
                let data = try Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                let image = UIImage(data: data)
                thumbnails.append(image!)
            } catch {
                print("error")
            }
        }
    }
    
    func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.frame = CGRect(x: 0, y: Int(self.view.frame.height*0.4), width: Int(self.view.frame.width), height: Int(self.view.frame.height*0.55))
        table.layer.zPosition = 1
        table.tableFooterView = UIView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.allowsSelection = false
    }
    
    func placeArtistLbl() {
        artistLbl.layer.zPosition = 3
        artistLbl.text = artist.name
        artistLbl.center = CGPoint(x: Int(40 + artistLbl.frame.width/2), y: Int(self.view.frame.height*0.34))
        descLbl.text = artist.desc[0]
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func back(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoadd", sender: self)
    }
    
    func placeImageView() {
        let image = UIImageView()
        image.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height*0.4))
        image.layer.zPosition = 1
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, themeColor.withAlphaComponent(0.2).cgColor, themeColor.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height*0.4))
        gradientLayer.locations = [0.0, 0.6, 1.0]

        image.layer.addSublayer(gradientLayer)
        self.view.addSubview(image)
        

        do {
            let url = URL(string: artist.imageURL)
            let data = try Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            image.image = UIImage(data: data)
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return artist.topSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 1 {
            let cell = table.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
            cell.backgroundColor = .clear
            cell.name.text = artist.topSongs[indexPath.row][0]
            cell.imgView.image = thumbnails[indexPath.row]
            cell.imgView.layer.cornerRadius = 5
            if artist.topSongs[indexPath.row][1] != artist.name {
                cell.featured.text = artist.name + " & " + artist.topSongs[indexPath.row][1]
            } else {
                cell.featured.text = artist.name
            }
            
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.init(name: "Futura-Medium", size: 17)
            cell.textLabel?.text = artist.desc[0]
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let text = titles[section]
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 15, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont.init(name: "Futura-Medium", size: 11)
        headerLabel.textColor = .white
        headerLabel.text = text
        headerLabel.sizeToFit()
        headerLabel.center.x = 10 + headerLabel.frame.width/2
        headerLabel.textAlignment = .center
        
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        return 70
    }
}
