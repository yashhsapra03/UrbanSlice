//
//  Order.swift
//  UrbanSlice
//
//  Created by Yashh Sapra on 05/11/25.
//

import Foundation

@Observable
class Order: Codable{
    var pizzas: [PizzaItem] = []
}

struct PizzaItem: Identifiable, Codable {
    var id = UUID()
    var toppings: [String] = []
    
    var type: String
    var size: String
    var quantity: Int
    var extraCheese = false
    
    static let availableFlavours = ["Margherita","Veggie Supreme","Golden Corn","Paneer Tikka","Farmhouse"]
    static let availableSizes = ["Small","Medium","Large"]
    
    var cost: Decimal {
        var basePrice: Decimal = 0
        
        switch type {
        case "Margherita": basePrice = 199
        case "Veggie Supreme": basePrice = 229
        case "Golden Corn": basePrice = 249
        case "Paneer Tikka": basePrice = 299
        case "Farmhouse": basePrice = 349
        default: break
        }
        
        switch size {
        case "Small": basePrice += 0
        case "Medium": basePrice += 50
        case "Large": basePrice += 100
        default: break
        }
        
        var total = basePrice * Decimal(quantity)
        if extraCheese { total += 50 * Decimal(quantity) }
        return total
    }
}
