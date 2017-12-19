//
//  ViewController.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-15.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit
let buttonColor = rgb(180, 65, 0)
let textColor = rgb(227,190,168)
let themeColor = rgb(20,20,20)
class Artist {
    var name: String!
    var desc: [String]!
    var imageURL: String!
    var topSongs: [[String]]!
    
    func makeFromJson(json: NSDictionary) {
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

var artist = Artist()

class HomeVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var appLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    var loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = themeColor
        self.setNeedsStatusBarAppearanceUpdate()
        configureElements()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func appBecameActive() {
        if searchField.text == "ARTIST NAME" {
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = 1
            pulseAnimation.fromValue = 1
            pulseAnimation.toValue = 0
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
            searchField.layer.add(pulseAnimation, forKey: "opacity")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        artist.reset()
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func configureElements() {
        searchBtn.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width*0.33), height: Int(self.view.frame.height*0.065))
        searchBtn.backgroundColor = .gray
        searchBtn.setTitleColor(.white, for: UIControlState.normal)
        searchBtn.layer.cornerRadius = self.view.frame.height*0.0325
        searchBtn.setTitle("SEARCH", for: UIControlState.normal)
        searchBtn.center = CGPoint(x: Int(self.view.center.x), y: Int(self.view.center.y + self.view.frame.width*0.2))
        
        searchField.delegate = self
        searchField.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width*0.8), height: Int(self.view.frame.height*0.05))
        searchField.tintColor = buttonColor
        searchField.keyboardAppearance = .dark
        searchField.autocapitalizationType = .words
        searchField.center = CGPoint(x: Int(self.view.center.x), y: Int(self.view.center.y - self.view.frame.width*0.2))
        searchField.clearsOnBeginEditing = true
        searchField.text = "ARTIST NAME"
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 0
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        searchField.layer.add(pulseAnimation, forKey: "opacity")
        
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        
        
        self.view.addSubview(loadingIndicator)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func search(_ sender: UIButton) {
        self.view.endEditing(true)
        loadingIndicator.startAnimating()
        let artistName = makeSearchWord()
        artist.name = searchField.text!
        
        let url = NSURL(string: "https://first-rest-api-udemy.herokuapp.com/artist/" + "Post_Malone")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        do {
            let task = try URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                        artist.makeFromJson(json: json)
                    }
                    
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "gotoartist", sender: self)
                    }
                    
                } catch {
                    print("error")
                }
                
            }
            task.resume()
        } catch {
            print("error")
        }
        
        
//        if searchField.text != "ARTIST NAME" {
//            self.view.endEditing(true)
//            loadingIndicator.startAnimating()
//            let artistName = makeSearchWord()
//            artist.name = searchField.text!
//
//            let url = NSURL(string: "https://first-rest-api-udemy.herokuapp.com/artist/" + artistName)!
//            let request = NSMutableURLRequest(url: url as URL)
//            request.httpMethod = "GET"
//
//            do {
//                let task = try URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//                    do {
//                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
//                            artist.makeFromJson(json: json)
//                        }
//
//                        DispatchQueue.main.async {
//                            self.loadingIndicator.stopAnimating()
//                            self.performSegue(withIdentifier: "gotoartist", sender: self)
//                        }
//
//                    } catch {
//                        print("error")
//                    }
//
//                }
//                task.resume()
//            } catch {
//                print("error")
//            }
//        } else {
//            sender.shake(direction: "horizontal", swings: 2.0)
//        }
//
    }
    @IBAction func searchFieldAbandoned(_ sender: UITextField) {
        if sender.text == "" {
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = 1.5
            pulseAnimation.fromValue = 0
            pulseAnimation.toValue = 1
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
            searchField.layer.add(pulseAnimation, forKey: "opacity")
            sender.text = "ARTIST NAME"
        }
    }
    
    @IBAction func searchFieldTapped(_ sender: UITextField) {
        sender.layer.removeAllAnimations()
    }
    @IBAction func json(_ sender: UIButton) {
        print(artist.name)
        print(artist.desc)
        print(artist.imageURL)
    
    }
    func makeSearchWord() -> String {
        return searchField.text!.replacingOccurrences(of: " ", with: "_")
    }
    
    @IBAction
    func unwindSegue(sender: UIStoryboardSegue) {}
}

