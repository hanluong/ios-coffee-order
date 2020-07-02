//
//  AddCoffeeOrderViewModel.swift
//  OrderCoffeeLabMVVM
//
//  Created by Han Luong on 1/16/20.
//  Copyright © 2020 Han Luong. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel {
    var name: String?
    var email: String?
    var selectedSize: String?
    var selectedType: String?
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
}
