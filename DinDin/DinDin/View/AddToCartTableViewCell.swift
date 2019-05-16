//
//  AddToCartTableViewCell.swift
//  DinDin
//
//  Created by Khin Lei Wah Win on 14/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit

protocol AddToCartDelgate {
    func addToCart()
}
class AddToCartTableViewCell: UITableViewCell {
    var delegate: AddToCartDelgate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addToCartClicked(_ sender: Any) {
        self.delegate.addToCart()
    }
}
