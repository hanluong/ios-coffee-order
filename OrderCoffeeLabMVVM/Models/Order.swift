//
//  Order.swift
//  OrderCoffeeLabMVVM
//
//  Created by Han Luong on 1/14/20.
//  Copyright © 2020 Han Luong. All rights reserved.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espresso
    case cortado
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}

extension Order {
    static var all: Resource<[Order]> = {
        let url = URL(string: "https://morning-eyrie-68114.herokuapp.com/api/orders")!
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        let url = URL(string: "https://morning-eyrie-68114.herokuapp.com/api/orders")!
        let order = Order(vm)
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("ERROR! encoding order!")
        }
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = data
        
        return resource
    }
}

extension Order {
    init?(_ vm: AddCoffeeOrderViewModel) {
        guard let name = vm.name,
            let email = vm.email,
            let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
            let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else { return nil }
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
}
