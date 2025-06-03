//
//  AnimatedLogo.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 17.03.2025.
//

import SwiftUI

struct AnimatedLogo: View {
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    let circleRadius : CGFloat
    let totalWidth : CGFloat
    let totalHeight : CGFloat
    @State var isBlueTop = false
    var body: some View {
        ZStack{
            Circle()
                .fill(Color(hex: "#407CF3").opacity(0.2))
                .frame(width: circleRadius, height: circleRadius)
                .frame(maxWidth: totalWidth, maxHeight: totalHeight, alignment: !isBlueTop ? .topTrailing : .bottomLeading)
            Circle().fill(Color(hex: "#407CF3"))
                .frame(width: circleRadius, height: circleRadius)
                .frame(maxWidth: totalWidth, maxHeight: totalHeight, alignment: isBlueTop ? .topTrailing : .bottomLeading)
        }
        .onAppear{
            isBlueTop.toggle()
        }
        .animation(.easeInOut(duration: 1), value: isBlueTop)
        .onReceive(timer) { _ in
            isBlueTop.toggle()
        }
    }
}

#Preview {
    AnimatedLogo(circleRadius: 76, totalWidth: 102, totalHeight: 97)
}
