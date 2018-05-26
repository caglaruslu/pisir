//
//  FoodVC.swift
//  Ne Pisirsem
//
//  Created by Çağlar Uslu on 24.05.2018.
//  Copyright © 2018 Çağlar Uslu. All rights reserved.
//

import UIKit
import SwiftSoup

class FoodVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var malzemeler = [String]()
    var foods = [Food]()
    var selectedFood = Food()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let url = getData(array: malzemeler)
        
        let htmlData = getStringFromUrl(url: url)
        
        foods = parseString(html: htmlData)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as? FoodCell{
            cell.foodName.text = foods[indexPath.row].name
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFood = foods[indexPath.row]
        
        performSegue(withIdentifier: "yemekTarifi", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yemekTarifi"{
            if let nextVC = segue.destination as? YemekTarifiVC{
                nextVC.food = selectedFood
            }
        }
    }
    

    func getData(array: [String]) -> String{
        var str = "http://www.nefisyemektarifleri.com/?ep=true&sa=&s=&"
        
        for malzeme in array {
            
            str += "icersin=" + malzeme + "&"
            
        }
        
        str.removeLast()
        
        return str
    }
    
    func getStringFromUrl(url : String) -> String {
        
        let myURLString = url
        guard let myURL = URL(string: myURLString) else {
            //            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return ""
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            //            print("HTML : \(myHTMLString)")
            return myHTMLString
        } catch let error {
            print("Error: \(error)")
        }
        
        return ""
    }
    
    func parseString(html : String) -> [Food] {
        do {
            
            let doc = try SwiftSoup.parse(html).getElementsByClass("posttitle")
            
            var foods = [Food]()
            for item in doc.array() {
                
                let food = Food()
                food.name = try item.getElementsByTag("a").text()
                food.url = try item.getElementsByTag("a").attr("href")
                foods.append(food)
            }
            
            return foods
        } catch {
            print("error")
        }
        
        return []
    }
    
    

}


