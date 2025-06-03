//
//  TextChatView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import SwiftUI
import PhotosUI

struct TextChatView: View {
    @ObservedObject var vm : MainViewModel
    @State var showMoreTools = false
    @State var tempText = ""
    @State var tempImg : UIImage?
    @EnvironmentObject var langMan : LanguageManager
    @EnvironmentObject var subsMan : ApphudSubsManager
    @State var showPaywall = false
    @State var showPicker = false
    
    @State var useCamera = false
    @State var textCopied = false
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack(spacing: 15){
                VStack{
                    if vm.chatMsgs.isEmpty {
                        Spacer()
                        AnimatedLogo(circleRadius: 56, totalWidth: 78, totalHeight: 72)
                        Text("Hello, i’m Deep Search AI".localizedString(langMan.currentLanguage))
                            .font(.custom(FontHelper.semi.name(), size: 19))
                            .foregroundStyle(.black)
                        Text("How can I help you today?".localizedString(langMan.currentLanguage))
                            .font(.custom(FontHelper
                                .med.name(), size: 15))
                            .foregroundStyle(Color(hex: "#A4A4A4"))
                        
                        Spacer()
                    }
                    else {
                        ScrollView(.vertical) {
                            ScrollViewReader { proxy in
                                VStack(spacing: 20) {
                                    ForEach(vm.chatMsgs, id: \.self) { msg in
                                        DisplayMessageView(text: msg, textCopied: $textCopied)
                                            .frame(maxWidth: .infinity, alignment: msg.isIncoming ? .leading : .trailing)
                                            .id(msg.id) // Ensure each message has a unique ID
                                    }
                                    
                                    if vm.waitingForChat {
                                        ChatLoading()
                                            .padding(.leading, 5)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    if vm.chatEncounteredError {
                                        Text("Something went wrong, please try again")
                                            .font(.custom(FontHelper.reg.name(), size: 16))
                                            .foregroundStyle(.black)
                                    }
                                }
                                .onChange(of: vm.chatMsgs) { _ in
                                    if let lastMsg = vm.chatMsgs.last {
                                        withAnimation {
                                            proxy.scrollTo(lastMsg.id, anchor: .bottom)
                                        }
                                    }
                                }
                            }
                        }
                        
                        .scrollIndicators(.hidden)
                        .overlay(alignment: .bottom) {
                            if textCopied{
                                SuccessPopUp(text: "Text copied")
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                            textCopied = false
                                        }
                                    }
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: textCopied)
                    }
                }
                .onTapGesture {
                    UIApplication.shared.dismissKeyboard()
                }
                VStack{
                    if let img = tempImg {
                        Image(uiImage: img)
                            .resizable()
                            .frame(width: 116, height: 116)
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .contentShape(Rectangle())
                            .overlay(alignment: .topTrailing) {
                                Button{
                                    tempImg = nil
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .foregroundStyle(Color.white)
                                        .frame(width: 12, height: 12)
                                        .padding()
                                        .frame(width: 25, height: 25)
                                        .background(.black.opacity(0.48))
                                        .clipShape(Circle())
                                        .padding(4)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                        TextField("", text: $tempText, prompt: Text("Send a message".localizedString(langMan.currentLanguage)).foregroundColor(Color(hex: "#A4A4A4")).font(.custom(FontHelper.reg.name(), size: 16)))
                            .padding()
                            .background(Color(hex: "#F5F5F5"))
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            .autocorrectionDisabled()
                    
                    
                    HStack{
                        Button{
                            showMoreTools.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.black)
                                .frame(width: 32, height: 32)
                                .rotationEffect(.degrees(showMoreTools ? 45 : 0))
                                
                        }
                        
                        if showMoreTools {
                            Button{
                                showPicker.toggle()
                                useCamera = true
                            } label: {
                                Image(.takePhoto)
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            
                            RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#F0F0F0"))
                                .frame(width: 1, height: 15)
                            
                            Button{
                                showPicker.toggle()
                                useCamera = false
                            } label: {
                                Image(.gallery)
                                    .resizable()
                                    .frame(width: 26, height: 26)
                            }
                            .sheet(isPresented: $showPicker) {
                                ImagePicker(selectedImage: $tempImg, sourceType: useCamera ? .camera : .photoLibrary)
                                    .ignoresSafeArea()
                            }
                            
                        }
                        
                        Spacer()
                        
                        Button{
                            if !subsMan.hasSubscription && vm.chatCount > 4{
                                showPaywall = true
                            } else {
                                if vm.chatCount == 4 {
                                    requestReview()
                                }
                                vm.msgToSend = tempText
                                vm.imgToSend = tempImg
                                Task{
                                    await vm.sendText(langCode: langMan.currentLanguage)
                                }
                                vm.chatMsgs.append(TextMessageModel(text: vm.msgToSend, isIncoming: false, image: vm.imgToSend))
                                tempText = ""
                                tempImg = nil
                                vm.chatEncounteredError = false
                                	
                                
                            }
                            vm.chatCount += 1
                        } label: {
                            Image(systemName: "arrow.up")
                                .foregroundStyle(.white)
                                .padding()
                                .frame(width: 31, height: 31)
                                .background(Color(hex: "#407CF3").opacity(tempText.isEmpty ? 0.43 : 1.0))
                                .clipShape(Circle())
                            
                        }
                        .disabled(tempText.isEmpty)
                        
                        
                    }
                    .animation(.easeInOut(duration: 0.3), value: showMoreTools)
                    .animation(.easeInOut(duration: 0.3), value: tempImg)
                }
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showPaywall) {
                PayWallView()
                    .presentationCornerRadius(10)
                    .presentationDragIndicator(.hidden)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType // Allows choosing between camera and photo library

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}


#Preview {
    NavView()
        .environmentObject(LanguageManager())
        .environmentObject(ApphudSubsManager())
}
