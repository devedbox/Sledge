//
//  SafeIndexable.swift
//  SafeAccessible
//
//  Created by devedbox on 2018/3/15.
//

// MARK: - IndexConvertible.

/// A protocol represents the confirming types can be converted to the associated type
/// `Index`.
public protocol IndexConvertible: Comparable {
    /// The index value type.
    associatedtype Index: Comparable
    /// Convert the receiver value as the `Index` value.
    func asIndex() throws -> Index
}

extension IndexConvertible {
    /// Returns the index value of `Index` type.
    public var indexValue: Self.Index? {
        return try? asIndex()
    }
}

// MARK: - SafeIndexable.

/// A protocol represents the type canbe accessed by index safly.
public protocol SafeIndexable {
    /// The index value type.
    associatedtype SafeIndex: IndexConvertible
    /// The element type.
    associatedtype Element
    /// The sub sequence type.
    associatedtype SubSequence

    
    subscript(i: Self.SafeIndex) -> Self.Element? { get }
    subscript(range: Range<SafeIndex>) -> Self.SubSequence? { get }
}

// MARK: - SafeIndex.

public struct AnySafeIndex<Base: Comparable>: IndexConvertible {
    public typealias Index = Base
    /// The underlying storage of the index value.
    private var _index: Base
    
    public func asIndex() throws -> Index {
        return _index
    }
    
    public init(_ indexValue: Base) {
        _index = indexValue
    }
}

// MARK: - Convenience.

extension AnySafeIndex {
    public static func safe<T: Comparable>(_ t: T) -> AnySafeIndex<T> {
        return AnySafeIndex<T>(t)
    }
}

// MARK: - Comparable Conforming.

extension AnySafeIndex {
    public static func <(lhs: AnySafeIndex<Base>, rhs: AnySafeIndex<Base>) -> Bool {
        return lhs._index < rhs._index
    }
    
    public static func ==(lhs: AnySafeIndex<Base>, rhs: AnySafeIndex<Base>) -> Bool {
        return lhs._index == rhs._index
    }
}
