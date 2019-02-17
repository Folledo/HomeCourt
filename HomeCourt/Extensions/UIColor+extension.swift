//
//  UIColor+extension.swift
//  KingOfTheCourt
//
//  Created by Samuel Folledo on 2/17/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init (r: CGFloat, g: CGFloat, b: CGFloat) {
		self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
	}
}
