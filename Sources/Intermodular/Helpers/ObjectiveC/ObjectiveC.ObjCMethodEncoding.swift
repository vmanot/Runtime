//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

public enum ObjCMethodEncoding: UnicodeScalar, _opaque_Hashable, Hashable {
    case constant = "r"
    case `in` = "n"
    case `inout` = "N"
    case out = "o"
    case byCopying = "O"
    case byReferencing = "R"
    case oneway = "V"
}
