//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct Tuple: SwiftRuntimeTypeMetadataWrapper {
        typealias TypeMetadata = SwiftRuntimeTupleMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard TypeMetadata(value).kind == .tuple else {
                return nil
            }
            
            self.value = value
        }
        
        public var fields: [NominalTypeMetadata.Field] {
            return zip(metadata.labels(), metadata.elementLayouts()).map { name, layout in
                .init(
                    name: name,
                    type: .init(layout.type),
                    offset: layout.offset
                )
            }
        }
    }
}

// MARK: - Helpers - 

extension TypeMetadata {
    public init<C: Collection>(tupleWithTypes types: C) where C.Element == TypeMetadata {
        switch types.count {
            case 0:
                self = .init(Void.self)
            case 1:
                self = types[atDistance: 0]
            case 2:
                self = Runtime.concatenate(types[atDistance: 0], types[atDistance: 1])
            case 3:
                self = Runtime.concatenate(types[atDistance: 0], types[atDistance: 1], types[atDistance: 2])
            case 4:
                self = Runtime.concatenate(types[atDistance: 0], types[atDistance: 1], types[atDistance: 2], types[atDistance: 3])
            case 5:
                self = Runtime.concatenate(types[atDistance: 0], types[atDistance: 1], types[atDistance: 2], types[atDistance: 3], types[atDistance: 4])
            case 6:
                self = Runtime.concatenate(types[atDistance: 0], types[atDistance: 1], types[atDistance: 2], types[atDistance: 3], types[atDistance: 4], types[atDistance: 5])

            default:
                self = types.fauxRandomAccessView.reduce({ .init(Runtime.concatenate($0.value, $1.value)) }).forceUnwrap() // ugly workaround
        }
    }
    
    public init<C: Collection>(tupleWithTypes types: C) where C.Element == Any.Type {
        self.init(tupleWithTypes: types.lazy.map({ TypeMetadata($0) }))
    }
}
