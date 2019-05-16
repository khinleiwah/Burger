//
//  OrderBottomViewController.swift
//  DinDin
//
//  Created by Khin Lei Wah Win on 14/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit
import FSPagerView

protocol TopViewDelegate {
    func showTopVC()
}

class OrderBottomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FSPagerViewDataSource,FSPagerViewDelegate,IngredientProtocol,AddToCartDelgate  {

    var burger:Burger?
    var selectedIngredient = 0
    var parentView: OrderViewController!
    var delegate:TopViewDelegate!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.tag = 101
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "specialCell")
            self.pagerView.itemSize = self.pagerView.frame.size.applying(CGAffineTransform(scaleX: CGFloat(0.3), y: CGFloat(0.8)))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1) {
            return 1
        } else {
            return burger?.ingredients[selectedIngredient].condiments.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addToCartCell", for: indexPath) as! AddToCartTableViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
            let condiment = burger?.ingredients[selectedIngredient].condiments[indexPath.row]
            print("cell \(String(describing: condiment))")
            cell.priceLabel.text = (condiment?.price.description)!
            cell.condimentLabel.text = condiment?.name
            cell.quantityStepper.tag =  indexPath.row
            cell.delegate = self
            
            if let qty = condiment?.quantity {
                cell.quantityStepper.value = Double(qty)
            } else {
                cell.quantityStepper.value = 0.0
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 2) {
            return 80
        }
        return 60
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "specialCell", at: index)
        let ingredient = burger?.ingredients[index]
        cell.imageView?.image = UIImage(named:(ingredient?.imageName)!)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.titleLabel!.text =  ingredient?.name
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.selectedIngredient = index
        self.tableView.reloadData()
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return (self.burger?.ingredients.count) ?? 0
    }

    func quantiyValueChanged(quantity:Int,index:Int,amount: Float) {
        print("stepper index \(index)")
        guard index < (self.burger?.ingredients[selectedIngredient].condiments.count)! else {
            return
        }
        self.burger?.ingredients[selectedIngredient].amount = amount
        self.burger?.ingredients[selectedIngredient].condiments[index].quantity = quantity
        
        self.parentView.priceLabel.text =  Utility.shared.totalAmount(burger: self.burger!).toDollar()
    }
    
    func addToCart() {
        self.dismiss(animated: true) {
            let total = Utility.shared.totalAmount(burger: self.burger!)
            
            let filterList = Utility.burgerInCart.filter({$0.burger.name == self.burger?.name})
            if var choosenBurger = filterList.first {
                
                Utility.burgerInCart.removeAll(where: { (b) -> Bool in
                    b.burger.name == self.burger?.name
                })

                choosenBurger.amount = (choosenBurger.amount ?? 0.0) + total
                choosenBurger.qty = (choosenBurger.qty ?? 0) + 1
                choosenBurger.displayAmount = choosenBurger.amount
                Utility.burgerInCart.append(choosenBurger)
            }
            else {
                let burger = BurgerInCart.init(burger: self.burger!, qty: 1, amount: total, displayAmount: total)
                Utility.burgerInCart.append(burger)
            }
   
            self.delegate.showTopVC()
        }
    }
    

}
