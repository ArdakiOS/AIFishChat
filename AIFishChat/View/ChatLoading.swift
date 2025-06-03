//
//  ChatLoading.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 04.03.2025.
//

import SwiftUI

struct ChatLoading: View {
    @State private var id = 1
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 5) {
            ForEach(1...3, id: \.self) { circle in
                Circle().fill(Color.black)
                    .frame(width: 5)
                    .scaleEffect(circle == id ? 1.8 : 1)
                    .opacity(circle == id ? 1 : 0.5)
            }
        }
        .onReceive(timer) { _ in
            id = (id % 3) + 1 // Cycles between 1, 2, 3
        }
        .animation(.easeInOut(duration: 0.5), value: id)
    }
}


#Preview {
    ChatLoading()
}
