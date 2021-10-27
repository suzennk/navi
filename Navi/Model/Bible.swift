//
//  Bible.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/08.
//
enum Testament: CaseIterable {
    case 구약
    case 신약
}

enum Bible: String, Comparable, CaseIterable {
    case 창세기
    case 출애굽기
    case 레위기
    case 민수기
    case 신명기
    case 여호수아
    case 사사기
    case 룻기
    case 사무엘상
    case 사무엘하
    case 열왕기상
    case 열왕기하
    case 역대상
    case 역대하
    case 에스라
    case 느헤미야
    case 에스더
    case 욥기
    case 시편
    case 잠언
    case 전도서
    case 아가
    case 이사야
    case 예레미야
    case 예레미야애가
    case 에스겔
    case 다니엘
    case 호세아
    case 요엘
    case 아모스
    case 오바댜
    case 요나
    case 미가
    case 나훔
    case 하박국
    case 스바냐
    case 학개
    case 그사랴
    case 말라기
    case 마태복음
    case 마가복음
    case 누가복음
    case 요한복음
    case 사도행전
    case 로마서
    case 고린도전서
    case 고린도후서
    case 갈라디아서
    case 에베소서
    case 빌립보서
    case 골로새서
    case 데살로니가전서
    case 데살로니가후서
    case 디모데전서
    case 디모데후서
    case 디도서
    case 빌레몬서
    case 히브리서
    case 야고보서
    case 베드로전서
    case 베드로후서
    case 요한1서
    case 요한2서
    case 요한3서
    case 유다서
    case 요한계시록
    
    static let testaments = ["구약", "신약"] // 구약: 창세기 ~ 말라기, 신약: 마태복음 ~ 요한계시록
    static let divisions = ["율법서", "역사서", "시가서", "예언서", "사복음서", "역사서", "바울서신", "공동서신", "예언서"]
    
    var title: String {
        return String(describing: self)
    }
    
    var order: Int {
        return Bible.allCases.firstIndex(of: self) ?? Bible.allCases.count
    }
    
    static func < (lhs: Bible, rhs: Bible) -> Bool {
        lhs.order < rhs.order
    }
}
