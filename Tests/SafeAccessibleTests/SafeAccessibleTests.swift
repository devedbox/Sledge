//
//  SafeAccessibleTests.swift
//  Sledge
//
//  Created by devedbox on 2018/3/16.
//

import XCTest
@testable import SafeAccessible

class SafeAccessibleTests: XCTestCase {
    
    var array = [1, 2, 3, 4, 5]
    var safeIndex: Int {
        return 2
    }
    var dangerIndex: Int {
        return array.endIndex
    }
    var errorIndex: Int {
        return array.index(after: array.endIndex)
    }
    
    // MARK: - Safe Accessibility.
    
    func testSafeSubscriptWithIndex() {
        let safeCollection = array.safe
        
        let valueAtIndex5 = safeCollection[.safe(5)]
        XCTAssertNil(valueAtIndex5)
    }
    
    func testSafeSubscriptWithRange() {
        let safeCollection = array.safe
        
        let valueAtIndex5 = safeCollection[(.safe(0))..<(.safe(5))]
        XCTAssertNil(valueAtIndex5)
    }
    
    // MARK: - Collection.
    
    func testCollection() {
        let safe = array.safe
        print("Start index: \(safe.startIndex)")
        print("End index: \(safe.endIndex)")
        print("Index after end index: \(safe.index(after: safe.endIndex))")
        
        XCTAssertEqual(array.startIndex, array.safe.startIndex)
        XCTAssertEqual(array.endIndex, array.safe.endIndex)
        XCTAssertEqual(array.index(after: dangerIndex), array.safe.index(after: dangerIndex))
        XCTAssertEqual(array[safeIndex], array.safe[safeIndex])
    }
    
    func testCount() {
        XCTAssertEqual(array.count, array.safe.count)
    }
    
    func testIndexOf() {
        let value = 3
        
        XCTAssertEqual(array.index(of: value), array.safe.index(of: value))
    }
    
    func testIndexWhere() {
        let value = 3
        
        XCTAssertEqual(array.index { $0 == value }, array.safe.index { $0 == value })
    }
    
    func testPrefixUpTo() {
        XCTAssertEqual(array.prefix(upTo: safeIndex), array.safe.prefix(upTo: safeIndex))
        XCTAssertEqual(array.prefix(upTo: dangerIndex), array.safe.prefix(upTo: dangerIndex))
    }
    
    func testPrefixThrough() {
        XCTAssertEqual(array.prefix(through: safeIndex), array.safe.prefix(through: safeIndex))
    }
    
    func testSuffixFrom() {
        XCTAssertEqual(array.suffix(from: safeIndex), array.safe.suffix(from: safeIndex))
        XCTAssertEqual(array.suffix(from: dangerIndex), array.safe.suffix(from: dangerIndex))
    }
    /*
    func testPopFirst() {
        var array = self.array
        var safe = SafeCollection(["ss": 2])
        array.popFirst()
        safe.popFirst()
    }
     */
    func testRemoveFirst() {
        var safe = array.safe
        let suffix = array[0..<1]
        // let safeSuffix = safe[0..<1]
        safe.removeFirst()
//        var safeCollection = SafeCollection([1, 2])
//        safeCollection.removeFirst()
//        XCTAssertEqual(array.removeFirst(), safe.removeFirst())
    }
}
