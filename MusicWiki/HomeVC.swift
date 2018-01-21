//
//  ViewController.swift
//  MusicWiki
//
//  Created by Bartek  on 2017-12-15.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

let buttonColor = rgb(255, 90, 0)
let textColor = rgb(227,190,168)
let themeColor = rgb(15,15,15)
let gradientColor1 = rgb(35, 35, 35)
let gradientColor2 = rgb(8, 8, 8)

var artist = Artist()

class HomeVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var appLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    var loadingIndicator = UIActivityIndicatorView()
    let pulseSpeed = 0.9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeGradient()
        self.setNeedsStatusBarAppearanceUpdate()
        configureElements()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        artist.reset()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        resetElements()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func makeGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func resetElements() {
        searchField.isEnabled = true
        
        loadingIndicator.center.y = searchBtn.center.y
        loadingIndicator.center.x = -loadingIndicator.frame.width
        
        loadingLbl.center.x = -loadingLbl.frame.width
        loadingLbl.center.y = searchBtn.center.y
        loadingLbl.text = "Looking for artist"
        
        searchBtn.center = CGPoint(x: Int(self.view.center.x), y: Int(self.view.center.y + self.view.frame.width*0.2))
    }
    
    @objc func appBecameActive() {
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = pulseSpeed
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 0
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        searchField.layer.add(pulseAnimation, forKey: "opacity")
        if searchField.text != "ARTIST NAME" {
            searchField.layer.removeAllAnimations()
        }
        
    }
    
    func configureElements() {
        searchBtn.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width*0.33), height: Int(self.view.frame.height*0.065))
        searchBtn.backgroundColor = buttonColor
        searchBtn.setTitleColor(.white, for: UIControlState.normal)
        searchBtn.layer.cornerRadius = self.view.frame.height*0.0325
        searchBtn.setTitle("SEARCH", for: UIControlState.normal)
        searchBtn.center = CGPoint(x: Int(self.view.center.x), y: Int(self.view.center.y + self.view.frame.width*0.2))
        
        searchField.delegate = self
        searchField.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width*0.8), height: Int(self.view.frame.height*0.075))
        searchField.tintColor = buttonColor
        searchField.keyboardAppearance = .dark
        searchField.keyboardType = .asciiCapable
        searchField.autocapitalizationType = .words
        searchField.center = CGPoint(x: Int(self.view.center.x), y: Int(self.view.center.y - self.view.frame.width*0.2))
        searchField.clearsOnBeginEditing = true
        searchField.text = "ARTIST NAME"
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = pulseSpeed
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 0
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        searchField.layer.add(pulseAnimation, forKey: "opacity")
        
        loadingIndicator.center.y = searchBtn.center.y
        loadingIndicator.center.x = -loadingIndicator.frame.width
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        loadingLbl.center.x = -loadingLbl.frame.width
        loadingLbl.center.y = searchBtn.center.y
        loadingLbl.sizeToFit()
        
        self.view.addSubview(loadingIndicator)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func loadingAnimations(to: String) {
        if to == "Offscreen" {
            UIView.animate(withDuration: 0.2) {
                self.searchBtn.center.x = self.view.frame.width + self.searchBtn.frame.width
            }
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                self.loadingIndicator.center.x = self.view.center.x + self.loadingLbl.frame.width/2 + self.loadingIndicator.frame.width/2 + 20
                self.loadingLbl.center = CGPoint(x: Int(self.view.center.x), y: Int(self.searchBtn.center.y))
            }, completion: nil)
        } else if to == "Screen" {
    
            UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
                self.loadingIndicator.center.x = -self.loadingIndicator.frame.width
                self.loadingLbl.center.x = -self.loadingLbl.frame.width
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 1.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                self.searchBtn.center = CGPoint(x: Int(self.view.center.x), y: Int(self.view.center.y + self.view.frame.width*0.2))
            }, completion: { (true) in
                self.loadingLbl.text = "Looking for artist"
                self.loadingLbl.sizeToFit()
                self.searchField.isEnabled = true
            })
            
        }
    }
    
    @IBAction func search(_ sender: UIButton) {
        if searchField.text != "ARTIST NAME" && searchField.text != ""{
            self.view.endEditing(true)
            loadingLbl.alpha = 1
            searchField.isEnabled = false
            loadingAnimations(to: "Offscreen")
            loadingIndicator.startAnimating()
            let artistName = makeSearchWord()
        
            let url = URL(string: "https://first-rest-api-udemy.herokuapp.com/artist/" + artistName)!
            var request = URLRequest(url: url )
            request.httpMethod = "GET"

            
            let task = URLSession.shared.dataTask(with: request ) { data, response, error in
                do {
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        if String(httpResponse.statusCode) == "200" {
                            if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                                artist.makeFromJson(json: json)
                            }
                            
                            DispatchQueue.main.async {
                                self.loadingLbl.text = "Preparing"
                                self.loadingIndicator.stopAnimating()
                                self.performSegue(withIdentifier: "gotoartist", sender: self)
                            }
                            
                        } else if httpResponse.statusCode == 500 {
                            DispatchQueue.main.async {
                                self.loadingLbl.text = "Something went wrong, we are sorry"
                                self.loadingLbl.sizeToFit()
                                self.loadingLbl.center.x = self.view.frame.width/2
                                UIView.animate(withDuration: 2, animations: {
                                    self.loadingLbl.alpha = 0
                                })
                                self.loadingAnimations(to: "Screen")
                                self.loadingIndicator.stopAnimating()
                                
                            }
                        } else if httpResponse.statusCode == 400 {
                            DispatchQueue.main.async {
                                self.loadingLbl.text = "Could not find artist"
                                self.loadingLbl.sizeToFit()
                                self.loadingLbl.center.x = self.view.frame.width/2
                                UIView.animate(withDuration: 2, animations: {
                                    self.loadingLbl.alpha = 0
                                })
                                self.loadingAnimations(to: "Screen")
                                self.loadingIndicator.stopAnimating()
                                
                            }
                        }
                    }
        
                } catch {
                    print(error)
                }

            }
            task.resume()
            
        } else {
            sender.shake(direction: "horizontal", swings: 2.0)
        }
    }
    
    @IBAction func searchFieldAbandoned(_ sender: UITextField) {
        sender.clearsOnBeginEditing = true
        if sender.text == "" {
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = pulseSpeed
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

    func makeSearchWord() -> String {
        let result = searchField.text?.replacingOccurrences(of: " ", with: "_")
        return result!
    }
    
    @IBAction
    func unwindSegue(sender: UIStoryboardSegue) {}
}

