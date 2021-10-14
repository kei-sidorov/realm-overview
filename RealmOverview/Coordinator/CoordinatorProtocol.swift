//
//  CoordinatorProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 07.10.2021.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    
    func start()
}
