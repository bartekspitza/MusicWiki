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
    
    var thumbnails = [UIImage]()
    var largeImage: UIImage!
    var lyrics = [Int:[[String]]]()
    var loadingIndicator = UIActivityIndicatorView()
    
    var parallaxOffsetSpeed: CGFloat = 450
    var cellHeight: CGFloat = 250
    
    let popupView = UIView()
    let dismissBtn = UIButton()
    let popupHeaderLbl = UILabel()
    let popupText = UITextView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getThumbnails()
        getLargeImage()
        configureTable()
        downloadLyrics()
        setupLoadingIndicator()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configurePopupView()
    }
    
    func setupLoadingIndicator() {
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        loadingIndicator.layer.zPosition = 4
        
        self.view.addSubview(loadingIndicator)
    }
    
    func downloadLyrics() {
        for i in 0..<artist.topSongs.count {
            let json = ["url": artist.topSongs[i][3]]
            
            guard let url = URL(string: "https://first-rest-api-udemy.herokuapp.com/lyrics") else {return}
            var request = URLRequest(url: url)
            guard let httpBody = try? JSONSerialization.data(withJSONObject: json, options: []) else {return}
            
            request.httpMethod = "POST"
            request.httpBody = httpBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, er) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                        self.lyrics[i] = json?.value(forKey: "lyrics") as? [[String]]
                    } catch {
                        print(er as Any)
                    }
                    
                }
            }).resume()
        }
    }
    
    var parallaxImageHeight: CGFloat {
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * self.table.frame.height) - cellHeight) / 2
        return maxOffset + self.cellHeight
    }
    
    func parallaxOffset(newOffsetY: CGFloat, cell: UITableViewCell) -> CGFloat {
        return (newOffsetY - cell.frame.origin.y) / parallaxImageHeight * parallaxOffsetSpeed
    }
    
    func getThumbnails() {
        for i in 0..<artist.topSongs.count {
            do {
                let url = URL(string: artist.topSongs[i][2])
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                thumbnails.append(image!)
            } catch {
                print("error")
            }
        }
    }
    
    func configurePopupView() {
        dismissBtn.frame = self.view.frame
        dismissBtn.backgroundColor = .clear
        dismissBtn.addTarget(self, action: #selector(dismissPopup(sender:)), for: UIControlEvents.touchDown)
        dismissBtn.isHidden = true
        self.view.addSubview(dismissBtn)
        
        popupView.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height*0.9))
        popupView.backgroundColor = .clear
        
        let gradient = CAGradientLayer()
        gradient.frame = popupView.frame
        gradient.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.cornerRadius = 20
        
        popupView.layer.insertSublayer(gradient, at: 0)
        self.view.addSubview(popupView)
        popupView.center.y = self.view.center.y + 1000
        popupView.layer.zPosition = 2
        popupView.layer.cornerRadius = 20
        
        popupText.frame = CGRect(x: 0, y: 0, width: Int(popupView.frame.width*0.98), height: Int(popupView.frame.height) - 3)
        popupText.backgroundColor = .clear
        popupText.isEditable = false
        popupText.isScrollEnabled = true
        popupText.font = UIFont.init(name: "Avenir-Light", size: 15)
        popupText.textColor = .white
        popupView.addSubview(popupText)
        popupText.center = CGPoint(x: Int(popupView.center.x), y: Int(popupView.frame.height) - Int(popupText.frame.height/2))
        popupText.showsVerticalScrollIndicator = false
    }
    
    @objc func dismissPopup(sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.popupView.center.y = self.view.frame.height + self.popupView.frame.height/2 + 2
        }
        sender.isHidden = true
    }
    
    func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.layer.zPosition = 1
        table.tableFooterView = UIView()
        table.tableHeaderView = UIView()
        table.backgroundColor = themeColor
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getLargeImage() {
        do {
            let url = URL(string: artist.imageURL)
            let data = try Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            largeImage = UIImage(data: data)
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return artist.topSongs.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.imgView.image = largeImage
            cell.addGradient(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            cell.parallaxImageHeight.constant = self.parallaxImageHeight
            cell.parallaxTopCostraint.constant = parallaxOffset(newOffsetY: table.contentOffset.y, cell: cell)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: "AboutCell") as! AboutCell
            cell.titleLbl.text! = "ABOUT " + artist.name.uppercased()
            cell.backgroundColor = themeColor
            cell.selectionStyle = .none
            cell.correctSeperator(width: self.view.frame.width)
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: "DescCell") as! DescCell
            cell.descLbl.text = artist.desc[0]
            cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.descLbl.frame.height)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = table.dequeueReusableCell(withIdentifier: "PopularCell") as! PopularCell
            cell.backgroundColor = themeColor
            cell.selectionStyle = .none
            cell.correctSeperator(width: self.view.frame.width)
            return cell
        case 4:
            let cell = table.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
            cell.backgroundColor = .clear
            cell.name.text = artist.topSongs[indexPath.row][0]
            cell.imgView.image = thumbnails[indexPath.row]
            cell.selectionStyle = .none
            
            if artist.topSongs[indexPath.row][1] != artist.name {
                if artist.topSongs[indexPath.row][1].range(of: artist.name) != nil {
                    cell.featured.text = artist.topSongs[indexPath.row][1]
                } else {
                    cell.featured.text = artist.name + " & " + artist.topSongs[indexPath.row][1]
                }
            } else {
                cell.featured.text = artist.name
            }
            return cell
        case 5:
            let cell = table.dequeueReusableCell(withIdentifier: "BackCell", for: indexPath) as! BackCell
            cell.btn.addTarget(self, action: #selector(backBtn(sender:)), for: UIControlEvents.touchUpInside)
            cell.selectionStyle = .none
            return cell
        default:
            print("")
        }

        return cell
    }
    
    @objc func backBtn(sender: UIButton) {
        performSegue(withIdentifier: "gotoadd", sender: self)
    }
    
    func loadLyrics(indexPath: IndexPath) {
        let lyric = lyrics[indexPath.row]
        let desc = NSMutableAttributedString()
        
        func makeIt() {
            for paragraph in lyric! {
                for line in paragraph {
                    let text: NSString = NSString(string: line + "\n")
                    let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: text as String)
                    
                    if line.first == "[" {
                        
                        attributedText.addAttributes([
                            NSAttributedStringKey.font: UIFont.init(name: "AvenirNext-Bold", size: 18)!,
                            NSAttributedStringKey.foregroundColor: buttonColor
                            ], range: NSRange(location: 0, length: line.count))
                        
                    } else {
                        attributedText.addAttributes([
                            NSAttributedStringKey.font: UIFont.init(name: "AvenirNext-Medium", size: 14)!,
                            NSAttributedStringKey.foregroundColor: UIColor.white
                            ], range: NSRange(location: 0, length: line.count))
                    }
                    desc.append(attributedText)
                }
                let pText: NSString = NSString(string:"\n\n")
                let pAttributedText: NSMutableAttributedString = NSMutableAttributedString(string: pText as String)
                desc.append(pAttributedText)
            }
            popupText.attributedText = desc
            popupText.textAlignment = .center
            popupText.isScrollEnabled = true
        }
        
        if lyric != nil {
            makeIt()
            loadingIndicator.stopAnimating()
        } else {
            if !self.loadingIndicator.isAnimating {
                Timer.scheduledTimer(timeInterval: TimeInterval(0.3), target: self, selector: #selector(startLoadingIndicator), userInfo: nil, repeats: false)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.loadLyrics(indexPath: indexPath)
            })
        }
    }
    @objc func startLoadingIndicator() {
        self.loadingIndicator.startAnimating()
    }
    
    func loadDesc() {
        let descText = NSMutableAttributedString()
        for p in artist.desc {
            let text: NSString = NSString(string: p + "\n\n")
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: text as String)
            
            attributedText.addAttributes([
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont.init(name: "AvenirNext-Medium", size: 14)!
                ], range: NSRange(location: 0, length: p.count))
            
            descText.append(attributedText)
        }
        popupText.attributedText = descText
        popupText.textAlignment = .left
        popupText.isScrollEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            dismissBtn.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.popupView.center.y = self.view.frame.height/2 + self.view.frame.height*0.05 + 26
            }, completion: nil)
            loadLyrics(indexPath: indexPath)
        } else if indexPath.section == 2 {
            dismissBtn.isHidden = false
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.popupView.center.y = self.view.frame.height/2 + self.view.frame.height*0.05 + 26
            }, completion: nil)
            
            loadDesc()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if table.contentOffset.y < 0 {
            table.contentOffset = CGPoint.zero
        }
        
        for cell in table.visibleCells {
            if cell.isKind(of: ImageCell.self) {
                let cell = cell as! ImageCell
                cell.parallaxTopCostraint.constant = parallaxOffset(newOffsetY: table.contentOffset.y, cell: cell)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        } else if indexPath.section == 3 || indexPath.section == 1 {
            return 40
        }
        return 70
    }
}
