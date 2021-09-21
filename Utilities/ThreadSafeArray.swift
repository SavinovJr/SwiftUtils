//
//  ThreadSafeArray.swift
//  SwiftUtils
//
//  Created by Anton Savinov on 20/12/2018.
//  Copyright © 2018 Anton Savinov. All rights reserved.
//

import Foundation

final class ThreadSafeArray<T> {
    private var array = [T]()
    private let queue = DispatchQueue(label: "ThreadSafeArrayQueue", attributes: .concurrent)

    public func append(_ value: T) {
        queue.async(flags: .barrier) {
            self.array.append(value)
        }
    }

    public func append(_ values: [T]) {
        queue.async(flags: .barrier) {
            self.array.append(contentsOf: values)
        }
    }

    public var values: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }

    public func removeValueAt(_ index: Int) {
        queue.async(flags: .barrier) {
            self.array.remove(at: index)
        }
    }

    public func clear() {
        queue.async(flags: .barrier) {
            self.array.removeAll()
        }
    }
}
