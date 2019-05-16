//
//  OrderTopViewController.swift
//  DinDin
//
//  Created by Win on 15/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit
import ValueStepper


class OrderTopViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var burgerInCart = Utility.burgerInCart
    var parentVC: OrderViewController!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        burgerInCart = Utility.burgerInCart
        self.tableView.reloadData()
    }
    
    @IBAction func gotoHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1) {
            return 1
        }
        return burgerInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "displayCell", for: indexPath) as! CartDisplayCell
            
            cell.nameLabel.text = burgerInCart[indexPath.row].burger.name
            cell.priceLabel.text = burgerInCart[indexPath.row].displayAmount?.toDollar()
            cell.quantitStepper.tag = indexPath.row
            cell.quantitStepper.value = Double(burgerInCart[indexPath.row].qty!)
          
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartBottomCell", for: indexPath) as! CartBottomCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        if(section == 0) {
           
            let label = UILabel.init(frame: CGRect.zero)
            let total = Utility.shared.totalCount(burgers: self.burgerInCart)
            label.text = "  \(total) items in the cart"
            label.numberOfLines = 0
            label.sizeToFit()
            vw.addSubview(label)
        }
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
   
    @IBAction func quantityValueChanged(_ sender: Any) {
        let stepper = sender as! ValueStepper
        print("testing \(stepper.value)" )
        var burger = burgerInCart[stepper.tag]
        let amount = Float(stepper.value) * burger.amount!
        burger.displayAmount = amount
        burger.qty = Int(stepper.value)
        burgerInCart[stepper.tag] = burger
       
        Utility.burgerInCart.removeAll { (b) -> Bool in
            b.burger.name == burger.burger.name
        }
        Utility.burgerInCart.append(burger)
      
        //self.tableView.reloadRows(at: [IndexPath.init(row: stepper.tag, section: 0)], with: .fade)
        self.tableView.reloadData()
    }
    
    @IBAction func goToMenu(_ sender: Any) {
        self.dismiss(animated: true) {
          self.parentVC.dismiss(animated: true, completion: nil)
        }
    }
    
}
