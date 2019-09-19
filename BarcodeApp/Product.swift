//
//  Product.swift
//  BarcodeApp
//
//  Created by PingLi on 6/9/19.
//  Copyright © 2019 PingLi. All rights reserved.
//

class Product {
    
    var id: Int64
    var title: String?
    var description: String?
    var price: Double?
    var vendor: String?
    var expiring_date: String?
    var encoding_date: String?
    var stock_item_count: Double?
    
    init(){
        self.id = -1
        self.title = ""
        self.description = ""
        self.price = 0
        self.vendor = ""
        self.expiring_date = ""
        self.encoding_date = ""
        self.stock_item_count = 0
    }
    
    init(id: Int64, title: String?, description: String?, price: Double?, vendor: String?,
        expiring_date: String?, encoding_date: String?, stock_item_count: Double?){
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.vendor = vendor
        self.expiring_date = expiring_date
        self.encoding_date = encoding_date
        self.stock_item_count = stock_item_count
    }
}

