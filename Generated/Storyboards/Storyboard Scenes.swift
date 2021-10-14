// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Basket: StoryboardType {
    internal static let storyboardName = "Basket"

    internal static let initialScene = InitialSceneType<RealmOverview.BasketViewController>(storyboard: Basket.self)

    internal static let basketViewController = SceneType<RealmOverview.BasketViewController>(storyboard: Basket.self, identifier: "BasketViewController")
  }
  internal enum DetailProduct: StoryboardType {
    internal static let storyboardName = "DetailProduct"

    internal static let detailProductViewController = SceneType<RealmOverview.DetailProductViewController>(storyboard: DetailProduct.self, identifier: "DetailProductViewController")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum OrderList: StoryboardType {
    internal static let storyboardName = "OrderList"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: OrderList.self)

    internal static let orderListViewController = SceneType<RealmOverview.OrderListViewController>(storyboard: OrderList.self, identifier: "OrderListViewController")
  }
  internal enum ProductsList: StoryboardType {
    internal static let storyboardName = "ProductsList"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: ProductsList.self)

    internal static let productsListViewController = SceneType<RealmOverview.ProductsListViewController>(storyboard: ProductsList.self, identifier: "ProductsListViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
