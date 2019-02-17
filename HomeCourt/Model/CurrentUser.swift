//
//  CurrentUser.swift
//  KingOfTheCourt
//
//  Created by Samuel Folledo on 2/16/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class CurrentUser {
	
	let createdAt: Date
	var updatedAt: Date
	
	var userID: String
	var email: String
	var firstName: String
	var lastName: String
	var fullName: String
	var profilePic: String
	var phoneNumber: String
	var favoriteCourts: [String]
	var mainCourt: String
	
	
	
	init(_createdAt: Date, _updatedAt: Date, _userID: String, _firstName: String, _lastName: String, _profilePic: String = "", _phoneNumber: String = "", _mainCourt: String = "", _email: String) {
		
		createdAt = _createdAt
		updatedAt = _updatedAt
		
		userID = _userID
		email = _email
		firstName = _firstName
		lastName = _lastName
		fullName = _firstName + " " + _lastName
		profilePic = _profilePic
		favoriteCourts = []
		mainCourt = _mainCourt
		
		phoneNumber = _phoneNumber
		
	}
	
	init(_dictionary: NSDictionary) {
		
		if let id = _dictionary[kUSERID] {
			userID = id as! String
		} else { userID = "" }
		
		if let fname = _dictionary[kFIRSTNAME] {
			firstName = fname as! String
		} else { firstName = "" }
		
		if let lname = _dictionary[kLASTNAME] {
			lastName = lname as! String
		} else { lastName = "" }
		
		fullName = firstName + " " + lastName
		
		
		if let pic = _dictionary[kPROFILEPIC] {
			profilePic = pic as! String
		} else { profilePic = "" }
		
	
		if let phone = _dictionary[kPHONE] {
			phoneNumber = phone as! String
		} else { phoneNumber = "" }
		
		if let favCourt = _dictionary[kFAVORITECOURTS] {
			favoriteCourts = favCourt as! [String]
		} else { favoriteCourts = [] }
		
		if let myCourt = _dictionary[kMAINCOURT] {
			mainCourt = myCourt as! String
		} else { mainCourt = "" }
		
		if let updated = _dictionary[kUPDATEDAT] {
			updatedAt = dateFormatter().date(from: updated as! String)!
		} else { updatedAt = Date() }
		
		if let created = _dictionary[kCREATEDAT] {
			createdAt = dateFormatter().date(from: created as! String)!
		} else { createdAt = Date() }
		
		if let emaill = _dictionary[kEMAIL] {
			email = emaill as! String
		} else { email = "" }
	}
	
	class func currentId() -> String { //class func that will return our current user id. Difference between class func and a normal func is, normal func needs to be first instantiate the class "let user = FUser() ... user.someFunc". Class func allows you to just call "FUser.someFunc"
		return Auth.auth().currentUser!.uid //access our Auth and get our currentUser.uid
	}
	
	class func currentUser() -> CurrentUser? { //returns our current logged in user, which can be optional so our app wont crash if there is no user
		if Auth.auth().currentUser != nil { //if there is a user
			if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
				return CurrentUser.init(_dictionary: dictionary as! NSDictionary)
			}
		}
		return nil
	}
	
	class func registerUserWith(email: String, password: String, firstName: String, lastName: String, profPic: String, completion: @escaping (_ error: Error?) -> Void) { //Firebase will take all these parameters and register our user on a background thread, so main thread doesnt get blocked. So once Firebase is done registering the user, we can call our callback function (completion) which will say "Im finish registering here is what I did"
		Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
			if let error = error { //if there's error
				completion(error) //call our completion, and heres the error. if there's error then Pass error to our function
				return //return so we dont run the rest of the code
			}
			
			guard let currentUserUid = firUser?.user.uid else { return }
			
			let cUser = CurrentUser(_createdAt: Date(), _updatedAt: Date(), _userID: currentUserUid, _firstName: firstName, _lastName: lastName, _profilePic: profPic, _phoneNumber: "", _mainCourt: "", _email: email)
			
		//save FUser to UserDefaults so we have it on our device
			saveUserLocally(cUser: cUser) //RE ep.15 10mins
			
		//save FUser to Firebase Database so we can access the user with all the information
			saveUserInBackground(cUser: cUser) //RE ep.15 14mins
			
			completion(error) //RE ep.14 9mins
		}
		
	}
	
//MARK: Login
	class func loginUserWith(email: String, password: String, withBlock: @escaping (_ error: Error?) -> Void) { //RE ep.110 1mins
		Auth.auth().signIn(withEmail: email, password: password) { (firUser, error) in //RE ep.110 2mins
			if let error = error { //RE ep.110 3mins
				withBlock(error) //RE ep.110 3mins
				return
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { //it is important to have some DELAY
				let uid: String = firUser!.user.uid
				fetchUserWith(userId: uid, completion: { (cUser) in //RE ep.110 //4mins after signing in, we need to download these user and save it to our local UserDefaults //5mins this method takes a user.uid, finds the user we want, converts it to FUser and returns it, so now we can save them
					guard let user = cUser else { print("no user"); return }
					saveUserLocally(cUser: user) //RE ep.110 7mins
					withBlock(error)
				})
			})
		}
	}
	
	
	//MARK: Logout
	class func logOutCurrentUser(withBlock: (_ success: Bool) -> Void) { //logout the current user
		print("Logging outttt...")
		UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
		UserDefaults.standard.synchronize() //save the changes in UserDefaults. This order is important so it wont crash
		
		do { //do a try-catch, it will crash
			try Auth.auth().signOut()
			withBlock(true)
			
		} catch let error as NSError {
			print("error logging out \(error.localizedDescription)")
			withBlock(false) //false completionBlock because our logout is not succcessful
		}
	}
	
	
	class func deleteUser(completion: @escaping(_ error: Error?) -> Void) {
		let user = Auth.auth().currentUser
		user?.delete(completion: { (error) in //delete user
			completion(error)
		})
	}
	
	
}

//+++++++++++++++++++++++++   MARK: Saving user   ++++++++++++++++++++++++++++++++++
func saveUserInBackground(cUser: CurrentUser) {
	let ref = firDatabase.child(kUSER).child(cUser.userID).child("userInfo") //
	ref.setValue(userDictionaryFrom(user: cUser)) //Database's "User" will have the user's uid as its child, and then set the values of the userDictionary to the child uid/objectId //Overall, creates a reference for our user in our Database
	print("Finished saving user \(cUser.fullName) in Firebase")
}

//save locally
func saveUserLocally(cUser: CurrentUser) {
	UserDefaults.standard.set(userDictionaryFrom(user: cUser), forKey: kCURRENTUSER) //this method takes the user converted to an NSDictionary and puts forKey: kCURRENTUSER
	UserDefaults.standard.synchronize() //so it will save our objects to our UserDefaults in background on the device
	print("Finished saving user \(cUser.fullName) locally...")
}





//MARK: Helper fuctions

func fetchUserWith(userId: String, completion: @escaping (_ user: CurrentUser?) -> Void) {
	let ref = firDatabase.child("user").queryOrdered(byChild: "userID").queryEqual(toValue: userId)
	
	ref.observeSingleEvent(of: .value, with: { (snapshot) in //observe one value only. //.value = Any data changes at a location or, recursively, at any child node.
		
		if snapshot.exists() { //if we find a user
			let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! NSDictionary
			let user = CurrentUser(_dictionary: userDictionary) //assign
			completion(user) //gives the user in completion
			
		} else { //snapshot dont exist
			completion(nil) //we dont have a user
		}
	}, withCancel: nil)
}


func userDictionaryFrom(user: CurrentUser) -> NSDictionary { //take a user and return an NSDictionary
	
	let createdAt = dateFormatter().string(from: user.createdAt)
	let updatedAt = dateFormatter().string(from: user.updatedAt)
	
	return NSDictionary(
								objects: [user.userID, createdAt, updatedAt, user.email, user.firstName, user.lastName, user.fullName, user.profilePic, user.phoneNumber, user.favoriteCourts, user.mainCourt],
								forKeys: [kUSERID as NSCopying, kCREATEDAT as NSCopying, kUPDATEDAT as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kPROFILEPIC as NSCopying, kPHONE as NSCopying, kFAVORITECOURTS as NSCopying, kMAINCOURT as NSCopying ]) //now this func create and return an NSDictionary
}


//method for updating our users in Firebase with any values we want
func updateCurrentUser(withValues: [String : Any], withBlock: @escaping(_ success: Bool) -> Void) { //will pass a dictionary with an Any value, with running a background thread escaping, pass success type boolean, so we can return if user was updated successfully, no return here so void
	
	if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
		guard let currentUser = CurrentUser.currentUser() else { return }
		let userObject = userDictionaryFrom(user: currentUser).mutableCopy() as! NSMutableDictionary //this makes the normal dictionary a mutable dictionary and specify it as NSMutableDictionary
		userObject.setValuesForKeys(withValues) //pass our withValues parameter and to pass it to userObject, now we can save our user to Firebase
		
		let ref = firDatabase.child(kUSER).child(currentUser.userID)
		ref.updateChildValues(withValues) { (error, ref) in
			if error != nil {
				withBlock(false)
				return
			}
			
			UserDefaults.standard.set(userObject, forKey: kCURRENTUSER) //update our user in our UserDefaults
			UserDefaults.standard.synchronize()
			withBlock(true)
		}
	}
	
}


func isUserLoggedIn(viewController: UIViewController) -> Bool {
	
	if CurrentUser.currentUser() != nil {
		return true
	} else { //if no user, show registerController
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
		viewController.present(vc, animated: true, completion: nil)
		return false
	}
}
