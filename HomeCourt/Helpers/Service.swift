//
//  Service.swift
//  KingOfTheCourt
//
//  Created by Samuel Folledo on 2/16/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class Service { //FB ep.29 1mins
	
	//presentAlert
	static func presentAlert(on: UIViewController, title: String, message: String) {
		let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
			alertVC.dismiss(animated: true, completion: nil)
		}
		alertVC.addAction(okAction)
		on.present(alertVC, animated: true, completion: nil)
	}
	
	static func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil ) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		
		for action in actions { //loop through all actions
			alert.addAction(action)
		}
		
		return alert
	}
	
	
	static func toMapController(on: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapController") as! MapViewController
		on.present(vc, animated: true, completion: nil)
	}
	
	static func toLoginController(on: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
		on.present(vc, animated: true, completion: nil)
	}
	
	
	
	
	
	static func isValidWithEmail(email: String) -> Bool { //FB ep.29 2mins validate email
		/*
		1) declare a rule
		2) apply this rule in NSPredicate
		3) evaluate the test with the email we received
		*/
		let regex:CVarArg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" //FB ep.29 5mins // [A-Z0-9a-z._%+-] means capital A-Z, and small letters a-z, and number 0 - 9, and . _ % + and - are allowed (which is samuelfolledo in samuelfolledo@gmail.com). PLUS @ and the next format [A-Za-z0-9.-] which allows all small letters, big letters, and integers, and . - (which is the @[gmail] in samuelfolledo@gmail.com). COMPULSARY AND which will allow small and big letters only like .com or .uk. {2,} and the minimum symboys are at least 2 symbols
		let test = NSPredicate(format: "SELF MATCHES %@", regex) //FB ep.29 6mins we want it to be matching with out regex rules
		let result = test.evaluate(with: email) //FB ep.29 7mins
		
		return result //FB ep.29 7mins
	}
	
	
	static func isValidWithName(name: String) -> Bool { //FB ep.29 8mins
		let regex = "[A-Za-z]{2,}" //FB ep.29 9mins allow letters only with at least 2 chars for the name
		let test = NSPredicate(format: "SELF MATCHES %@", regex) //FB ep.29 10mins
		let result = test.evaluate(with: name) //FB ep.29 10mins
		
		return result  //FB ep.29 11mins
	}
	
}
