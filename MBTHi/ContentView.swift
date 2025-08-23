//
//  ContentView.swift
//  MBTHi
//
//  Created by 배현진 on 8/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var stocks: [Stock]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(stocks) { stock in
                    NavigationLink {
                        Text("Stock at \(stock.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(stock.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteStocks)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addStock) {
                        Label("Add Stock", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an stock")
        }
    }

    private func addStock() {
        withAnimation {
            let newStock = Stock(timestamp: Date())
            modelContext.insert(newStock)
        }
    }

    private func deleteStocks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(stocks[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Stock.self, inMemory: true)
}
