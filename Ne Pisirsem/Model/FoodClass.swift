//
//  FoodClass.swift
//  Ne Pisirsem
//
//  Created by Çağlar Uslu on 24.05.2018.
//  Copyright © 2018 Çağlar Uslu. All rights reserved.
//

import Foundation
import SwiftSoup

class Food: NSObject {
    var name : String = ""
    var url : String = ""
    var malzemeler : [String]
    var yapilisi : [String]
    
    override init() {
        name = ""
        url = ""
        malzemeler = []
        yapilisi = []
    }
    

}
