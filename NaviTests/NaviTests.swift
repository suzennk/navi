//
//  NaviTests.swift
//  NaviTests
//
//  Created by Susan Kim on 2021/07/28.
//

import XCTest
@testable import Navi

class NaviTests: XCTestCase {
    let db: DataBaseService = DataBaseService.shared
    var originalCount: Int = 0
    var verse: Verse?
    
    override func setUpWithError() throws {
        originalCount = db.count
    }

    override func tearDownWithError() throws {
        do {
            sleep(1)
        }    }
    
    func testAddOYO() throws {
        let res = db.addOYOVerse(bible: "마태복음", chapter: 11, startVerse: 12, middleSymbol: nil, endVerse: nil, head: "내가 추가함", contents: "세례 요한의 때부터 지금까지 천국은 침노를 당하나니 침노하는 자는 빼앗느니라")
        
        switch res {
        case .success(_):
            XCTAssertEqual(db.count, originalCount + 1)
        case .failure(_):
            XCTAssertEqual(db.count, originalCount)
        }
    }
    
    func testGenerateId() throws {
        let res = db.addOYOVerse(bible: "이사야", chapter: 35, startVerse: 4, middleSymbol: nil, endVerse: nil, head: "최애 구절", contents: "겁내는 자들에게 이르기를 굳세어라, 두려워하지 말라, 보라 너희 하나님이 오사 보복하시며 갚아 주실 것이라 하나님이 오사 너희를 구하시리라 하라")
        
        switch res {
        case .success(let verse):
            XCTAssertLessThan(Date(timeIntervalSinceReferenceDate: TimeInterval(verse.id)).distance(to: Date()), 2)
        case .failure(_):
            XCTAssertEqual(db.count, originalCount)
        }
    }
    
    /// Verse ID's should be unique
    func testIDUniqueness() throws {
        let verses = db.fetch(request: Verse.fetchRequest())
        print(verses.map{$0.id}.sorted(by: <))
        print(Set(verses.map{$0.id}).sorted(by: <))
        XCTAssertEqual(verses.count, Set(verses.map{ $0.id }).count)
    }
    
    func testAddOYO2() throws {
        let res = db.addOYOVerse(bible: "역대하", chapter: 7, startVerse: 14, middleSymbol: nil, endVerse: nil, head: "솔로몬에게 주의를 준 말씀", contents: "내 이름으로 일컫는 내 백성이 그 악한 길에서 떠나 스스로 겸비하고 기도하여 내 얼굴을 구하면 내가 하늘에서 듣고 그 죄를 사하고 그 땅을 고칠찌라")
        switch res {
        case .success(_):
            XCTAssertEqual(db.count, originalCount + 1)
        case .failure(_):
            XCTAssertEqual(db.count, originalCount)
        }
    }
    
    func testRemoveOYO() throws {
        let v = db.fetch(request: Verse.fetchRequestOfOYO()).last!
        
        let res = db.remove(v)
        
        switch res {
        case .success():
            XCTAssertEqual(db.count, originalCount - 1)
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
    
    func testSorting() throws {
        let res = db.fetchVerse(of: [("LOA", "5확신")])
        XCTAssertGreaterThan(res.count, 0)
        
        let fetchedIds = res.map { $0.id }
        let expectedIds = res.map { $0.id }.sorted(by: <)
        
        XCTAssertEqual(fetchedIds, expectedIds)
    }
    
    func testDuplicateHeads() throws {
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
