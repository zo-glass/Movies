//
//  Movies, Observable.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass, thanks to iOSAcademy
//
        

import Foundation

// MARK: - Observable

class Observable<T> {
    var data: T? {
        didSet {
            listeners.forEach {
                $0(data)
            }
        }
    }
    
    private var listeners: [(T?) -> Void] = []
    
    // MARK: - init
    
    init(_ data: T?) {
        self.data = data
    }
    
    // MARK: - Methods
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(data)
        self.listeners.append(listener)
    }
}

