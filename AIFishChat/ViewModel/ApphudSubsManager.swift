import SwiftUI
import ApphudSDK
import StoreKit

enum ApphudPaywallIds : String {
    case onb = "onb_paywall"
    case inapp = "inapp_paywall"
}

struct AppHudProductSkProduct : Hashable{
    let skProduct : Product
    let appHudProduct : ApphudProduct
}

@MainActor
class ApphudSubsManager : ObservableObject {
    
    @Published var currentActivePayWall : ApphudPaywall?
    
    @Published var selectedAppHudProduct: ApphudProduct?
    @Published var highlightedProdcut : Product?
    @Published var isLoading: Bool = true
    
    @Published var products : [AppHudProductSkProduct] = []
    @Published var apphudProducts : [ApphudProduct] = [] {
        didSet{
            Task{
                await convertAppHudProductToSkProducts()
            }
        }
    }
    
    @Published var hasSubscription = false
    @AppStorage("didOnb") var didOnb = false
    
    init() {
        hasSubscription = Apphud.hasActiveSubscription()
        getPayWallProducts(id: ApphudPaywallIds.inapp.rawValue)
        print("hasSubscription \(hasSubscription)")
    }
    
    @MainActor
    func getPayWallProducts(id : String) {
        products = []
        Apphud.paywallsDidLoadCallback { paywalls, _  in
            // if paywalls are already loaded, callback will be invoked immediately
            if let paywall = paywalls.first(where: { $0.identifier == id }) {
                self.apphudProducts = paywall.products
                Apphud.paywallShown(paywall)
                self.currentActivePayWall = paywall
                // setup your UI with these products
            }
        }
    }
    
    func dismissPayWall() {
        if let paywall = currentActivePayWall {
            Apphud.paywallClosed(paywall)
        }
    }
    
    @MainActor
    func convertAppHudProductToSkProducts() async {
        for i in apphudProducts {
            if let skProd = try? await i.product() {
                let newEntry = AppHudProductSkProduct(skProduct: skProd, appHudProduct: i)
                self.products.append(newEntry)
            }
        }
        self.products.sorted(by: {$0.skProduct.displayPrice < $1.skProduct.displayPrice})
    }
    
    @MainActor
    func makePruchase() async {
        guard let product = selectedAppHudProduct else {return}
        Apphud.purchase(product) { result in
           if let subscription = result.subscription, subscription.isActive(){
               self.hasSubscription = true
           }
        }
    }
    
    @MainActor
    func restorePurchase() async {
        Apphud.restorePurchases{ subscriptions, purchases, error in
           if Apphud.hasActiveSubscription(){
               self.hasSubscription = true
           }
        }
    }
    
    @MainActor
    func getRemainingTimeOfSub() -> Date? {
        if let subscription = Apphud.subscriptions()?.first(where: { $0.isActive() }) {
            return subscription.expiresDate
        }
        return nil
    }
}
