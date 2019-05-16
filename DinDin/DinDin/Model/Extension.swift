//
//  Extension.swift
//  DinDin
//
//  Created by Win on 15/5/19.
//  Copyright © 2019 Khin Lei Wah Win. All rights reserved.
//

import UIKit

extension String {
    func description() -> String {
        return "$" + self
    }
}
extension Float {
    func toDollar() -> String {
        return "$" + String(self)
    }
}
