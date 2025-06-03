//
//  ImgGenView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 23.02.2025.
//

import SwiftUI

struct ImgGenView: View {
    @ObservedObject var vm : MainViewModel
    @EnvironmentObject var langMan : LanguageManager
    @EnvironmentObject var subsMan : ApphudSubsManager
    @State var showPaywall = false
    @State var imgSaved = false
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            GeometryReader { geo in
                VStack(spacing: 20){
                    ZStack{
                        Rectangle()
                            .fill(Color(hex: "#F5F5F5"))
                            .frame(maxHeight: 201)
                            .blur(radius: vm.startGeneratingImg ? 5 : 0)
                        
                        if let img = vm.generatedUIImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 201)
                                .clipped()
                                .contentShape(Rectangle())
                                .blur(radius: CGFloat(vm.genProgress < 100 ? 10 - (10 * vm.genProgress / 100) : 0))
                               
                        }
                        
                        if vm.startGeneratingImg {
                            Text("\(Int(vm.genProgress))%")
                                .font(.custom(FontHelper.bold.name(), size: 74))
                                .foregroundStyle(.white)
                                
                        }
                    }
                    .frame(maxHeight: 201)
                    
                    TextField("", text: $vm.textToGenImg, prompt: Text("Enter the promt".localizedString(langMan.currentLanguage)).foregroundColor(Color(hex: "#D5D5D5")).font(.custom(FontHelper.reg.name(), size: 18)), axis: .vertical)
                        .lineLimit(12, reservesSpace: true)
                        .padding()
                    
                    Spacer()
                    if imgSaved {
                        SuccessPopUp(text: "Image saved")
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                    imgSaved = false
                                }
                            }
                    }
                    
                    if vm.genProgress < 100 {
                        Button{
                            if !subsMan.hasSubscription && vm.imgCount > 1{
                                showPaywall = true
                            } else {
                                if vm.imgCount == 1 {
                                    requestReview()
                                }
                                vm.genProgress = 0
                                vm.generatedImgUrl = nil
                                vm.startGeneratingImg = true
                                Task {
                                    await vm.genImage()
                                }
                                
                            }
                            vm.imgCount += 1
                        } label: {
                            if vm.startGeneratingImg{
                                HStack{
                                    Image(.loadingImg)
                                        .resizable()
                                        .frame(width: 19, height: 19)
                                        .rotationEffect(.degrees(360 * (vm.genProgress / 25)))
                                    Text("Loading..".localizedString(langMan.currentLanguage))
                                        .font(.custom(FontHelper.semi.name(), size: 15))
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#407CF3"))
                                .clipShape(RoundedRectangle(cornerRadius: 41))
                                .padding()
                            } else {
                                HStack{
                                    Text("Generate".localizedString(langMan.currentLanguage))
                                        .font(.custom(FontHelper.semi.name(), size: 15))
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#407CF3"))
                                .clipShape(RoundedRectangle(cornerRadius: 41))
                                .padding()
                            }
                            
                        }
                        .disabled(vm.startGeneratingImg)
                    }
                    else {
                        HStack{
                            Button{
                                guard let img = vm.generatedUIImage else {return}
                                saveImageToGallery(image: img)
                                imgSaved = true
                                
                            } label: {
                                Text("Save Image".localizedString(langMan.currentLanguage))
                                    .font(.custom(FontHelper.semi.name(), size: 15))
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "#407CF3"))
                                    .clipShape(RoundedRectangle(cornerRadius: 41))
                                
                            }
                            .disabled(vm.startGeneratingImg)
                            
                            Button{
                                
                                vm.genProgress = 0
                                vm.generatedImgUrl = nil
                                vm.textToGenImg = ""
                                vm.generatedUIImage = nil
                                
                            } label: {
                                Text("Cancel".localizedString(langMan.currentLanguage))
                                    .font(.custom(FontHelper.semi.name(), size: 15))
                                    .foregroundStyle(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "#F5F5F5"))
                                    .clipShape(RoundedRectangle(cornerRadius: 41))
                                
                            }
                            .disabled(vm.startGeneratingImg)
                        }
                        .padding()
                    }
                
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    UIApplication.shared.dismissKeyboard()
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear{
            vm.finishedGeneratingImg = false
        }
        .animation(.easeInOut(duration: 0.3), value: imgSaved)
        .animation(.easeInOut(duration: 0.3), value: vm.startGeneratingImg)
        .animation(.easeInOut(duration: 0.2), value: vm.genProgress)
        .sheet(isPresented: $showPaywall) {
            PayWallView()
                .presentationCornerRadius(10)
                .presentationDragIndicator(.hidden)
        }
    }
}

#Preview {
    NavView()
        .environmentObject(LanguageManager())
        .environmentObject(ApphudSubsManager())
}

func saveImageToGallery(image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
}


