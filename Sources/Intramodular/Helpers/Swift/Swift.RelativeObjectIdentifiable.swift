//
// Copyright (c) Vatsal Manot
//

import Swallow

/// A protocol facilitating voluntary inter-object dependency tracking.
public protocol RelativeObjectIdentifiable: class {
    var relativeObjectIdentity: RelativeObjectIdentity { get }
}

public class RelativeObjectIdentity: Hashable {
    private let ownSelf: RelativeObjectIdentifiable
    private lazy var parents = ObjectSet<Unowned<AnyObject>>()
    private lazy var children = ObjectSet<Unowned<AnyObject>>()
    
    public init(_ ownSelf: RelativeObjectIdentifiable) {
        self.ownSelf = ownSelf
    }
    
    private func insert(parent: RelativeObjectIdentifiable)  {
        parents.insert(parent)
        parent.relativeObjectIdentity.insert(child: ownSelf)
    }
    
    public func insert(child: RelativeObjectIdentifiable)  {
        children.insert(child)
        child.relativeObjectIdentity.insert(parent: ownSelf)
    }
    
    private func remove(parent: RelativeObjectIdentifiable) {
        parents.remove(parent)
        parent.relativeObjectIdentity.remove(child: ownSelf)
    }
    
    public func remove(child: RelativeObjectIdentifiable) {
        children.remove(child)
        child.relativeObjectIdentity.remove(parent: ownSelf)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(parents)
        hasher.combine(children)
    }
}
