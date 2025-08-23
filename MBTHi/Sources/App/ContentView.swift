//
//  ContentView.swift
//  MBTHi
//
//  Created by 배현진 on 8/23/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        TabView {
            OCRView()
                .tabItem {
                    Image(systemName: "doc.text.viewfinder")
                    Text("OCR")
                }
            
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("채팅")
                }
            
            InformationExtractionView()
                .tabItem {
                    Image(systemName: "doc.badge.gearshape")
                    Text("정보추출")
                }
        }
    }
}

#Preview {
    ContentView()
}
