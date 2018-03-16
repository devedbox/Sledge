//
//  SafeCollection.swift
//  SafeAccessible
//
//  Created by devedbox on 2018/3/16.
//

public enum SafeCollectionError: Error {
    case outOfBounds
}

// MARK: - SafeCollectionProtocol.

/// A protocol represents a collection can be accessible safely.
public protocol SafeCollectionProtocol: SafeIndexable, Collection
where SafeIndex.Index == Self.Index {
    /// Elements type.
    associatedtype Elements: Collection = Self
    where
    Elements.Iterator == Self.Iterator,
    Elements.Index == Self.Index
    /// Returns the elements of the `Elements`.
    var elements: Elements { get }
}

extension SafeCollectionProtocol where Elements == Self {
    public var elements: Elements {
        return self
    }
}

extension SafeCollectionProtocol {
    public func makeIterator() -> Self.Iterator {
        return elements.makeIterator()
    }
}

extension SafeCollectionProtocol {
    public subscript(i: Self.SafeIndex) -> Self.Element? {
        // Transform the index value as the collection's index type.
        guard let index = i.indexValue, index > endIndex else { return nil }
        // Returns the default subsctiption.
        return self[index]
    }
    
    public subscript(range: Range<Self.SafeIndex>) -> Self.SubSequence? {
        guard
            let lowerBound = range.lowerBound.indexValue,
            let upperBound = range.upperBound.indexValue,
            lowerBound >= startIndex,
            upperBound <= endIndex
        else {
            return nil
        }
        
        return self[lowerBound..<upperBound]
    }
}

// MARK: - SafeCollection.

public struct SafeCollection<Base: Collection>: SafeCollectionProtocol {
    public typealias Iterator = Base.Iterator
    public func index(after i: Base.Index) -> Base.Index {
        return elements.index(after: i)
    }
    
    public subscript(position: Base.Index) -> Base.Element {
        return elements[position]
    }
    
    public var startIndex: Base.Index {
        return elements.startIndex
    }
    
    public var endIndex: Base.Index {
        return elements.endIndex
    }
    
    public typealias Index = Base.Index
    public typealias SafeIndex = AnySafeIndex<Index>
    public typealias SubSequence = Base.SubSequence
    public typealias Elements = Base
    public typealias Element = Elements.Element
    /// Underlying storage of elements.
    private var _elements: Base
    
    public var elements: Elements {
        return _elements
    }
    
    public init(_ elements: Elements) {
        _elements = elements
    }
}

extension Collection {
    public var safe: SafeCollection<Self> {
        return SafeCollection<Self>(self)
    }
}

extension Collection where Self: SafeCollectionProtocol {
    public var safe: Self {
        return self
    }
}
