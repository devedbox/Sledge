//
//  SafeIndexable.swift
//  SafeAccessible
//
//  Created by devedbox on 2018/3/15.
//

public protocol SafeIndexable {
    associatedtype IndexValue: Comparable
    associatedtype Element
    associatedtype SubSequence
    
    var startIndex: IndexValue { get }
    var endIndex: IndexValue { get }
    
    subscript(i: Self.IndexValue) -> Self.Element? { get set }
    subscript(range: Range<IndexValue>) -> Self.SubSequence? { get set }
}
