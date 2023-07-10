//
//  ProductInfo.swift
//  Price
//
//  Created by Haruto Hamano on 2023/07/09.
//

import Foundation

class ProductInfo: NSObject{
    var url: String
    var name: String
    var min_price: String
    var image_url: String
    
    init(url: String, name:String, min_price: String, image_url: String){
        self.url = url
        self.name = name
        self.min_price = min_price
        self.image_url = image_url
    }
}
