//
//  ViewController.swift
//  weather
//
//  Created by Macintosh HD on 14.10.19.
//  Copyright © 2019 Svetlio. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
 
    var weather : UILabel?
    var city : UILabel?
    var searchBar : UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelConstraints()
        apiRequest()
    }
    
    func labelConstraints(){
        weather = UILabel()
        weather?.text = "Unknown weather"
        self.view.addSubview(weather!)
        
        city = UILabel()
        city?.text = "Unknown city"
        self.view.addSubview(city!)
        
        searchBar = UISearchBar()
        searchBar?.text = ""
        self.view.addSubview(searchBar!)
        
        searchBar?.snp.makeConstraints({make in
            make.topMargin.equalTo(self.view.snp.topMargin).offset(20)
            make.leading.equalTo(self.view.snp.leading).offset(20)
            make.trailing.equalTo(self.view.snp.trailing).offset(-20)
        })
        
        weather?.snp.makeConstraints({make in
            make.top.equalTo(searchBar?.snp.bottom ?? self.view.snp.topMargin).offset(20)
            make.leading.equalTo(self.view.snp.leading).offset(20)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.43)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.15)
        })
        
        city?.snp.makeConstraints({make in
            make.top.equalTo(searchBar?.snp.bottom ?? self.view.snp.topMargin).offset(20)
            make.leading.equalTo(weather?.snp.trailing ?? self.view.snp.leading).offset(20)
            make.trailing.equalTo(self.view.snp.trailing).offset(-20)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.15)
        })
    }
    
    func apiRequest(){
        
        let API_Key = "900c93b2498522766b542a4e21722c03"
        let apiUrl = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=M%C3%BCnchen,DE&appid=\(API_Key)")
        guard let url = apiUrl else { return }
        let task = URLSession.shared.dataTask(with: url) { (data , response , error) in
            
            guard let data = data else{ return }
            
            do {
               let responseJson = try JSONSerialization.jsonObject(with: data, options: [])
       
               guard let dict = responseJson as? [String:Any] else { return }
               
               let city = dict["city"] as! [String:Any]
               DispatchQueue.main.async {
                   self.city?.text = city["country"] as! String
               }
           } catch let jsonError {
            print (jsonError)
           }
            
        }
        task.resume()
    }

}

