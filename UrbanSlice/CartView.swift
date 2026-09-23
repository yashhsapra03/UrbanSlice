import SwiftUI

struct CartView: View {
    @Bindable var order: Order
    
    @State private var placingOrder = false
    @State private var showSuccessAlert = false
    
    @State private var paymentMethod = "COD"       // ⭐ Picker selection
    @State private var upiID = ""                  // ⭐ For UPI input
    
    let paymentOptions = ["COD", "UPI", "Card"]
    
    var total: Decimal {
        order.pizzas.reduce(0) { $0 + $1.cost }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    // ORDER ITEMS
                    ForEach(order.pizzas) { pizza in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(pizza.type) (\(pizza.size)) × \(pizza.quantity)")
                                .font(.headline)
                            
                            if pizza.extraCheese {
                                Text("Extra Cheese")
                                    .foregroundColor(.orange)
                            }
                            
                            if !pizza.toppings.isEmpty {
                                Text("Toppings: \(pizza.toppings.joined(separator: ", "))")
                                    .foregroundColor(.purple)
                            }
                            
                            Text("₹\(pizza.cost, format: .number)")
                                .foregroundColor(.green)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.ultraThinMaterial)
                    )
                    
                    
                    // TOTAL SECTION
                    Section {
                        Text("Total: \(total, format: .number)")
                            .font(.title3.bold())
                      }
                
                    
                    
                    // PAYMENT METHOD SECTION
                    Section("Payment Method") {
                        Picker("Select Payment", selection: $paymentMethod) {
                            ForEach(paymentOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        
                        // ⭐ Conditional UPI Input
                        if paymentMethod == "UPI" {
                            TextField("Enter UPI ID (example@upi)", text: $upiID)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(8)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background {
                    ZStack {
                        Image("pizzaPattern")
                            .resizable()
                            .scaledToFill()
                            .opacity(0.35)
                            .ignoresSafeArea()
                        
                        Color.white.opacity(0.1).ignoresSafeArea()
                    }
                }
                
                
                // PLACE ORDER BUTTON
                Button(action: placeOrder) {
                    HStack {
                        
                        Text("Place Order")
                            .bold()
                        if placingOrder {
                            ProgressView().tint(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .disabled(order.pizzas.isEmpty || (paymentMethod == "UPI" && upiID.isEmpty))
            }
            .navigationTitle("Your Cart 🍕")
            .alert("Order Placed!", isPresented: $showSuccessAlert) {
                Button("OK") {}
            } message: {
                
                    Text("Payment Method: \(paymentMethod)\n Your pizza is on the way! 😋")
                
            }
        }
    }
    
    
    func placeOrder() {
        placingOrder = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            placingOrder = false
            showSuccessAlert = true
            order.pizzas.removeAll()
        }
    }
}

#Preview {
    CartView(order: Order())
}
