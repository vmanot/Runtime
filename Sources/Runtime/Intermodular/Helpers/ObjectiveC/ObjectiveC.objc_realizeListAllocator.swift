//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

func objc_realizeListAllocator<T: Wrapper, P: Pointer>(
    _ f: ((UnsafeMutablePointer<UInt32>?) -> P?)
) -> AnyRandomAccessCollection<T> where P.Pointee == T.Value {
    var count: UInt32 = 0
    let baseAddress = f(&count)
    
    return AutodeallocatingUnsafeBufferPointer(
        start: baseAddress,
        count: count,
        isAutodeallocating: true
    )
    ._map(T.init)
}

func objc_realizeListAllocator<T: Wrapper, P: Pointer>(
    _ f: ((UnsafeMutablePointer<UInt32>?) -> P?)
) -> AnyRandomAccessCollection<T> where P.Pointee == Optional<T.Value> {
    var count: UInt32 = 0
    let baseAddress = f(&count)
    
    return AutodeallocatingUnsafeBufferPointer(
        start: baseAddress,
        count: count,
        isAutodeallocating: true
    )
    .compact()
    ._map(T.init)
}

func objc_realizeListAllocator<T, U: Wrapper, P: Pointer>(
    _ f: ((T?, UnsafeMutablePointer<UInt32>?) -> P?),
    _ x: T?
) -> AnyRandomAccessCollection<U> where P.Pointee == U.Value {
    var count: UInt32 = 0
    let baseAddress = f(x, &count)
    
    return AutodeallocatingUnsafeBufferPointer(
        start: baseAddress,
        count: count,
        isAutodeallocating: true
    )
    ._map(U.init)
}

func objc_realizeListAllocator<T, U: Wrapper, P: Pointer>(
    _ f: ((T, UnsafeMutablePointer<UInt32>?) -> P?),
    _ x: T
) -> AnyRandomAccessCollection<U> where P.Pointee == U.Value {
    var count: UInt32 = 0
    let baseAddress = f(x, &count)
    
    return AutodeallocatingUnsafeBufferPointer(
        start: baseAddress,
        count: count,
        isAutodeallocating: true
    )
    ._map(U.init)
}

func objc_realizeListAllocator<T, U: Wrapper, P: Pointer>(
    _ f: ((T?, UnsafeMutablePointer<UInt32>?) -> P?),
    _ x: T?
) -> AnyRandomAccessCollection<U> where P.Pointee == Optional<U.Value> {
    var count: UInt32 = 0
    let baseAddress = f(x, &count)
    
    return AutodeallocatingUnsafeBufferPointer(
        start: baseAddress,
        count: count,
        isAutodeallocating: true
    )
    .compact()
    ._map(U.init)
}

func objc_realizeListAllocator<T, U: Wrapper, P: Pointer>(
    _ f: ((T, UnsafeMutablePointer<UInt32>?) -> P?),
    _ x: T
) -> AnyRandomAccessCollection<U> where P.Pointee == Optional<U.Value> {
    var count: UInt32 = 0
    let baseAddress = f(x, &count)
    
    return AutodeallocatingUnsafeBufferPointer(
        start: baseAddress,
        count: count,
        isAutodeallocating: true
    )
    .compact()
    ._map(U.init)
}
