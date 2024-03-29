//
//  DataBaseService.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/04.
//

import Foundation
import UIKit
import CoreData

typealias Head = String
typealias Theme = String

class DataBaseService {
    static let shared = DataBaseService()
    static let fileName = "cardset"
    static let updateFileName = "updated_cardset"
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext

    private var hasRemovedPeriods: Bool {
        return UserDefaults.standard.bool(forKey: "hasRemovedPeriods")
    }
    
    /**
     Returns default themes: 5(predefined) + 1(OYO)
     */
    private let _themes: [String] = ["LOA", "LOC", "60구절", "DEP", "180구절", "OYO"]
    
    /**
     Returns all verses including OYO verses.
     */
    private var _verses: [Verse] {
        get {
            return fetch(request: Verse.fetchRequest())
        }
    }
    
    /**
     Returns the number of verses including OYOs.
     */
    public var count: Int {
        let number = try? context.count(for: Verse.fetchRequest())
        return number ?? 0
    }
    
    public var themes: [String] {
        get {
            return Array(_themes)
        }
    }
    
    public var verses: [Verse] {
        get {
            return _verses
        }
    }
    
    /**
     Verses in cardset.tsv
     */
    private var _predefinedVerses: [Verse] {
        get {
            return fetch(request: Verse.fetchRequest(oyo: false))
        }
    }
    
    public var todayVerse: Verse {
        let count = _predefinedVerses.count
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.startOfDay(for: Date()).timeIntervalSinceReferenceDate
        return _verses[Int(date) % count]
    }
    
    /**
     verses로부터 unique한 theme으로부터 head만 뽑아낸 dictionary 
     */
    public var categories: [String : [Head]] {
        get {
            var cats = [String : [Head]]()
            _themes.forEach { theme in
                let heads = Set(
                    _verses.filter {
                        $0.theme == theme
                    }.map {
                        $0.head
                    }
                ).sorted(by: <)
                cats[theme] = heads
            }
            return cats
        }
    }
    
    // MARK: - OYO
    private var _oyoHeads: [Head] {
        get {
            return Array(Set(_oyoVerses.map { $0.head }))
        }
    }
    
    private var _oyoVerses: [Verse] {
        get {
            return fetch(request: Verse.fetchRequest(oyo: true))
        }
    }
    
    public var oyoHeads: [Head] {
        get {
            return _oyoHeads
        }
    }
    public var categorizedOyoVerses: [Head: [Verse]] {
        get {
            var catVerses = [Head: [Verse]]()
            _oyoHeads.forEach { head in
                let verses = _oyoVerses.filter {
                    $0.head == head
                }.sorted(by: { $0.id < $1.id })
                catVerses[head] = verses
            }
            return catVerses
        }
    }
    
    private init() {
        if let number = try? context.count(for: Verse.fetchRequest()), number == 0  {
            // load verses at first launch
            print("Load verses from data file")
            loadVersesFromTSV()
        }
        
        // update verses with update file
        print("Update verses with update file")
        updateVerses()
        
        // MARK: - MUST DELETE: for testing
//        fetch(request: Theme.fetchRequest()).forEach {
//            context.delete($0)
//        }
//        let theme = Theme(context: context)
//        theme.setValue("180구절", forKey: "name")
//
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }

//        fetch(request: Verse.fetchRequest()).forEach {
//            context.delete($0)
//        }
//        print(try? context.count(for: Verse.fetchRequest()))
//        loadVersesFromTSV()
    }
    
    // MARK: - Fetch: Verse
    public func fetchVerse(of categories: [(Theme, Head)]) -> [Verse] {
        return fetch(request: Verse.fetchRequest(of: categories))
    }
    
    public func fetch(request: NSFetchRequest<Verse>) -> [Verse] {
        if let verses = try? context.fetch(request) {
            return verses
        }
        return []
    }
    
    public func addOYOVerse(bible: String, chapter: Int, startVerse: Int, middleSymbol: String?, endVerse: Int?, head: String, title: String, contents: String) -> Result<Verse, Error> {
        let verse = Verse(context: context)
        verse.setValue(Date().timeIntervalSinceReferenceDate, forKey: "id")
        verse.setValue(bible, forKey: "bible")
        verse.setValue(chapter, forKey: "chapter")
        verse.setValue(startVerse, forKey: "startVerse")
        verse.setValue(middleSymbol, forKey: "middleSymbol")
        verse.setValue(endVerse ?? startVerse, forKey: "endVerse")
        verse.setValue("OYO", forKey: "theme")
        verse.setValue(head, forKey: "head")
        verse.setValue("", forKey: "subHead")
        verse.setValue(title, forKey: "title")
        verse.setValue(contents, forKey: "contents")
        
        do {
            try context.save()
        } catch {
            return .failure(error)
        }
        return .success(verse)
    }
    
    public func remove(_ verse: Verse) -> Result<Void, Error> {
        context.delete(verse)
        return save()
    }
    
    public func save() -> Result<Void, Error> {
        do {
            try context.save()
        } catch {
            return .failure(error)
        }
        return .success(Void())
    }
    
    // MARK: - Load at first launch
    /**
        암송 말씀 데이터파일(.tsv)을 읽고 데이터 파싱을 진행한다.
     */
    private func parseFile(at url:URL) -> [[String]]? {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: "\t")})
            return dataArr
        } catch {
            print("Error reading file")
        }
        return nil
    }
    
    private func loadAndSaveEntities(from dataArr: [[String]]) {
        dataArr[1..<dataArr.count].forEach { item in
            // skip invalid lines
            if (318...319).contains(Int(item[0]) ?? 0) {
                print(item)
            }
            
            if item.count < 10 {
                return
            }

            let chapter = Int(item[2].replacingOccurrences(of: ":", with: ""))!

            let verse = Verse(context: context)
            verse.setValue(Int(item[0])!, forKey: "id")
            verse.setValue(item[1], forKey: "bible")
            verse.setValue(chapter, forKey: "chapter")
            verse.setValue(Int(item[3])!, forKey: "startVerse")
            verse.setValue(item[4] == "" ? nil : item[4], forKey: "middleSymbol")
            verse.setValue(Int(item[5]) ?? 0, forKey: "endVerse")
            verse.setValue(item[6], forKey: "theme")
            verse.setValue(item[7], forKey: "head")
            verse.setValue(item[8], forKey: "subHead")
            verse.setValue(item[9], forKey: "title")
            verse.setValue(item[10], forKey: "contents")
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
        
    private func loadVersesFromTSV() {
        guard let path = Bundle.main.path(forResource: "\(DataBaseService.fileName)", ofType: "tsv") else {
            print("Error locating file")
            return
        }
        guard let dataArr = parseFile(at: URL(fileURLWithPath: path)) else {
            print("Error reading file")
            return
        }
        
        loadAndSaveEntities(from: dataArr)
    }
    
    // MARK: - Patch updated verses
    private func loadUpdateDataArray() -> [[String]]? {
        guard let path = Bundle.main.path(forResource: "\(DataBaseService.updateFileName)", ofType: "tsv") else {
            print("Error locating update file")
            return nil
        }
        
        let dataArr = parseFile(at: URL(fileURLWithPath: path))
        return dataArr
    }
    
    private func updateVerses() {
        guard let updateData = loadUpdateDataArray() else {
            print("Failed to update data due to empty data")
            return
        }
        print("update data count: \(updateData.count)")
        
        updateData.enumerated().forEach { (idx, item) in
            if item.count < 10 { return }
            if let originalVerse = fetch(request: Verse.fetchRequest(id: Int64(idx))).first {
                let chapter = Int(item[2].replacingOccurrences(of: ":", with: ""))!

                originalVerse.setValue(Int(item[0])!, forKey: "id")
                originalVerse.setValue(item[1], forKey: "bible")
                originalVerse.setValue(chapter, forKey: "chapter")
                originalVerse.setValue(Int(item[3])!, forKey: "startVerse")
                originalVerse.setValue(item[4] == "" ? nil : item[4], forKey: "middleSymbol")
                originalVerse.setValue(Int(item[5]) ?? 0, forKey: "endVerse")
                originalVerse.setValue(item[6], forKey: "theme")
                originalVerse.setValue(item[7], forKey: "head")
                originalVerse.setValue(item[8], forKey: "subHead")
                originalVerse.setValue(item[9], forKey: "title")
                originalVerse.setValue(item[10], forKey: "contents")
            }
        }
        
        _ = save()
    }
}
