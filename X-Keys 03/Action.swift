//
//  Action.swift
//  X-Keys 03
//
//  Created by LARCHER Maxime on 07/02/2016.
//  Copyright © 2016 LARCHER Maxime. All rights reserved.
//

import Foundation

class Action: NSObject
{
    // MARK: -- Properties
    var name: String?
    var date: NSDate!
    var type: Bool!
    var dateFormatter: NSDateFormatter!
    
    
    // MARK: -- Initialisation
    init(name: String?, date: NSDate, type: Bool) {
        super.init()
        self.name = name
        self.date = date
        self.type = type
        dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy à HH:hh"
    }
    
    
    // MARK: -- Methods
    func getDetails () -> String {
        let dateAsString = dateFormatter.stringFromDate(date)
        switch type
        {
            case nil:
				return name! + " a effectué une action sur la porte le " + dateAsString
			case true:
				return name! + " a ouvert la porte le " + dateAsString
			default:
				return "La porte s'est fermée le " + dateAsString
        }
    }
}
