//
//  ViewController.swift
//  learn-weather-app
//
//  Created by Svetlio on 30.10.19.
//  Copyright © 2019 Svetlio. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    
    var weather : UILabel?
    var city : UILabel?
    var searchBar : UISearchBar!
    var location : Location?
    //var searchPressed = false
    @objc func searching(){
        location?.city = searchBar.text!
        searchBar?.text = ""
        apiRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        labelConstraints()
        //searching()
        
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
        
        searchBar?.target(forAction: #selector(searching), withSender: UIBarButtonItem.self)
        location = Location(city: searchBar!.text!, country: "")
        
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
        do {
            if let file = Bundle.main.url(forResource: "city.list", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                 if let object = json as? [Any] {
                    // json is an array
                    //print(object)
                    for index in object.indices{
                        if let town = object[index] as? [String:Any]{
                            if town["name"] as? String == location?.city{
                                location?.country = town["country"] as! String
                                print(location!.city,location!.country)
                            }
                        }
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error)
        }
        let API_Key = "900c93b2498522766b542a4e21722c03"
        let apiUrl = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(location!.city),\(location!.country)&appid=\(API_Key)")
        guard let url = apiUrl else { return }
        let task = URLSession.shared.dataTask(with: url) { (data , response , error) in
            
            guard let data = data else{ return }
            do {
                
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                //print(jsonData)
            } catch {
                print("jsonError")
            }
            do {
               let responseJson = try JSONSerialization.jsonObject(with: data, options: [])
       
               guard let dict = responseJson as? [String:Any] else { return }
               
               let city = dict["city"] as! [String:Any]
               DispatchQueue.main.async {
                self.city?.text = city["name"] as? String
                let list = dict["list"] as! [Any]
    
                let subList = list[0] as! [String:Any]
                let main = subList["main"] as! [String:Any]
                
                DispatchQueue.main.async {
                    guard let temp = main["temp"] else { return }
                    var tempreture = temp as! Double
                    tempreture = ceil(tempreture - 273.15)
                    self.weather?.text = "\(Int(tempreture))"
                }
               }
           } catch let jsonError {
            print (jsonError)
           }
            
        }
        task.resume()
    }

}

