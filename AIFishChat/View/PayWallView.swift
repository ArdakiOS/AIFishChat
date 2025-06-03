//
//  SettingsView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 23.02.2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                HStack(alignment: .top){
                    Circle()
                        .frame(width: 26, height: 26)
                        .opacity(0)
                    Spacer()
                    Image(.logo)
                        .resizable()
                        .frame(width: 113, height: 113)
                    Spacer()
                    Button{
                        
                    }label: {
                        Image(systemName: "xmark").resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(width: 26, height: 26)
                            .background(Color(hex: "#B5B5B5").opacity(0.48))
                            .clipShape(Circle())
                    }
                }
                
                
            }
            .padding(20)
        }
    }
}

#Preview {
    SettingsView()
}
