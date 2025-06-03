//
//  MainViewModel.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 23.02.2025.
//

import Foundation
import UIKit
import SwiftUI

class MainViewModel : ObservableObject {
    //ImgGen vars
    @Published var textToGenImg = ""
    @Published var generatedImgUrl : String?
    @Published var generatedUIImage : UIImage?
    
    @Published var genProgress = 0.0
    @Published var startGeneratingImg = false
    @Published var finishedGeneratingImg = false
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    @AppStorage("imgCount") var imgCount = 0
    
    
    //TextChat vars
    @Published var chatMsgs : [TextMessageModel] = []
    @Published var msgToSend = ""
    @Published var imgToSend : UIImage?
    
    @Published var curPage = NavTabs.text
    @AppStorage("chatCount") var chatCount = 0
    
    @Published var waitingForChat = false
    @Published var chatEncounteredError = false
    
    func sendText(langCode : String) async {
        guard !msgToSend.isEmpty else {return}
        guard let url = URL(string: "https://ardwide.fun/api/gimimichat") else {return}
        DispatchQueue.main.async {
            self.waitingForChat = true
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            var inlineData : InlineData?
            if let img = imgToSend {
                if let imgData = convertImageToBase64(img) {
                    inlineData = InlineData(mimeType: "image/jpeg", data: imgData)
                }
            } else {
                inlineData = nil
            }
            let body = ChatMessageModel(gmimiLang: langCode,
                                        gmimiPrompt: "Ты мой личный помощник",
                                        gmimiTextArray: [
                                            GmimiTextArray(role: "user", parts: [
                                                Part(text: msgToSend, inlineData: nil),
                                                Part(text: nil, inlineData: inlineData)
                                            ])
                                        ])
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        }
        catch{
            print(error)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.chatEncounteredError = true
                    self.waitingForChat = false
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 300 {
                    DispatchQueue.main.async {
                        self.chatEncounteredError = true
                        self.waitingForChat = false
                    }
                }
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(ChatResponseModel.self, from: data)
                    DispatchQueue.main.async{
                        let text = decodedData.candidates[0].content.parts[0].text
                        let newEntry = TextMessageModel(text: text, isIncoming: true)
                        self.chatMsgs.append(newEntry)
                        
                        self.waitingForChat = false
                        
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        
    }

    func convertImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
    
    func genImage() async {
        guard !textToGenImg.isEmpty else {return}
        guard let url = URL(string: "https://raudees.fun/api/flimage") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add queryText field
        let fieldName = "queryText"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(textToGenImg)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Send request
        URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let data = data else {
                    print("Invalid response or no data")
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(ImgGenSendResponse.self, from: data)
                    print("Request ID: \(result.requestID)")
                    self.fetchImageURL(requestID: result.requestID, prompt: result.prompt)  // Start polling
                } catch {
                    print("Decoding error: \(error)")
                }
            }.resume()
    }
    
    func fetchImageURL(requestID: String, prompt : String) {
        let urlString = "https://raudees.fun/api/flimage/\(requestID)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                print("Invalid response or no data")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ReusltImgResponse.self, from: data)
                if let imageUrl = result.fileURL {
                    print("Image URL received: \(imageUrl)")
                    DispatchQueue.main.async {
                        self.generatedImgUrl = imageUrl
                        self.downloadImage(from: imageUrl)
                    }
                } else {
                    print("Image still processing, retrying...")
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                        self.fetchImageURL(requestID: requestID, prompt: prompt)  // Retry after 2 seconds
                    }
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
    func downloadImage(from urlString: String) {
           guard let url = URL(string: urlString) else { return }

           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil, let downloadedImage = UIImage(data: data) else {
                   print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }

               DispatchQueue.main.async {
                   self.generatedUIImage = downloadedImage
               }
           }
           task.resume()
       }

}
