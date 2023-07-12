//
//  ProductInfo.swift
//  Price
//
//  Created by Haruto Hamano on 2023/07/09.
//

import Foundation
import RealmSwift

class ProductInfo: Object{
    @objc dynamic var url: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var num: Int = 0
}
