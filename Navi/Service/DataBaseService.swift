//
//  DataBaseService.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/04.
//

import Foundation
import UIKit
import CoreData

typealias Theme = String
typealias Head = String

class DataBaseService {
    static let shared = DataBaseService()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext

    private var _verses: [Verse] {
        get {
            if let verses = try? context.fetch(Verse.fetchRequest()) as? [Verse]  {
                return verses
            }
            return []
        }
    }
    private let _themes: [Theme] = ["LOA", "LOC", "60구절", "DEP", "180구절", "OYO"]
    
    public var themes: [Theme] {
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
     verses로부터 unique한 theme으로부터 head만 뽑아낸 dictionary 
     */
    public var categories: [Theme : [Head]] {
        get {
            var cats = [Theme : [Head]]()
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
    
    private init() {
        if let number = try? context.count(for: Verse.fetchRequest()), number == 0  {
            // load verses at first launch
            print("Load verses from data file")
            loadVersesFromTSV()
        }
    }
    /**
        암송 말씀 데이터파일(.csv)을 읽고 데이터 파싱을 진행한다.
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
        guard let path = Bundle.main.path(forResource: "cardset", ofType: "tsv") else {
            print("Error locating file")
            return
        }
        guard let dataArr = parseFile(at: URL(fileURLWithPath: path)) else {
            print("Error reading file")
            return
        }
        
        loadAndSaveEntities(from: dataArr)
    }
}
