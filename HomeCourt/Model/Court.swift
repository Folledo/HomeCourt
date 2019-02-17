//
//  Court.swift
//  KingOfTheCourt
//
//  Created by Samuel Folledo on 2/16/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation

class Court: NSObject {
	
	var objectId: String?
	var referenceCode: String?
	var ownerId: String?
	var title: String?
	var numberOfCourts: Int = 0
	
	var address: String?
	var city: String?
	var state: String?
	var zip: String?
	var country: String?
	var propertyDescription: String?
	var latitude: Double = 0.0
	var longitude: Double = 0.0
	
	var imageLinks: String?
	
//Save Functions
	func saveCourt() {
		
	}
	
	func saveCourt(completion: @escaping(_ values: String) -> Void) {
		
	}
	
//Delete Functions
	func deleteCourt(property: Court) {
		
	}
	
	func deleteCourt(property: Court, completion: @escaping (_ value: String)-> Void) {
		
	}
	

}
