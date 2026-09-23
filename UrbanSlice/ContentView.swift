//
//  ContentView.swift
//  UrbanSlice
//
//  Created by Yashh Sapra on 05/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    @State private var showingAddView = false
    
    let pizzas: [PizzaItem] = [
        PizzaItem(type: "Margherita", size: "Small", quantity: 1),
        PizzaItem(type: "Veggie Supreme", size: "Small", quantity: 1),
        PizzaItem(type: "Golden Corn", size: "Small", quantity: 1),
        PizzaItem(type: "Paneer Tikka", size: "Small", quantity: 1),
        PizzaItem(type: "Farmhouse", size: "Small", quantity: 1)
    ]
     
    var body: some View {
        NavigationStack{
            
            ScrollView{
                VStack(spacing: 20){
                    ForEach(pizzas){ pizza in
                        PizzaCard(pizza: pizza,order: $order)
                    }
                }
            }
            .navigationTitle("Urban Slice ")
            .toolbar{
                NavigationLink(destination: CartView(order: order)){
                    Image(systemName: "cart")
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

struct PizzaCard: View {
    let pizza: PizzaItem
    @Binding var order: Order
    
    @State private var showOptions = false
    @State private var selectedSize = "Small"
    @State private var extraCheese = false
    @State private var selectedToppings: Set<String> = []
    @State private var quantity: Int = 1
    
    let sizes = ["Small", "Medium", "Large"]
    let toppings = ["Mushroom", "Tomato", "Onion", "Jalapeno","Peperoni"]
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: pizzaImage(for: pizza.type)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
            } placeholder: {
                ProgressView().frame(width: 300, height: 180)
            }
            .allowsHitTesting(false)
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(pizza.type)
                        .font(.title3).bold()
                        .padding(.horizontal)
                    
                    Text("Starting at ₹\(pizza.cost, format: .number)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.vertical)
                }
                
                Spacer()
                
                Button {
                    showOptions = true
                } label: {
                    Text("Add +")
                        .font(.system(size: 20)).bold()
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(.green)
                        .foregroundColor(.white)
                        .clipShape(.capsule)
                }
                .padding(.horizontal, 20)
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(25)
        .shadow(radius: 30)
        .padding(.horizontal, 9)
        
        
        // MARK: - SHEET
        .sheet(isPresented: $showOptions) {
            VStack(spacing: 25) {
                
                Text("Customize Pizza")
                    .font(.title2).bold()
                    .padding(.top)
                
                // SIZE PICKER
                VStack(alignment: .leading) {
                    Text("Select Size")
                        .font(.headline)
                    
                    Picker("Size", selection: $selectedSize) {
                        ForEach(sizes, id: \.self) { s in
                            Text(s)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                
                // QUANTITY PICKER ⭐ NEW
                VStack(alignment: .leading) {
                    Text("Quantity")
                        .font(.headline)
                    
                    Stepper(value: $quantity, in: 1...10) {
                        Text("\(quantity)")
                            .font(.title3.bold())
                            .padding(.horizontal,27)
                    }
                }
                .padding(.horizontal)
                
                
                // EXTRA CHEESE
                Toggle("Extra Cheese (+₹50)", isOn: $extraCheese)
                    .padding(.horizontal)
                
                // TOPPINGS
                VStack(alignment: .leading) {
                    Text("Extra Toppings")
                        .font(.headline)
                    
                    ForEach(toppings, id: \.self) { topping in
                        Button(action: {
                            if selectedToppings.contains(topping) {
                                selectedToppings.remove(topping)
                            } else {
                                selectedToppings.insert(topping)
                            }
                        }) {
                            HStack {
                                Text(topping)
                                Spacer()
                                Image(systemName: selectedToppings.contains(topping) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedToppings.contains(topping) ? .green : .gray)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
                .padding(.horizontal)
                
                
                Spacer()
                
                // ADD TO CART BUTTON
                Button {
                    var customized = pizza
                    customized.size = selectedSize
                    customized.extraCheese = extraCheese
                    customized.toppings = Array(selectedToppings)
                    customized.quantity = quantity     // ⭐ NEW
                    
                    order.pizzas.append(customized)
                    showOptions = false
                } label: {
                    Text("Add to Cart")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .presentationDetents([.large])
        }
    }
    
    
    //IMAGE FUNCTION
    func pizzaImage(for type: String) -> URL? {
        switch type {
        case "Margherita": return URL(string: "https://www.dominos.co.in/files/items/Margherit.jpg")
        case "Veggie Supreme": return URL(string: "https://www.dominos.co.in/files/items/Peppy_Paneer.jpg")
        case "Golden Corn": return URL(string: "https://imgs.search.brave.com/nZNPC7bRx1ITYGvs8fBxpBh0gTNPEFR8HTSqQ2WlDhw/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/ZG9taW5vcy5jby5p/bi8vZmlsZXMvaXRl/bXMvQ29ybl8mX0No/ZWVzZS5qcGc")
        case "Paneer Tikka": return URL(string: "https://www.dominos.co.in/files/items/Paneer_Makhni.jpg")
        case "Farmhouse": return URL(string: "https://www.dominos.co.in/files/items/Farmhouse.jpg")
        default: return nil
        }
    }
}
#Preview {
    ContentView()
}
