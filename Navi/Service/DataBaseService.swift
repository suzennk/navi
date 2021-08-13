//
//  DataBaseService.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/04.
//

import Foundation

typealias Theme = String
typealias Head = String

class DataBaseService {
    static let shared = DataBaseService()
    private var _verses: [Verse] = []
    private let _themes: [Theme] = ["LOA", "LOC", "60구절", "DEP", "180구절", "OYO"]
    
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
        // load verses at first launch
        loadVersesFromCSV()
    }

    /**
        암송 말씀 데이터파일(.csv)을 읽고 데이터 파싱을 진행한다.
     */
    private func parseFile(at url:URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: "\t")}) {
                for item in dataArr[1..<dataArr.count] {
                    if item.count < 10 {
                        continue
                    }
                    let chapter = item[2].replacingOccurrences(of: ":", with: "")
                    let theme = item[6]
                    let verse = Verse(id: item[0], bible: item[1], chapter: chapter, startVerse: item[3], middleSymbol: item[4], endVerse: item[5], theme: theme, head: item[7], subHead: item[8], title: item[9], contents: item[10])
                    
                    _verses.append(verse)
                }
            }
        } catch {
            print("Error reading file")
        }
    }
    
    private func loadVersesFromCSV() {
        guard let path = Bundle.main.path(forResource: "cardset", ofType: "tsv") else {
            print("Error locating file")
            return
        }
        parseFile(at: URL(fileURLWithPath: path))
    }
}

struct Verse {
    let id: String
    let bible: String
    let chapter: String
    let startVerse: String
    let middleSymbol: String
    let endVerse: String
    let theme: String
    let head: String
    let subHead: String
    let title: String
    let contents: String
}
