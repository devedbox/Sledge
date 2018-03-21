//
//  Generator.swift
//  Generator
//
//  Created by devedbox on 2018/3/21.
//

// MARK: - EmptyInitializable.

public protocol EmptyInitializable { init() }

// MARK: - GeneratorProtocol.

/// A protocol represents a generator to generate any associated `Result` instance using the
/// formers to form the result.
public protocol GeneratorProtocol: EmptyInitializable {
    /// The `Result` type of the generator.
    associatedtype Result: EmptyInitializable
    /// The former closure to form the result.
    typealias Former = (Result) -> Void
    /// Returns all the formers to form the initialized result instance.
    var formers: [Former] { get }
    /// Forms and adds the `Former` to `Result`.
    mutating func form(_ former: @escaping Former)
    /// Returns the initialized result of `Result` if any.
    func initialize() -> Result?
    /// Generate the instace of `Result`.
    func generate() -> Result
}

extension GeneratorProtocol {
    public func initialize() -> Result? {
        return Result.init() // swiftlint:disable:this explicit_init
    }
    
    public func generate() -> Result {
        let result = initialize() ?? Result.init() // swiftlint:disable:this explicit_init
        formers.forEach { $0(result) }
        return result
    }
}

/// Concrete generator of `GeneratorProtocol` by wrapping the `Base` type.
open class Generator<Base: EmptyInitializable>: GeneratorProtocol {
    /// Base type.
    public typealias Result = Base
    /// Formers as read-write property.
    public var formers: [Former]
    
    public func form(_ former: @escaping Former) {
        formers.append(former)
    }
    
    public convenience required init() {
        self.init(formers: [])
    }
    
    public init(formers: [Former] = []) {
        self.formers = formers
    }
}

// MARK: Operator.

/// Infix operator to add a former to a view generator.
infix operator +=>: AdditionPrecedence

extension GeneratorProtocol {
    /// Form the right handler to the left handler by calling the `form(:)` of the left `ViewGenerator` type.
    ///
    /// - Parameter left: The left handler of `ViewGeneratorProtocol` to be formed.
    /// - Parameter right: The former to be added to the view generator.
    ///
    /// - Returns: The new generator with the former added.
    @discardableResult
    public static func +=> (left: Self, right: @escaping Former) -> Self {
        var gen = left
        gen.form(right)
        return gen
    }
    /// Form the right handlers to the left handler by calling the `form(:)` of the left `ViewGenerator` type
    /// one at a time repeatly.
    ///
    /// - Parameter left: The left handler of `ViewGeneratorProtocol` to be formed.
    /// - Parameter rights: The formers to be added to the view generator.
    ///
    /// - Returns: The new generator with the formers added.
    @discardableResult
    public static func +=> (left: Self, rights: [Former]) -> Self {
        var gen = left
        rights.forEach { gen.form($0) }
        return gen
    }
}

// MARK: - Generic.

/// A type configuring the given parameter.
public typealias Configuration<T> = (T) -> Void
/// A type configuring the given parameter and returns a new result after the configuration.
public typealias ReConfiguration<T> = (inout T) -> Void
/// Generate an instance of the given `G.View` type using the generator and configure the view via the
/// configuration closure if needed.
///
/// - Parameter t: The type of the ui element to be created.
/// - Parameter generator: The generator related withe the ui element type.
/// - Parameter configuration: A closure of `Configuration<G.View>` to handle the view after creating
///                            and forming by the generator.
///
/// - Returns: An instance of `G.View`.
public func generate<G: GeneratorProtocol>(_ t: G.Result.Type,
                                           using generator: G,
                                           configuration: Configuration<G.Result>? = nil) -> G.Result {
    let result = generator.initialize() ?? t.init()
    generator.formers.forEach { $0(result) }
    configuration?(result)
    return result
}
/// Generate an instance of the given `G.View` by using the default generator of `G` to form the instance
/// of the ui element type.
///
/// - Parameter g: The given type `G` of generator.
/// - Parameter forming: An closure of `ReConfiguration<G>` to handle the generator after the default instance
///                      created and returns a new generator with formed info.
///
/// - Returns: An instance of `G.View`.
public func generate<G: GeneratorProtocol>(via g: G.Type, forming: ReConfiguration<G>? = nil) -> G.Result {
    var generator = g.init()
    forming?(&generator)
    return generate(G.Result.self, using: generator)
}
