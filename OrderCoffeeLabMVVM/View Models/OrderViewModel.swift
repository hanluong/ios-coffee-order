//
//  OrderViewModel.swift
//  OrderCoffeeLabMVVM
//
//  Created by Han Luong on 1/15/20.
//  Copyright © 2020 Han Luong. All rights reserved.
//

import Foundation

class OrderListViewModel {
    var orderListViewModel: [OrderViewModel]
    
    init() {
        self.orderListViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    func orderViewModel(at index: Int) -> OrderViewModel {
        return self.orderListViewModel[index]
    }
}

struct OrderViewModel {
    let order: Order
    
    var name: String {
        return self.order.name
    }
    
    var email: String {
        return self.order.email
    }
    
    var type: String {
        return self.order.type.rawValue.capitalized
    }
    
    var size: String {
        return self.order.size.rawValue.capitalized
    }
    
}
