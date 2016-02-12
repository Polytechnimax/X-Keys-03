//
//  ViewController.swift
//  X-Keys 02
//
//  Created by LARCHER Maxime on 15/10/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class GuestEditingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	// MARK: Properties
	@IBOutlet weak var cancelButtonNavBar: UIBarButtonItem!
	@IBOutlet weak var saveButtonNavBar: UIBarButtonItem!
	@IBOutlet weak var picture_ImageView: UIImageView!
	@IBOutlet var name_TextField: UITextField!
	@IBOutlet weak var firstName_TextField: UITextField!
	
	var guestToEdit: Guest?
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		firstName_TextField.delegate = self
		name_TextField.delegate = self
		
		if let guest = guestToEdit
		{
			navigationItem.title = guest.firstName
			name_TextField.text = guest.name
			firstName_TextField.text = guest.firstName
			picture_ImageView.image = guest.picture
		}
		
		checkValidName()
	}
	
	

	// MARK: Navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if saveButtonNavBar === sender
		{
			let name = name_TextField.text ?? ""
			let firstName = firstName_TextField.text ?? ""
			let picture = picture_ImageView.image
			guestToEdit = Guest(name: name, firstName: firstName, picture: picture)
		}
	}
	
	// MARK: UIImagePickerControllerDElegate
	
	/*func imagePickerControllerDidCancel(picker: UIImagePickerController)
	{
		dismissViewControllerAnimated(true, completion: nil)
	}*/
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		// Dismiss the picker if the user canceled.
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	/*func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
	{
		let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		picture_ImageView.image = selectedImage
		dismissViewControllerAnimated(true, completion: nil)
	}*/
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		// The info dictionary contains multiple representations of the image, and this uses the original.
		let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		
		// Set photoImageView to display the selected image.
		picture_ImageView.image = selectedImage
		
		// Dismiss the picker.
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: Actions
	@IBAction func cancel(sender: UIBarButtonItem)
	{
		let isPresentingInAddGuestMode = presentingViewController is UINavigationController
		
		if isPresentingInAddGuestMode
		{
			dismissViewControllerAnimated(true, completion: nil)
		}
		else
		{
			navigationController!.popViewControllerAnimated(true)
		}
		
	}
	@IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer)
	{
		// Hide the keyboard.
		name_TextField.resignFirstResponder()
		
		// UIImagePickerController is a view controller that lets a user pick media from their photo library.
		let imagePickerController = UIImagePickerController()
		
		// Only allow photos to be picked, not taken.
		imagePickerController.sourceType = .PhotoLibrary
		
		// Make sure ViewController is notified when the user picks an image.
		imagePickerController.delegate = self
		
		presentViewController(imagePickerController, animated: true, completion: nil)
	}
	
	// MARK: UITextFieldDelegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		firstName_TextField.resignFirstResponder()
		name_TextField.resignFirstResponder()
		return true
	}
	
	func textFieldDidEndEditing(textField: UITextField)
	{
		checkValidName()
		navigationItem.title = name_TextField.text
	}
	
	func textFieldDidBeginEditing(textField: UITextField)
	{
		saveButtonNavBar.enabled = false
	}
	
	func checkValidName()
	{
		let name = name_TextField.text ?? "", firstName = firstName_TextField.text ?? ""
		
		saveButtonNavBar.enabled = !name.isEmpty && !firstName.isEmpty
	}
}





