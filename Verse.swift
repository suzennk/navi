//
//  Verse.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/18.
//
//

import Foundation
import CoreData

@objc(Verse)
public class Verse: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Verse> {
        return NSFetchRequest<Verse>(entityName: "Verse")
    }

    @NSManaged public var id: Int64
    @NSManaged public var subHead: String
    @NSManaged public var head: String
    @NSManaged public var theme: String
    @NSManaged public var endVerse: Int16
    @NSManaged public var middleSymbol: String?
    @NSManaged public var startVerse: Int16
    @NSManaged public var chapter: Int16
    @NSManaged public var bible: String
    @NSManaged public var contents: String
    @NSManaged public var title: String
    @NSManaged public var memorized: Bool
}
