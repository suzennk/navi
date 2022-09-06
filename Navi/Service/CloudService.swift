//
//  CloudService.swift
//  Navi
//
//  Created by Susan Kim on 2022/08/22.
//

import Foundation
import CloudKit

class CloudService {
    static let shared = CloudService()
    let publicDatabase = CKContainer.default().publicCloudDatabase
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    private init() {
        
    }
    
    public func addOYOVerse(bible: String, chapter: Int, startVerse: Int, middleSymbol: String?, endVerse: Int?, head: String, title: String, contents: String, onComplete: @escaping(() -> Void)) {
        
        let verse = CKRecord(recordType: "Verse")
        verse.setValue(bible, forKey: "BIBLE")
        verse.setValue(chapter, forKey: "CHAPTER")
        verse.setValue(startVerse, forKey: "VERSE_START")
        verse.setValue(middleSymbol, forKey: "VERSE_MIDDLE")
        verse.setValue(endVerse ?? 0, forKey: "VERSE_END")
        verse.setValue("OYO", forKey: "THEME")
        verse.setValue(head, forKey: "HEAD")
        verse.setValue("", forKey: "SUBHEAD")
        verse.setValue(title, forKey: "TITLE")
        verse.setValue(contents, forKey: "CONTENT")
        
        publicDatabase.save(verse) { record, error in
            if let error = error {
                NSLog("Failed to save record, \(error.localizedDescription)")
                return;
            }
            
            guard let record = record else { return }
            NSLog("Successfully saved record, \(record)")
            onComplete()
        }
    }

}
