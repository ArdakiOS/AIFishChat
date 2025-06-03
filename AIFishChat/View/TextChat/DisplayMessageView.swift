struct DisplayMessageView : View {
    let text : TextMessageModel
    var body: some View {
        if text.isIncoming {
            HStack(alignment: .top){
                Image(.logo)
                    .resizable()
                    .frame(width: 27, height: 27)
                    .clipShape(Circle())
                
                Text(text.text)
                    .multilineTextAlignment(.leading)
                    .font(.custom(FontHelper.reg.name(), size: 16))
            }
            .frame(maxWidth: 326)
        } else {
            VStack(spacing: 0){
                if let img = text.image{
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: 242, height: 242)
                        .scaledToFill()
                        .contentShape(Rectangle())
                }
                Text(text.text)
                    .font(.custom(FontHelper.reg.name(), size: 16))
                    .foregroundStyle(.white)
                    .padding(12)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: 242, alignment: .leading)
            .background{
                Color(hex: "#407CF3")
            }
            .clipShape(RoundedRectangle(cornerRadius: 19))
            
            
            
        }
    }
}