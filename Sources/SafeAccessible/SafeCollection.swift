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
  
  init(_ elements: Elements)
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
  public var startIndex: Self.Index {
    return elements.startIndex
  }
  
  public var endIndex: Self.Index {
    return elements.endIndex
  }
  
  public func index(after i: Self.Index) -> Self.Index {
    return elements.index(after: i)
  }
  
  public subscript(position: Self.Index) -> Self.Element {
    return elements[position]
  }
}

extension SafeCollectionProtocol {
  public subscript(i: Self.SafeIndex) -> Self.Element? {
    // Transform the index value as the collection's index type.
    guard let index = i.indexValue, _isSafe(index: index) else {
      return nil
    }
    // Returns the default subsctiption.
    return self[index]
  }
  
  public subscript(range: Range<Self.SafeIndex>) -> Self.SubSequence? {
    guard
      let lowerBound = range.lowerBound.indexValue,
      let upperBound = range.upperBound.indexValue,
      _isSafe(bounds: lowerBound..<upperBound)
      else {
        return nil
    }
    
    return self[lowerBound..<upperBound]
  }
}

extension SafeCollectionProtocol {
  /// Returns true if the index is in the range from start index to end index.
  private func _isSafe(index i: Self.Index) -> Bool {
    return i >= startIndex && i < endIndex
  }
  /// Returns true if the bounds if in the range from start index to end index.
  private func _isSafe(bounds: Range<Self.Index>) -> Bool {
    let lowerBound = bounds.lowerBound
    let upperBound = bounds.upperBound
    guard
      _isSafe(index: lowerBound),
      _isSafe(index: upperBound)
      else {
        return false
    }
    
    return lowerBound >= startIndex && upperBound < endIndex
  }
}

extension Collection {
  public init<T: SafeCollectionProtocol>(_ safe: T) where Self == T.Elements {
    self = safe.elements
  }
}

// MARK: - SafeCollection.

public struct SafeCollection<Base: Collection>: SafeCollectionProtocol {
  public typealias Iterator = Base.Iterator
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
/// Forward implementations to the base collection, to pick up any
/// optimizations it might implement.
extension SafeCollection {
  public func prefix(upTo end: Index) -> SubSequence {
    return elements.prefix(upTo: end)
  }
  
  public func suffix(from start: Index) -> SubSequence {
    return elements.suffix(from: start)
  }
  
  public var isEmpty: Bool {
    return elements.isEmpty
  }
}

// MARK: - SafeRangeReplcableCollection.

public struct SafeRangeReplaceableCollection<Base: RangeReplaceableCollection>: SafeCollectionProtocol {
  public typealias Iterator = Base.Iterator
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

extension SafeRangeReplaceableCollection {
  public init() {
    _elements = Base.init()
  }
  
  public mutating func replaceSubrange<C>(_ subrange: Range<Index>, with newElements: C) where C : Collection, Element == C.Element {
    _elements.replaceSubrange(subrange, with: newElements)
  }
}

extension RangeReplaceableCollection {
  public var safe: SafeRangeReplaceableCollection<Self> {
    return SafeRangeReplaceableCollection<Self>(self)
  }
}

extension RangeReplaceableCollection where Self: SafeCollectionProtocol {
  public var safe: Self {
    return self
  }
}
/// Forward implementations to the base collection, to pick up any
/// optimizations it might implement.
extension SafeRangeReplaceableCollection {
  public func prefix(upTo end: Index) -> SubSequence {
    return elements.prefix(upTo: end)
  }
  
  public func suffix(from start: Index) -> SubSequence {
    return elements.suffix(from: start)
  }
  
  public var isEmpty: Bool {
    return elements.isEmpty
  }
  
  @discardableResult
  public mutating func removeFirst() -> Element? {
    guard !isEmpty else {
      return nil
    }
    return _elements.removeFirst()
  }
}
