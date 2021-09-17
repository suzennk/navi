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
    
    @nonobjc public class func fetchReqest(of categories: [(theme: String, head: String)]) -> NSFetchRequest<Verse> {
        let request = NSFetchRequest<Verse>(entityName: "Verse")
        let sort = NSSortDescriptor(key: #keyPath(Verse.id), ascending: true)
        let subpredicates = categories.map {
            NSPredicate(format: "theme = %@ AND head = %@", "\($0.theme)", "\($0.head)") }
        request.sortDescriptors = [sort]
        request.predicate = NSCompoundPredicate(type: .or, subpredicates: subpredicates)
        return request
    }
    
    @nonobjc public class func fetchRequestOfOYO() -> NSFetchRequest<Verse> {
        let request = NSFetchRequest<Verse>(entityName: "Verse")
        let sort = NSSortDescriptor(key: #keyPath(Verse.id), ascending: true)
        let predicate = NSPredicate(format: "theme = %@", "OYO")
        request.sortDescriptors = [sort]
        request.predicate = predicate
        return request
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
