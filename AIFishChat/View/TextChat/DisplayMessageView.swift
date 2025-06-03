//
//  DisplayMessageView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import SwiftUI

struct DisplayMessageView : View {
    let text : TextMessageModel
    @Binding var textCopied : Bool
    var body: some View {
        if text.isIncoming {
            HStack(alignment: .top){
                Image(.logo)
                    .resizable()
                    .frame(width: 27, height: 27)
                    .clipShape(Circle())
                VStack(alignment: .leading){
                    HStack(alignment:.bottom){
                        Text(convertMarkdown(text.text))
                            .multilineTextAlignment(.leading)
                            .font(.custom(FontHelper.reg.name(), size: 16))
                        
                        Text(formatDate())
                            .foregroundStyle(Color(hex: "#A1A1A1").opacity(0.46))
                            .font(.custom(FontHelper.med.name(), size: 11))
                    }
                    
                    Button{
                        copyToClipboard(text: text.text)
                        textCopied = true
                    }label: {
                        Image(.copyTxt)
                            .resizable()
                            .frame(width: 27, height: 27)
                    }
                }
                
            }
            .frame(maxWidth: 326, alignment: .leading)
        } else {
            if let img = text.image {
                VStack(spacing: 0){
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 242, maxHeight: 242) // Allows resizing if needed
                        .contentShape(Rectangle())
                    HStack(alignment:.bottom){
                        Text(text.text)
                            .font(.custom(FontHelper.reg.name(), size: 16))
                            .foregroundStyle(.white)
                        
                        Text(formatDate())
                            .foregroundStyle(Color.white.opacity(0.46))
                            .font(.custom(FontHelper.med.name(), size: 11))
                    }
                    .multilineTextAlignment(.leading)
                    .padding(12)
                }
                .frame(maxWidth: 242)
                .background{
                    Color(hex: "#407CF3")
                }
                .clipShape(RoundedRectangle(cornerRadius: 19))
            } else {
                HStack(alignment:.bottom){
                    Text(text.text)
                        .font(.custom(FontHelper.reg.name(), size: 16))
                        .foregroundStyle(.white)
                    
                    Text(formatDate())
                        .foregroundStyle(Color.white.opacity(0.46))
                        .font(.custom(FontHelper.med.name(), size: 11))
                }
                .multilineTextAlignment(.leading)
                .padding(12)
                .background{
                    Color(hex: "#407CF3")
                }
                .clipShape(RoundedRectangle(cornerRadius: 19))
            }
            
        }
    }
    
    func convertMarkdown(_ text: String) -> AttributedString {
        let formattedText = text.replacingOccurrences(of: "\n", with: "  \n") // Ensures new lines render
        do{
            var output = try AttributedString(markdown: formattedText,
                                              options: .init(allowsExtendedAttributes: true,
                                                             interpretedSyntax: .full,
                                                             failurePolicy: .returnPartiallyParsedIfPossible),
                                              baseURL: nil)
            
            for (intentBlock, intentRange) in output.runs[AttributeScopes.FoundationAttributes.PresentationIntentAttribute.self].reversed() {
                guard let intentBlock = intentBlock else { continue }
                for intent in intentBlock.components {
                    switch intent.kind {
                    case .header(level: let level):
                        switch level {
                        case 1:
                            output[intentRange].font = .system(.title).bold()
                        case 2:
                            output[intentRange].font = .system(.title2).bold()
                        case 3:
                            output[intentRange].font = .system(.title3).bold()
                        default:
                            break
                        }
                    default:
                        break
                    }
                }
                
                if intentRange.lowerBound != output.startIndex {
                    output.characters.insert(contentsOf: "\n\n", at: intentRange.lowerBound)
                }
            }
            return output
        }
        catch {
            print(error)
        }
        
        return AttributedString(text)
        
    }
    
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: Date())
    }
}
