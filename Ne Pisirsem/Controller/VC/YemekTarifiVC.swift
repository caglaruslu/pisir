//
//  YemekTarifiVC.swift
//  Ne Pisirsem
//
//  Created by Çağlar Uslu on 24.05.2018.
//  Copyright © 2018 Çağlar Uslu. All rights reserved.
//

import UIKit
import SwiftSoup

class YemekTarifiVC: UIViewController {
    
    @IBOutlet weak var yapilisi: UITextView!
    @IBOutlet weak var malzemeler: UITextView!
    var food = Food()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        food = parseFood(food: food)

        for text in food.yapilisi{
            yapilisi.text = yapilisi.text + "\n" + text
        }
        
        for text in food.malzemeler{
            malzemeler.text = malzemeler.text + "\n" + text
        }
        
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
    
    func parseFood(food : Food) -> Food {
        let html = getStringFromUrl(url: food.url)
        do {
            let doc = try SwiftSoup.parse(html).getElementsByClass("entry entry_content")
            
            let malzemleer_lu = try SwiftSoup.parse(doc.toString()).getElementsByTag("ul").toString()
            var malzemeler_li = try SwiftSoup.parse(malzemleer_lu).getElementsByTag("li").toString()
            
            while (malzemeler_li.range(of: "<li>") != nil) {
                malzemeler_li.removeSubrange(malzemeler_li.range(of: "<li>")!)
            }
            
            while (malzemeler_li.range(of: "\n") != nil) {
                malzemeler_li.removeSubrange(malzemeler_li.range(of: "\n")!)
            }
            
            
            let malzeme_arr = malzemeler_li.components(separatedBy: "</li>")
            //print(malzeme_arr)
            
            food.malzemeler = malzeme_arr
            
            
            // parse Yapılışı
            let yapilisi_ol = try SwiftSoup.parse(doc.toString()).getElementsByTag("ol").toString()
            var yapilisi_li = try SwiftSoup.parse(yapilisi_ol).getElementsByTag("li").toString()
            
            while (yapilisi_li.range(of: "<li>") != nil) {
                yapilisi_li.removeSubrange(yapilisi_li.range(of: "<li>")!)
            }
            
            while (yapilisi_li.range(of: "\n") != nil) {
                yapilisi_li.removeSubrange(yapilisi_li.range(of: "\n")!)
            }
            let yapilisi_arr = yapilisi_li.components(separatedBy: "</li>")
            // print(yapilisi_arr)
            
            food.yapilisi = yapilisi_arr
            
        } catch {
            print("error on parse Food")
        }
        
        return food
    }
    

}
