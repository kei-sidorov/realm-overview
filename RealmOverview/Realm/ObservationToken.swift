//
//  ObservationToken.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 20.08.2021.
//

import RealmSwift

protocol ObservationToken {
    func invalidate()
}

extension NotificationToken: ObservationToken {}
