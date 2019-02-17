//
//  Settings.swift
//  KingOfTheCourt
//
//  Created by Samuel Folledo on 2/16/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation
import UIKit

private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter { //RE ep.12 1min DateFormatter = A formatter that converts between dates and their textual representations.
	let dateFormatter = DateFormatter() //RE ep.12 2mins
	dateFormatter.dateFormat = dateFormat //RE ep.12 3mins
	
	return dateFormatter //RE ep.12 4mins
}
