//
//  AnyRouter.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 09.10.2021.
//

final class AnyRouter<Event>: RouterType {
    private let routeEvent: (Event) -> Void

    init<C>(_ coordinator: C) where C: RouterType, C.Event == Event {
        self.routeEvent = coordinator.route(event:)
    }

    init(play: @escaping (Event) -> Void) {
        self.routeEvent = play
    }

    func route(event: Event) {
        routeEvent(event)
    }
}

extension RouterType {
    func asRouter() -> AnyRouter<Event> {
        return .init(self)
    }
}
