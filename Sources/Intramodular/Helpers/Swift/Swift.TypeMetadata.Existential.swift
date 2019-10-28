//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct Existential: SwiftRuntimeTypeMetadataWrapper {
        typealias TypeMetadata = SwiftRuntimeProtocolMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard TypeMetadata(value).kind == .existential else {
                return nil
            }
            
            self.value = value
        }
        
        public var mangledName: String {
            return metadata.mangledName()
        }
    }
}

/*extension AnyExistentialType {
    public var constituents: UnsafeBufferPointer<AnyExistentialType.Descriptor> {
        return .init(start: valueAsNativeWordPointer.advanced(by: 3).assumingMemoryBound(to: <<infer>>), count: rawValue.constituentCount)
    }
}

extension AnyExistentialType {
    public struct UnderlyingStructure {
        public let kind: TypeMetadata.Kind.RawValue
        public let layoutFlags: LayoutFlags
        public let constituentCount: Int
    }
}

extension AnyExistentialType.UnderlyingStructure {
    public struct LayoutFlags: CustomStringConvertible, NativeWordSized, Wrapper {
        public typealias Value = NativeWord
        
        public let value: Value
        
        public var numberOfWitnessTables: Int {
            return value.applyingOnSelf({ $0.byteTuple.value.7.bitPattern.7 = 0 })
        }
        
        public var isClassConstrained: Bool {
            return .init(value.byteTuple.value.7.bitPattern.7)
        }
        
        public var description: String {
            return "(numberOfWitnessTables: \(numberOfWitnessTables), isClassConstrained: \(isClassConstrained))"
        }
    }
}*/
