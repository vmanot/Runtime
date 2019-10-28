//
// Copyright (c) Vatsal Manot
//

import Swallow

// MARK: - Extensions -

extension NominalTypeMetadata.Field {
    public init(objCInstanceVariable: ObjCInstanceVariable) {
        self.name = objCInstanceVariable.name
        self.type = .init(objCInstanceVariable.typeEncoding.toMetatype())
        self.offset = objCInstanceVariable.offset
    }
}

// MARK: - Protocol Implementations -

extension NominalTypeMetadata.Field: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(offset)
    }
}

// MARK: - Helpers -

struct PropertyInfoContext {
    let name: String
    let type: Any.Type
}

extension Array where Element == NominalTypeMetadata.Field {
    public init(type: Any.Type, withFieldOffsets fieldOffsets: [Int])  {
        TODO.unimplemented

        /*
        self = (0..<fieldOffsets.count).map { index in
            let offset = fieldOffsets[index]
            var context = PropertyInfoContext(name: "", type: Any.self)
            let pointer = unsafeBitCast(type, to: UnsafeRawPointer.self)
            
            swift_getFieldAt(pointer, UInt32(index), { name, type, ctx in
                guard let name = name, let ctx = ctx else {
                    fatalError("name and ctx should not be nil")
                }
                let infoContext = ctx.assumingMemoryBound(to: PropertyInfoContext.self)
                infoContext.pointee = PropertyInfoContext(
                    name: String(cString: name),
                    type: unsafeBitCast(type, to: Any.Type.self)
                )
            }, &context)
            
            return NominalTypeMetadata.Field(name: context.name, type: .init(context.type), offset: offset)
        }*/
    }
}
