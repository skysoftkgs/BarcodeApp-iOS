//
//  DBManager.swift
//  BarcodeApp
//
//  Created by PingLi on 6/9/19.
//  Copyright © 2019 PingLi. All rights reserved.
//

import UIKit
import SQLite

class DBManager {
   
    private let products = Table("products")
    private let id = Expression<Int64>("id")
    private let title = Expression<String?>("title")
    private let description = Expression<String?>("description")
    private let price = Expression<Double?>("price")
    private let vendor = Expression<String?>("vendor")
    private let expiring_date = Expression<String?>("expiring_date")
    private let encoding_date = Expression<String?>("encoding_date")
    private let stock_item_count = Expression<Double?>("stock_item_count")
    
    static let sharedInstance = DBManager()
    private let db: Connection?
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/Products.sqlite3")
            createTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    func createTable() {
        do {
            try db!.run(products.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(title)
                table.column(description)
                table.column(price)
                table.column(vendor)
                table.column(expiring_date)
                table.column(encoding_date)
                table.column(stock_item_count)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addProduct(product: Product) -> Int64? {
        do {
            let insert = products.insert(title <- product.title, description <- product.description, price <- product.price, vendor <- product.vendor, expiring_date <- product.expiring_date, encoding_date <- product.encoding_date, stock_item_count <- product.stock_item_count)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return nil
        }
    }
    
    func getProducts() -> [Product] {
        var products = [Product]()
        
        do {
            for product in try db!.prepare(self.products) {
                products.append(Product(
                    id: product[id],
                    title: product[title],
                    description: product[description],
                    price: product[price],
                    vendor: product[vendor],
                    expiring_date: product[expiring_date],
                    encoding_date: product[encoding_date],
                    stock_item_count: product[stock_item_count]))
            }
        } catch {
            print("Select failed")
        }
        
        return products
    }
    
    func deleteProduct(pid: Int64) -> Bool {
        do {
            let product = products.filter(id == pid)
            try db!.run(product.delete())
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    func updateProduct(pid:Int64, newProduct: Product) -> Bool {
        let product = products.filter(id == pid)
        do {
            let update = product.update([
                title <- newProduct.title,
                description <- newProduct.description,
                price <- newProduct.price,
                vendor <- newProduct.vendor,
                expiring_date <- newProduct.expiring_date,
                encoding_date <- newProduct.encoding_date,
                stock_item_count <- newProduct.stock_item_count
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
}
