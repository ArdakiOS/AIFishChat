//
//  LoadingView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import SwiftUI

struct LoadingView: View {
    @Binding var progress : Double
    let timer = Timer.publish(every: 0.9, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                Spacer()
                AnimatedLogo(circleRadius: 76, totalWidth: 102, totalHeight: 97)
                
                Spacer()
                
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 100).fill(Color(hex: "#F3F3F3"))
                        .frame(width: 146, height: 6)
                    
                    RoundedRectangle(cornerRadius: 100).fill(Color(hex: "#407CF3"))
                        .frame(width: 146 * progress, height: 6)
                }
                
            }
            .padding(.bottom, 5)
        }
        .onReceive(timer) { _ in
            if progress < 1.0{
                progress += 0.99
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                    self.progress += 0.01
                }
            }
        }
    }
}

#Preview {
    LoadingView(progress: .constant(0.5))
}
