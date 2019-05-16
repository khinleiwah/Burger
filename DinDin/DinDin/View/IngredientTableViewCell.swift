//
//  IngredientTableViewCell.swift
//  DinDin
//
//  Created by Khin Lei Wah Win on 14/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit
import ValueStepper

protocol IngredientProtocol {
    func quantiyValueChanged(quantity:Int,index:Int,amount: Float)
}

class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var quantityStepper: ValueStepper!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var condimentLabel: UILabel!
    var delegate: IngredientProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func quantityValueChanged(_ sender: Any) {
        guard let price = priceLabel.text, let _ = quantityStepper else {
            return
        }
        let stepper = sender as! ValueStepper
        let amount = Utility.shared.amount(price: Float(price)!, quantity: Int(stepper.value))
        self.delegate.quantiyValueChanged(quantity:Int(stepper.value), index: stepper.tag, amount: amount)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
