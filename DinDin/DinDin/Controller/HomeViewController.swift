//
//  HomeViewController.swift
//  DinDin
//
//  Created by Khin Lei Wah Win on 13/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit
import FSPagerView

class HomeViewController: UIViewController,FSPagerViewDataSource,FSPagerViewDelegate {
    
    fileprivate let sectionTitles = ["Cheese", "Chicken", "Fish", "Vegetarian", "Beef"]
   
    var routing: ItemRouting = ItemRouting()
    var specialBurger = [Burger]()
    
    @IBOutlet weak var descriptionFeatured: UILabel!
    @IBOutlet weak var nameFeatured: UILabel!
    @IBOutlet weak var priceFeatured: UILabel!
    @IBOutlet weak var imgFeatured: UIImageView!
    
    
    func loadJson() {
       let burgers = Utility.shared.loadJson(filename: "burger")!
       self.specialBurger = burgers.filter({$0.burgerClassification == 1})
        
       if let featuredBurger = burgers.filter({$0.burgerClassification == 0}).first {
            self.descriptionFeatured.text = featuredBurger.description
            self.nameFeatured.text = featuredBurger.name
            self.imgFeatured.image = UIImage.init(named: featuredBurger.imageName)
            self.priceFeatured.text = featuredBurger.price.toDollar()
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pagerView.interitemSpacing = 20
        self.pagerViewSpecialItems.interitemSpacing = 20
        
        self.routing.viewController = self
        self.loadJson()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - PAGER
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.tag = 100
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")

            self.pagerView.itemSize = self.pagerView.frame.size.applying(CGAffineTransform(scaleX: CGFloat(0.3), y: CGFloat(0.3)))
        }
    }
    
    @IBOutlet weak var pagerViewSpecialItems: FSPagerView! {
        didSet {
            self.pagerViewSpecialItems.tag = 101
            self.pagerViewSpecialItems.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "specialCell")
            self.pagerViewSpecialItems.itemSize = self.pagerViewSpecialItems.frame.size.applying(CGAffineTransform(scaleX: CGFloat(0.5), y: CGFloat(1)))
            //self.pagerViewSpecialItems.itemSize =  FSPagerView.automaticSize
        }
    }

    // MARK:- FSPagerView DataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        if (pagerView.tag == 100) {
            return self.sectionTitles.count
        } else {
            return self.specialBurger.count
        }
    }
    
    func getBurger(for index: Int) -> Burger {
        return self.specialBurger[index]
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView.tag == 100 {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            //cell.priceLabel?.text = self.sectionTitles[index]//index.description+index.description
            cell.titleLabel!.text = self.sectionTitles[index]
            return cell
        } else {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "specialCell", at: index)
            let burger = getBurger(for: index)
            cell.imageView?.image = UIImage(named: burger.imageName)
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
            cell.titleLabel!.text = burger.name
            cell.priceLabel!.text = burger.price.toDollar()
            return cell
        }
    }
    
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if (pagerView.tag == 100) {
            pagerView.deselectItem(at: index, animated: true)
            pagerView.scrollToItem(at: index, animated: true)
        } else {
            pagerViewSpecialItems.deselectItem(at: index, animated: true)
            pagerViewSpecialItems.scrollToItem(at: index, animated: true)
        }
        routing.presentDetailView(cell: pagerView.cellForItem(at: index)!, selectedBurger: self.specialBurger[index])
    }

}
