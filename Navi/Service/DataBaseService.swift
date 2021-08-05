//
//  DataBaseService.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/04.
//

import Foundation

class DataBaseService {
    static let shared = DataBaseService()
    var verses: [Verse] = []

    private init() {
        // 첫 실행때!
        loadLocationsFromCSV()
//        print(verses)
    }

    /**
        암송 말씀 데이터파일(.csv)을 읽고 데이터 파싱을 진행한다.
     */
    private func parseCSV(at url:URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                for item in dataArr[1..<dataArr.count] {
                    if item.count < 10 {
                        continue
                    }
                    
                    let verse = Verse(id: item[0], bible: item[1], chapter: Int(item[2]) ?? 0, startVerse: Int(item[3]) ?? 0, endVerse: Int(item[5]), theme: item[6], head: item[7], subHead: item[8], title: item[9], contents: item[10])
                    print(verse)
                    verses.append(verse)
                }
            }
        } catch {
            print("Error reading CSV file")
        }
        
    }
    
    private func loadLocationsFromCSV() {
        let path = Bundle.main.path(forResource: "cardset", ofType: "csv")!
        parseCSV(at: URL(fileURLWithPath: path))
    }
    
}

struct Verse {
    let id: String
    let bible: String
    let chapter: Int
    let startVerse: Int
    let endVerse: Int?
    let theme: String
    let head: String
    let subHead: String
    let title: String
    let contents: String
}
