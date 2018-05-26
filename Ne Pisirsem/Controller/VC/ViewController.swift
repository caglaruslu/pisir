//
//  ViewController.swift
//  Ne Pisirsem
//
//  Created by Çağlar Uslu on 24.05.2018.
//  Copyright © 2018 Çağlar Uslu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBarTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var devamButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var inSearchMode = false
    
    var malzemeler = [String]()
    var filteredMalzemeler = [String]()
    var selectedMalzemeler = [String]()
    
    var tagCounter = 0
    var counter = 0
    var totalWidth: CGFloat = 20
    var keeper: CGFloat = 0
    var currentLevel: CGFloat = 86
    var level: CGFloat = 1
    var initialTopAnchor: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        fetchMalzeme()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }
    
    func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    func fetchMalzeme(){
        
        malzemeler.append("domates")
        malzemeler.append("biber")
        malzemeler.append("patlican")
        malzemeler.append("havuc")
        malzemeler.append("sogan")
        malzemeler.append("salatalik")
        malzemeler.append("tavuk")
        malzemeler.append("kiyma")
        malzemeler.append("asdafasdfafs")
        malzemeler.append("asdaffs")
        malzemeler.append("asdaff")
        
        tableView.reloadData()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredMalzemeler.count
        }else{
            return malzemeler.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "malzemeCell", for: indexPath) as? MalzemeCell {
            
            if inSearchMode{
                cell.malzeme.text = filteredMalzemeler[indexPath.row]
            }else{
                cell.malzeme.text = malzemeler[indexPath.row]
            }
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var text = ""
        
        devamButton.isHidden = false
        
        if inSearchMode{
            selectedMalzemeler.append(filteredMalzemeler[indexPath.row])
            let index = indexPath.row
            let index2 = malzemeler.index(of: filteredMalzemeler[index])

            text = filteredMalzemeler[indexPath.row]
            
            filteredMalzemeler.remove(at: index)
            malzemeler.remove(at: index2!)
        }else{
            selectedMalzemeler.append(malzemeler[indexPath.row])
            let index = indexPath.row
            
            text = malzemeler[indexPath.row]
            
            malzemeler.remove(at: index)
            
        }
        
        setButtons(malzeme: text, deleting: false)
        
        
        searchBar.text = ""
        inSearchMode = false
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            tableView.reloadData()
            view.endEditing(true)
            
        }else{
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredMalzemeler = malzemeler.filter({ $0.range(of: lower) != nil  })
            tableView.reloadData()
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func setButtons(malzeme: String, deleting: Bool){
        
        counter += 1
        tagCounter += 1
        
        let width = estimateFrameForText(text: malzeme).width
        
        if (totalWidth + keeper + 16 + width + 26 + 16 >= self.view.frame.width ) {
            level += 1
            totalWidth = 20
            counter = 1
            currentLevel += 46
        }
        
        if !deleting{
            UIView.animate(withDuration: 0.2) {
                self.searchBarTopAnchor.constant = self.initialTopAnchor*self.level + 20
                self.view.layoutIfNeeded()
                
            }
        }else{
            searchBarTopAnchor.constant = initialTopAnchor*level + 20
        }
        
        
        if counter != 1 {
            totalWidth += keeper + 16
        }
        
        keeper = width + 44
        
        let button: RoundButton!
        button = RoundButton(frame: CGRect(x: totalWidth, y: currentLevel, width: keeper, height: 30))
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        button.setTitleColor(UIColor(red: 224/255, green: 38/255, blue: 66/255, alpha: 1.0), for: .normal)
        button.setTitle(malzeme, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.tag = tagCounter
        
        let deleteButton: UIButton!
        deleteButton = UIButton(frame: CGRect(x: keeper - 20, y: 7, width: 16, height: 16))
        deleteButton.setImage(#imageLiteral(resourceName: "remove_ingredientt"), for: .normal)
        deleteButton.imageView?.contentMode = .scaleAspectFit
        deleteButton.setTitleColor(UIColor(red: 224/255, green: 38/255, blue: 66/255, alpha: 1.0), for: .normal)
        deleteButton.isUserInteractionEnabled = true
        deleteButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        deleteButton.tag = -tagCounter
        
        self.view.addSubview(button)
        button.addSubview(deleteButton)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        print(sender.tag)
        
        var positiveTag = 0
        
        if sender.tag < 0 {
            positiveTag = -sender.tag
        }else{
            positiveTag = sender.tag
        }
        
        let tmpButton = self.view.viewWithTag(positiveTag) as? UIButton
        if let title = tmpButton?.currentTitle{
            
            
            if let index = selectedMalzemeler.index(of: title){
                print(title)
                selectedMalzemeler.remove(at: index)
            }
            
            malzemeler.append(title)
            tableView.reloadData()
            
            reorderList(tag: positiveTag)
        }
        
    }
    
    func reorderList(tag: Int){
        
        tagCounter = 0
        counter = 0
        totalWidth = 20
        keeper = 0
        currentLevel = 86
        level = 1
        initialTopAnchor = 50
        
        for i in 1...(selectedMalzemeler.count + 1){
            
            let tmpButton = self.view.viewWithTag(i) as? UIButton
            tmpButton?.removeFromSuperview()
            
//            if i != tag{
//                let tmpButton = self.view.viewWithTag(i) as? UIButton
//                tmpButton?.removeFromSuperview()
//
//                let delButton = self.view.viewWithTag(-i) as? UIButton
//                delButton?.removeFromSuperview()
//            }
            
            
        }
        
        if selectedMalzemeler.count != 0{
            for i in 0...(selectedMalzemeler.count - 1){
                
                setButtons(malzeme: selectedMalzemeler[i], deleting: true)
                
            }
        }else{
            UIView.animate(withDuration: 0.2) {
                self.searchBarTopAnchor.constant = 0
                self.view.layoutIfNeeded()
                
            }
            
            
        }
        
        
        
        
    }

    
    private func estimateFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: view.frame.size.width - 46, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 14)! ], context: nil)
        
    }
    
    
    @IBAction func devamButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "food", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "food"{
            if let nextVC = segue.destination as? FoodVC{
                nextVC.malzemeler = selectedMalzemeler
            }
        }
    }
    
}















