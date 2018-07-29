//
//  Queue.swift
//  GO
//
//  Created by Edward Huang on 5/23/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

fileprivate struct LinkedList<T>: CustomStringConvertible {
    private var head: Node<T>?
    private var tail: Node<T>?
    
    public init() { }
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node<T>? {
        return head
    }
    
    public mutating func append(_ value: T) {
        let newNode = Node(value: value)
        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
    }
    
    public mutating func remove(_ node: Node<T>) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev
        
        if next == nil {
            tail = prev
        }
        
        node.previous = nil
        node.next = nil
        
        return node.value
    }
    
    public var description: String {
        var text = "["
        var node = head
        
        while node != nil {
            text += "\(node!.value)"
            node = node!.next
            if node != nil { text += ", " }
        }
        return text + "]"
    }
}

fileprivate class Node<T> {
    public var value: T
    public var next: Node<T>?
    public var previous: Node<T>?
    
    public init(value: T) {
        self.value = value
    }
}

public struct Queue<T> {
    
    // 2
    fileprivate var list = LinkedList<T>()
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    // 3
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    // 4
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        
        _ = list.remove(element)
        
        return element.value
    }
    
    // 5
    public func peek() -> T? {
        return list.first?.value
    }
}


