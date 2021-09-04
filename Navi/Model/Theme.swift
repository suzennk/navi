//
//  Theme+CoreDataClass.swift
//  
//
//  Created by Susan Kim on 2021/09/04.
//
//

import Foundation
import CoreData

@objc(Theme)
public class Theme: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Theme> {
        return NSFetchRequest<Theme>(entityName: "Theme")
    }

    @NSManaged public var name: String?

}
