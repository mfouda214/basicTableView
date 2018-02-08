//
//  DataItem.swift
//  TableViewDemo
//
//  Created by Mohamed Sobhi  Fouda on 2/6/18.
//  Copyright © 2018 Mohamed Sobhi Fouda. All rights reserved.
//


import UIKit

class DataItem {
    var title: String
    var subtitle: String
    var image: UIImage?
    
    init(title: String, subtitle: String, imageName: String?) {
        self.title = title
        self.subtitle = subtitle
        if let imageName = imageName {
            if let img = UIImage(named: imageName) {
                image = img
            }
        }
    }
}
