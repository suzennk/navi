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
        }
    }
    
    func testAddOYO() throws {
        let res = db.addOYOVerse(bible: "마태복음", chapter: 11, startVerse: 12, middleSymbol: nil, endVerse: nil, head: "내가 추가함", title: "", contents: "세례 요한의 때부터 지금까지 천국은 침노를 당하나니 침노하는 자는 빼앗느니라")
        
        switch res {
        case .success(_):
            XCTAssertEqual(db.count, originalCount + 1)
        case .failure(_):
            XCTAssertEqual(db.count, originalCount)
        }
    }
    
    func testGenerateId() throws {
        let res = db.addOYOVerse(bible: "이사야", chapter: 35, startVerse: 4, middleSymbol: nil, endVerse: nil, head: "최애 구절", title: "", contents: "겁내는 자들에게 이르기를 굳세어라, 두려워하지 말라, 보라 너희 하나님이 오사 보복하시며 갚아 주실 것이라 하나님이 오사 너희를 구하시리라 하라")
        
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
        let res = db.addOYOVerse(bible: "역대하", chapter: 7, startVerse: 14, middleSymbol: nil, endVerse: nil, head: "솔로몬에게 주의를 준 말씀", title: "", contents: "내 이름으로 일컫는 내 백성이 그 악한 길에서 떠나 스스로 겸비하고 기도하여 내 얼굴을 구하면 내가 하늘에서 듣고 그 죄를 사하고 그 땅을 고칠찌라")
        switch res {
        case .success(_):
            XCTAssertEqual(db.count, originalCount + 1)
        case .failure(_):
            XCTAssertEqual(db.count, originalCount)
        }
    }
    
    func testAddDummyOyos() throws {
        _ = db.addOYOVerse(bible: "요한삼서", chapter: 1, startVerse: 2, middleSymbol: nil, endVerse: nil, head: "하나님의 사랑", title: "", contents: "사랑하는 자여 네 영혼이 잘됨 같이 네가 범사에 잘되고 강건하기를 내가 간구하노라")
        do {
            sleep(1)
        }
        _ = db.addOYOVerse(bible: "누가복음", chapter: 6, startVerse: 35, middleSymbol: "-", endVerse: 36, head: "하나님의 사랑", title: "", contents: "오직 너희는 원수를 사랑하고 선대하며 아무 것도 바라지 말고 빌리라 그리하면 너희 상이 클 것이요 또 지극히 높으신 이의 아들이 되리니 그는 은혜를 모르는 자와 악한 자에게도 인자로우시니라 너희 아버지의 자비하심 같이 너희도 자비하라")
        do {
            sleep(1)
        }
        _ = db.addOYOVerse(bible: "마가복음", chapter: 12, startVerse: 30, middleSymbol: "-", endVerse: 31, head: "하나님의 사랑", title: "", contents: "네 마음을 다하고 목숨을 다하고 뜻을 다하고 힘을 다하여 주 너의 하나님을 사랑하라 하신 것이요 둘째는 이것이니 네 이웃을 네 몸과 같이 사랑하라 하신 것이라 이에서 더 큰 계명이 없느니라")
        do {
            sleep(1)
        }
        _ = db.addOYOVerse(bible: "고린도전서", chapter: 13, startVerse: 4, middleSymbol: "-", endVerse: 8, head: "하나님의 사랑", title: "", contents: "사랑은 오래 참고 사랑은 온유하며 투기하는 자가 되지 아니하며 사랑은 자랑하지 아니하며 교만하지 아니하며 무례히 행치 아니하며 자기의 유익을 구치 아니하며 성내지 아니하며 악한 것을 생각지 아니하며 불의를 기뻐하지 아니하며 진리와 함께 기뻐하고 모든 것을 참으며 모든 것을 믿으며 모든 것을 바라며 모든 것을 견디느니라 사랑은 언제까지든지 떨어지지 아니하나 예언도 폐하고 방언도 그치고 지식도 폐하리라")
        do {
            sleep(1)
        }
        _ = db.addOYOVerse(bible: "잠언", chapter: 4, startVerse: 20, middleSymbol: "-", endVerse: 22, head: "치유의 말씀", title: "", contents: "내 아들아 내 말에 주의하며 나의 이르는 것에 네 귀를 기울이라 그것을 네 눈에서 떠나게 말며 네 마음 속에 지키라 그것은 얻는 자에게 생명이 되며 그 온 육체의 건강이 됨이니라")
        do {
            sleep(1)
        }
        _ = db.addOYOVerse(bible: "이사야", chapter: 53, startVerse: 4, middleSymbol: "-", endVerse: 5, head: "치유의 말씀", title: "", contents: "그는 실로 우리의 질고를 지고 우리의 슬픔을 당하였거늘 우리는 생각하기를 그는 징벌을 받아서 하나님에게 맞으며 고난을 당한다 하였노라 그가 찔림은 우리의 허물을 인함이요 그가 상함은 우리의 죄악을 인함이라 그가 징계를 받음으로 우리가 평화를 누리고 그가 채찍에 맞음으로 우리가 나음을 입었도다")
        do {
            sleep(1)
        }
        _ = db.addOYOVerse(bible: "누가복음", chapter: 8, startVerse: 43, middleSymbol: "-", endVerse: 48, head: "치유의 말씀", title: "", contents: "이에 열 두 해를 혈루증으로 앓는 중에 아무에게도 고침을 받지 못하던 여자가 예수의 뒤로 와서 그 옷가에 손을 대니 혈루증이 즉시 그쳤더라 예수께서 가라사대 내게 손을 댄 자가 누구냐 하시니 다 아니라 할 때에 베드로가 가로되 주여 무리가 옹위하여 미나이다 예수께서 가라사대 내게 손을 댄 자가 있도다 이는 내게서 능력이 나간 줄 앎이로다 하신대 여자가 스스로 숨기지 못할 줄을 알고 떨며 나아와 엎드리어 그 손 댄 연고와 곧 나은 것을 모든 사람 앞에서 고하니 예수께서 이르시되 딸아 네 믿음이 너를 구원하였으니 평안히 가라 하시더라")
        do {
            sleep(1)
        }
        _ = db.addOYOVerse(bible: "시편", chapter: 107, startVerse: 19, middleSymbol: "-", endVerse: 21, head: "치유의 말씀", title: "", contents: "이에 그들이 그들의 고통 때문에 여호와께 부르짖으매 그가 그들의 고통에서 그들을 구원하시되 그가 그으이 말씀을 보내어 그들을 고치시고 위험한 지경에서 건지시는도다 여호와의 인자하심과 인생에게 행하신 기적으로 말미암아 그를 찬송할지로다")
        do {
            sleep(1)
        }
        XCTAssertEqual(db.count, originalCount + 8)
    }
    
    func testRemoveOYO() throws {
        guard let v = db.fetch(request: Verse.fetchRequest(oyo: true)).last else {
            XCTAssertEqual(db.count, 0)
            return
        }
        
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
