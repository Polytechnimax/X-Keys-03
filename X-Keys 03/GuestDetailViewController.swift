//
//  GuestDetailViewController.swift
//  X-Keys 02
//
//  Created by LARCHER Maxime on 21/10/2015.
//  Copyright © 2015 LARCHER Maxime. All rights reserved.
//

import UIKit

class GuestDetailViewController: UIViewController {

	var guestToShow: Guest?
	@IBOutlet weak var name_Label: UILabel!
	@IBOutlet weak var firstName_Label: UILabel!
	@IBOutlet weak var photo_ImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if let guest = guestToShow
		{
			photo_ImageView.image = guest.picture
			name_Label.text = guest.name
			firstName_Label.text = guest.firstName
			navigationController!.title = name_Label.text! + " " + firstName_Label.text!
		}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
