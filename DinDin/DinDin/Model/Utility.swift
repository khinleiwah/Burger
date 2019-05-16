//
//  Utility.swift
//  DinDin
//
//  Created by Win on 15/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit

class Utility: NSObject {
    static let shared = Utility.init()

    static var burgerInCart = [BurgerInCart]()
    
    func loadJson(filename fileName: String) -> [Burger]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                
                return jsonData.burgers
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
  
    func amount(price:Float, quantity:Int) -> Float {
        let amount = price * Float(quantity)
        return amount
    }
    
    func totalAmount(burger:Burger) -> Float {
        let ingredientAmounts = burger.ingredients.map({$0.amount})
        return ingredientAmounts.reduce(burger.price, { (x, y) in
            x + (y ?? 0)
        })
    }
    
    func totalCount(burgers: [BurgerInCart]) -> Int {
        return burgers.reduce(into: 0) { (result, burger) in
            result += burger.qty!
        }
    }
}
