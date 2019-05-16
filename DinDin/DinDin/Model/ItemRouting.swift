//
//  ItemRouting.swift
//  DinDin
//
//  Created by Win on 15/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit
import CiaoTransitions
import FSPagerView

enum CollectionItem {
    case push(image: UIImage?, title: String, subtitle: String, type: CiaoTransitionStyle)
    case modal(image: UIImage?, title: String, subtitle: String, type: CiaoTransitionStyle)
}

protocol ItemsRoutingInterface {
    func presentDetailView(cell: FSPagerViewCell, selectedBurger:Burger)
}

class ItemRouting: NSObject {
    var viewController: UIViewController?
    var transition: CiaoTransition?
}

extension ItemRouting: ItemsRoutingInterface {
    func presentDetailView(cell: FSPagerViewCell, selectedBurger:Burger) {
        
        var configurator = CiaoConfigurator()
        var scaleConfigurator: CiaoScaleConfigurator?
        var presentViewController: OrderViewController?
        
        configurator.dragDownEnabled = true
        configurator.dragLateralEnabled = false
        configurator.fadeInEnabled = true
        configurator.fadeOutEnabled = false
        configurator.scale3D = false
        
        let rectInCell = cell.contentView.convert((cell.imageView?.frame)!, to: cell)
        let rectInView = cell.convert(rectInCell, to: viewController?.view)
        
        scaleConfigurator = CiaoScaleConfigurator()
        scaleConfigurator?.scaleSourceImageView = cell.imageView
        scaleConfigurator?.scaleSourceFrame = rectInView
        scaleConfigurator?.scaleDestImageViewTag = 200
        scaleConfigurator?.scaleDestFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        presentViewController = OrderViewController()//ScaleViewController()
        presentViewController?.selectedBurger = selectedBurger
        
        transition = CiaoTransition(style: .scaleImage, configurator: configurator, scaleConfigurator: scaleConfigurator)
        presentViewController?.transitioningDelegate = transition
        
        viewController?.present(presentViewController!, animated: true, completion: nil)
    }
}
