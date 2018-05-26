//
//  RoundView.swift
//  Ne Pisirsem
//
//  Created by Çağlar Uslu on 26.05.2018.
//  Copyright © 2018 Çağlar Uslu. All rights reserved.
//

import UIKit

class RoundView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        self.contentMode = .scaleAspectFit
    }
    
    
}
