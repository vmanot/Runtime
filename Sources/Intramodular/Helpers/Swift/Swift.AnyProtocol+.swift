//
// Copyright (c) Vatsal Manot
//

import Swallow

public func extend(_ type: Any.Type) -> AnyProtocol.Type {
    struct Extensions: AnyProtocol { }
    
    var extensions: AnyProtocol.Type = Extensions.self
    
    UnsafeMutablePointer<Any.Type>.to(assumingLayoutCompatible: &extensions).pointee = type
    
    return extensions
}

extension AnyProtocol {
    private static var t0: Self.Type {
        return <<infer>>
    }
}

extension AnyProtocol {
    public static func fmake<T>(with _: T.Type) -> AnyProtocol.Type {
        return extend(ftype((T, Self).self))
    }
    
    public static func fmake(withUnknown t1: AnyProtocol.Type) -> AnyProtocol.Type {
        return t1.fmake(with: t0)
    }
}

public func fmake(_ t1: Any.Type, _ t2: Any.Type) -> Any.Type {
    return extend(t1).fmake(withUnknown: extend(t2))
}

public func fmake(_ t1: TypeMetadata, _ t2: TypeMetadata) -> TypeMetadata.Function {
    return TypeMetadata.Function(fmake(t1.value, t2.value))!
}

extension AnyProtocol {
    public static func concatenate<T>(with _: T.Type) -> AnyProtocol.Type {
        return extend((T, Self).self)
    }
    
    public static func concatenate(withUnknown t1: AnyProtocol.Type) -> AnyProtocol.Type {
        return t1.concatenate(with: t0)
    }
}

public func concatenate(_ t1: Any.Type, _ t2: Any.Type) -> Any.Type {
    return extend(t1).concatenate(withUnknown: extend(t2))
}

public func concatenate(_ t1: TypeMetadata, _ t2: TypeMetadata) -> TypeMetadata {
    return .init(extend(t1.value).concatenate(withUnknown: extend(t2.value)))
}

extension AnyProtocol {
    public static func concatenate<T, U>(with _: T.Type, _: U.Type) -> AnyProtocol.Type {
        return extend((U, T, Self).self)
    }
    
    public static func concatenate<T>(with t1: T.Type, unknown t2: AnyProtocol.Type) -> AnyProtocol.Type {
        return t2.concatenate(with: t0, t1)
    }
    
    public static func concatenate(withUnknown t1: AnyProtocol.Type, _ t2: AnyProtocol.Type) -> AnyProtocol.Type {
        return t1.concatenate(with: t0, unknown: t2)
    }
}

public func concatenate(_ t1: Any.Type, _ t2: Any.Type, _ t3: Any.Type) -> Any.Type {
    return extend(t1).concatenate(withUnknown: extend(t2), extend(t3))
}

public func concatenate(_ t1: TypeMetadata, _ t2: TypeMetadata, _ t3: TypeMetadata) -> TypeMetadata {
    return .init(extend(t1.value).concatenate(withUnknown: extend(t2.value), extend(t3.value)))
}

extension AnyProtocol {
    public static func concatenate<T, U, V>(with t1: T.Type, _ t2: U.Type, _ t3: V.Type) -> AnyProtocol.Type {
        return extend((V, U, T, Self).self)
    }
    
    public static func concatenate<T, U>(with t1: T.Type, _ t2: U.Type, unknown t3: AnyProtocol.Type) -> AnyProtocol.Type {
        return t3.concatenate(with: t0, t1, t2)
    }
    
    public static func concatenate<T>(with t1: T.Type, unknown t2: AnyProtocol.Type, _ t3: AnyProtocol.Type) -> AnyProtocol.Type {
        return t2.concatenate(with: t0, t1, unknown: t3)
    }
    
    public static func concatenate(withUnknown t1: AnyProtocol.Type, _ t2: AnyProtocol.Type, _ t3: AnyProtocol.Type) -> AnyProtocol.Type {
        return t1.concatenate(with: t0, unknown: t2, t3)
    }
}

public func concatenate(_ t1: Any.Type, _ t2: Any.Type, _ t3: Any.Type, _ t4: Any.Type) -> Any.Type {
    return extend(t1).concatenate(withUnknown: extend(t2), extend(t3), extend(t4))
}

public func concatenate(_ t1: TypeMetadata, _ t2: TypeMetadata, _ t3: TypeMetadata, _ t4: TypeMetadata) -> TypeMetadata {
    return .init(extend(t1.value).concatenate(withUnknown: extend(t2.value), extend(t3.value), extend(t4.value)))
}

extension AnyProtocol {
    public static func concatenate<T, U, V, W>(with t1: T.Type, _ t2: U.Type, _ t3: V.Type, _ t4: W.Type) -> AnyProtocol.Type {
        return extend((W, V, U, T, Self).self)
    }
    
    public static func concatenate<T, U, V>(with t1: T.Type, _ t2: U.Type, _ t3: V.Type, unknown t4: AnyProtocol.Type) -> AnyProtocol.Type {
        return t4.concatenate(with: t0, t1, t2, t3)
    }
    
    public static func concatenate<T, U>(with t1: T.Type, _ t2: U.Type, unknown t3: AnyProtocol.Type, _ t4: AnyProtocol.Type) -> AnyProtocol.Type {
        return t3.concatenate(with: t0, t1, t2, unknown: t4)
    }
    
    public static func concatenate<T>(with t1: T.Type, unknown t2: AnyProtocol.Type, _ t3: AnyProtocol.Type, _ t4: AnyProtocol.Type) -> AnyProtocol.Type {
        return t2.concatenate(with: t0, t1, unknown: t3, t4)
    }
    
    public static func concatenate(withUnknown t1: AnyProtocol.Type, _ t2: AnyProtocol.Type, _ t3: AnyProtocol.Type, _ t4: AnyProtocol.Type) -> AnyProtocol.Type {
        return t1.concatenate(with: t0, unknown: t2, t3, t4)
    }
}

public func concatenate(_ t1: Any.Type, _ t2: Any.Type, _ t3: Any.Type, _ t4: Any.Type, _ t5: Any.Type) -> Any.Type {
    return extend(t1).concatenate(withUnknown: extend(t2), extend(t3), extend(t4), extend(t5))
}

public func concatenate(_ t1: TypeMetadata, _ t2: TypeMetadata, _ t3: TypeMetadata, _ t4: TypeMetadata, _ t5: TypeMetadata) -> TypeMetadata {
    return .init(extend(t1.value).concatenate(withUnknown: extend(t2.value), extend(t3.value), extend(t4.value), extend(t5.value)))
}

extension AnyProtocol {
    public static func concatenate<T, U, V, W, X>(with t1: T.Type, _ t2: U.Type, _ t3: V.Type, _ t4: W.Type, _ t5: X.Type) -> AnyProtocol.Type {
        return extend((X, W, V, U, T, Self).self)
    }
    
    public static func concatenate<T, U, V, W>(with t1: T.Type, _ t2: U.Type, _ t3: V.Type, _ t4: W.Type, unknown t5: AnyProtocol.Type) -> AnyProtocol.Type {
        return t5.concatenate(with: t0, t1, t2, t3, t4)
    }
    
    public static func concatenate<T, U, V>(with t1: T.Type, _ t2: U.Type, _ t3: V.Type, unknown t4: AnyProtocol.Type, _ t5: AnyProtocol.Type) -> AnyProtocol.Type {
        return t4.concatenate(with: t0, t1, t2, t3, unknown: t5)
    }
    
    public static func concatenate<T, U>(with t1: T.Type, _ t2: U.Type, unknown t3: AnyProtocol.Type, _ t4: AnyProtocol.Type, _ t5: AnyProtocol.Type) -> AnyProtocol.Type {
        return t3.concatenate(with: t0, t1, t2, unknown: t4, t5)
    }
    
    public static func concatenate<T>(with t1: T.Type, unknown t2: AnyProtocol.Type, _ t3: AnyProtocol.Type, _ t4: AnyProtocol.Type, _ t5: AnyProtocol.Type) -> AnyProtocol.Type {
        return t2.concatenate(with: t0, t1, unknown: t3, t4, t5)
    }
    
    public static func concatenate(withUnknown t1: AnyProtocol.Type, _ t2: AnyProtocol.Type, _ t3: AnyProtocol.Type, _ t4: AnyProtocol.Type, _ t5: AnyProtocol.Type) -> AnyProtocol.Type {
        return t1.concatenate(with: t0, unknown: t2, t3, t4, t5)
    }
}

public func concatenate(_ t1: Any.Type, _ t2: Any.Type, _ t3: Any.Type, _ t4: Any.Type, _ t5: Any.Type, _ t6: Any.Type) -> Any.Type {
    return extend(t1).concatenate(withUnknown: extend(t2), extend(t3), extend(t4), extend(t5), extend(t6))
}

public func concatenate(_ t1: TypeMetadata, _ t2: TypeMetadata, _ t3: TypeMetadata, _ t4: TypeMetadata, _ t5: TypeMetadata, _ t6: TypeMetadata) -> TypeMetadata {
    return .init(extend(t1.value).concatenate(withUnknown: extend(t2.value), extend(t3.value), extend(t4.value), extend(t5.value), extend(t6.value)))
}
