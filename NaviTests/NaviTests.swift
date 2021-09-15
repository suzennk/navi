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
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let originalCount = db.count
    
        let res = db.addOYOVerse(bible: "마태복음", chapter: 11, startVerse: 12, middleSymbol: nil, endVerse: nil, head: "내가 추가함", contents: "세례 요한의 때부터 지금까지 천국은 침노를 당하나니 침노하는 자는 빼앗느니라")
        
        switch res {
        case .success(let v):
            let newCount = db.count
            XCTAssert(newCount == originalCount + 1)
            db.remove(v)
        case .failure(_):
            let newCount = db.count
            XCTAssert(newCount == originalCount)
        }
        
        XCTAssert(db.count == originalCount)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
