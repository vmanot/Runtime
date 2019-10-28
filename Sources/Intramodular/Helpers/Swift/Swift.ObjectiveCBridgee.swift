//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol ObjectiveCBridgee {
    associatedtype SwiftType: _ObjectiveCBridgeable where SwiftType._ObjectiveCType == Self
}
