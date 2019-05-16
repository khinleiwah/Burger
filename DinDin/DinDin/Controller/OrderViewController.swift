//
//  OrderViewController.swift
//  DinDin
//
//  Created by Khin Lei Wah Win on 14/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit
import Presentr

class OrderViewController: UIViewController,TopViewDelegate {
    
    var selectedBurger:Burger?
    
    @IBOutlet weak var gramLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    lazy var alertController: AlertViewController = {
        let font = UIFont.boldSystemFont(ofSize: 18)
        let alertController = AlertViewController(title: "Are you sure? ⚠️", body: "This action can't be undone!", titleFont: nil, bodyFont: nil, buttonFont: nil)
        let cancelAction = AlertAction(title: "NO, SORRY! 😱", style: .cancel) {
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "DO IT! 🤘", style: .destructive) {
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }()
    
    lazy var topVC: OrderTopViewController = {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let topViewController = mainStoryboard.instantiateViewController(withIdentifier: "OrderTopViewController") as! OrderTopViewController
        topViewController.parentVC = self
        return topViewController
    }()
    
    lazy var bottomVC: OrderBottomViewController = {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let bottomViewController = mainStoryboard.instantiateViewController(withIdentifier: "OrderBottomViewController") as! OrderBottomViewController
        bottomViewController.burger = self.selectedBurger
        bottomViewController.delegate = self
        return bottomViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Do any additional setup after loading the view.
        self.imgView.image = UIImage.init(named: (self.selectedBurger?.imageName)!)
        self.nameLabel.text = self.selectedBurger?.name
        self.priceLabel.text = self.selectedBurger?.price.toDollar()
        self.gramLabel.text = self.selectedBurger?.weightInGrams
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bottomHalfCustom()
    }
    
    @objc func topHalfCustom() {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverVerticalFromTop
        presenter.dismissTransitionType = .coverVerticalFromTop
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: topVC, animated: true)
    }
    
    @objc func bottomHalfCustom() {
        bottomVC.parentView = self
        presenter.presentationType = .bottomHalf
        presenter.transitionType = .coverHorizontalFromLeft
        presenter.transitionType = .crossDissolve
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: bottomVC, animated: true)
    }
    
    func showTopVC() {
        topHalfCustom()
    }
}
