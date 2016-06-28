//
//  PhotoNotes+CoreDataProperties.swift
//  PhotoJournal
//
//  Created by Prasanthi Relangi on 6/26/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension PhotoNotes {

    @nonobjc class func fetchRequest() -> NSFetchRequest<PhotoNotes> {
        return NSFetchRequest<PhotoNotes>(entityName: "PhotoNotes");
    }

    @NSManaged var photo: NSObject?
    @NSManaged var notes: String?
    @NSManaged var timestamp: NSDate?
    
    //To retrieve data as UIImage
    var image: UIImage? {
        set {
            photo = newValue
        }
        get {
            return photo as? UIImage
        }
    }

}
