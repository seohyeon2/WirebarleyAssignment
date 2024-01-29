//
//  SendDataDelegate.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

protocol SendDataDelegate: AnyObject {
    func sendData<T>(
        _ data: T
    )
}
