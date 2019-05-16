//
//  Burger.swift
//  DinDin
//
//  Created by Win on 15/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit

//BURGER
//    {
//        "amount": 10.00,
//        "name": "ItemName",
//        "identifier": "itemIdentifier",
//        "burgerClassification": 0,
//        "imageName": "anImageName",
//        "weightInGrams": 2.00,
//        "description": "aBurgerDescription"
//}
//
//INGREDIENT
//    {
//        "amount": 10.00,
//        "name": "ItemName",
//        "identifier": "itemIdentifier",
//        "ingredientCategory": "anIngredientCategory"
//}

enum BurgerClassification:Int {
    case featured = 0
    case special_offer = 1
}

struct Ingredient: Codable {
    var name: String
    var imageName: String
    var amount:Float?
    var condiments: [Condiment]
}

struct Condiment: Codable {
    var name: String
    var price: Float
    var quantity: Int?
}

struct ResponseData: Codable {
    var burgers: [Burger]
}

struct Burger : Codable {
    var price: Float
    var name: String
    var burgerClassification: Int
    var imageName: String
    var weightInGrams: String
    var description: String
    var ingredients: [Ingredient]
}

struct BurgerInCart {
    var burger:Burger
    var qty: Int?
    var amount: Float?
    var displayAmount: Float?
}

