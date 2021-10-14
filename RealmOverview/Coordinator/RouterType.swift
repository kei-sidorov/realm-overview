//
//  RouterType.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 09.10.2021.
//

protocol RouterType {
    associatedtype Event

    func route(event: Event)
}
