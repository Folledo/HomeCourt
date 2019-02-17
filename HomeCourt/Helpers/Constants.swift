//
//  Constants.swift
//  KingOfTheCourt
//
//  Created by Samuel Folledo on 2/16/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation
import FirebaseDatabase


var firDatabase = Database.database().reference()


//uiPickers
let propertyTypes = ["Select", "Apartment", "House", "Villa", "Land", "Flat", "Mansion", "Palace", "Hotel"] //RE ep.57 10mins
let advertismentType = ["Select", "Sale", "Rent", "Exchange"] //RE ep.57 10mins


//Ids and Keys


//FUser
public let kUSERID = "userID"
public let kUSER = "user"
public let kCREATEDAT = "createdAt"
public let kUPDATEDAT = "updatedAt"
public let kPHONE = "phone"

public let kEMAIL = "email"
public let kFIRSTNAME = "firstName"
public let kLASTNAME = "lastName"
public let kFULLNAME = "fullName"
public let kPROFILEPIC = "profPic"
public let kCURRENTUSER = "currentUser"
public let kFAVORITECOURTS = "favoriteCourts"
public let kMAINCOURT = "mainCourt"
