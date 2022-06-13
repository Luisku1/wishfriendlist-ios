//
//  Products.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 30/05/22.
//

import Foundation

struct WishObject
{
    var id : String, name : String, price : Float, stock : Int, image : String, category : String, personalDescription : String
    
    init()
    {
        id = ""
        name = ""
        price = 0.0
        stock = 0
        image = ""
        category = ""
        personalDescription = ""
    }
    
    init(id : String, name : String, price : Float, stock : Int, image : String, category : String, personalDescription : String)
    {
        self.id = id
        self.name = name
        self.price = price
        self.stock = stock
        self.image = image
        self.category = category
        self.personalDescription = personalDescription
    }
    
    init(dictionary : [String: Any])
    {
        self.id = dictionary["id"] as! String
        self.name = dictionary["objectName"] as! String
        self.price = dictionary["objectPrice"] as! Float
        self.stock = dictionary["disponibility"] as! Int
        self.image = dictionary["image"] as! String
        self.category = dictionary["category"] as? String ?? ""
        self.personalDescription = dictionary["personalD"] as? String ?? ""
    }
    
}

struct Category
{
    var id : String
    var category : String
    var image : String
}

var wishObjects : [WishObject] =
[
    WishObject(id: "1", name: "Xbox Series S", price: 300, stock: 4, image: "xboxseriess", category: "3", personalDescription: ""),
    WishObject(id: "2", name: "Xbox Series X", price: 650, stock: 10, image: "xboxseriesx", category: "3", personalDescription: ""),
    WishObject(id: "3", name: "Mac Book Pro", price: 1300, stock: 4, image: "macbookpro", category: "4", personalDescription: ""),
    WishObject(id: "4", name: "Mac Book Air", price: 1000, stock: 7, image: "macbookair", category: "4", personalDescription: ""),
    WishObject(id: "5", name: "Motocycle Helmet", price: 664.75, stock: 300, image: "helmet", category: "5", personalDescription: ""),
    WishObject(id: "6", name: "HP 24 inches Monitor", price: 196, stock: 4, image: "monitor", category: "4", personalDescription: ""),
    WishObject(id: "7", name: "Logitech C920x", price: 73.5, stock: 2, image: "webcam", category: "4", personalDescription: ""),
    WishObject(id: "8", name: "Bengoo G9000 Gaming Headset", price: 19.99, stock: 24, image: "headset", category: "3", personalDescription: ""),
    WishObject(id: "9", name: "High-Speed HDMI Cable", price: 340.2, stock: 100, image: "hdmi", category: "1", personalDescription: ""),
    WishObject(id: "10", name: "ELEGOO UNO Project starter kit", price: 33.99, stock: 2, image: "arduino", category: "4", personalDescription: ""),
    WishObject(id: "11", name: "Vacuum cleaner", price: 399.99, stock: 5, image: "cleaner", category: "2", personalDescription: "")
]


let categories : [Category] =
[
    Category(id: "1", category: "Tecnology", image: "tecnology"),
    Category(id: "2", category: "Domestic", image: "domestic"),
    Category(id: "3", category: "Videogames", image: "videogames"),
    Category(id: "4", category: "Study", image: "study"),
    Category(id: "5", category: "Recreational and more", image: "recreational"),
]
