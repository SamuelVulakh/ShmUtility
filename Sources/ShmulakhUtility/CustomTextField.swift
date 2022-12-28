//
//  File.swift
//  
//
//  Created by Samuel Vulakh on 12/27/22.
//

import SwiftUI

@available(macOS 11.0, *)
@available(iOS 10.15, *)
struct ShmextField: View {
    
    /// Text Value
    @Binding var text: String
    
    /// Title of Text Field
    @State var title: String
    
    /// Show Top Title (By Default It Is Not shown)
    @State var showTitle = false
    
    /// Password Variables
    @State var isPassword: Bool
    
    /// If it is a password, this is the boolean for whether to show the actual text or bubbles
    @State var showPasswordText: Bool = false
    
    /// If You Would Like To Add Right Content, You Can Do So Here
    let right: AnyView?
    
    /// If You Would Like To Add Right Content, You Can Do So Here
    let left: AnyView?

    init(
        text: Binding<String>,
        title: String,
        showTitle: Bool = false,
        isPassword: Bool = false,
        right: (() -> (some View))? = nil,
        left: (() -> (some View))? = nil
    ) {
        self._text = text
        self.title = title
        self.showTitle = showTitle
        self.isPassword = isPassword
        
        /// You Can Only Use Right Content If Item Is Not A Password
        if let right, isPassword == false {
            self.right = AnyView(right())
        } else {
            self.right = nil
        }
        
        if let left {
            self.left = AnyView(left())
        } else {
            self.left = nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Title
            if showTitle {
                Text(title)
                    .foregroundColor(.black)
                    .font(.system(size: 17))
            }
            
            HStack(spacing: 15) {
                
                // If There Is Left Content, Display it
                if let left {
                    left
                }
                
                // If it is a password then you choose whether it is secure or not
                if isPassword && !showPasswordText {
                    SecureField(title, text: $text)
                        .background(Color.white)
                } else {
                    // Otherwise just a standard Textfield
                    TextField(title, text: $text)
                        .autocorrectionDisabled(true)
                        .background(Color.white)
                }
                
                // If it is a password this is the eye button to show or hide the password
                if isPassword {
                    Button {
                        withAnimation { showPasswordText.toggle() }
                    } label: {
                        Image(systemName: showPasswordText ? "eye.fill": "eye.slash.fill")
                            .foregroundColor(.black)
                    }
                    // If There Is Right Content, Display it
                } else if let right {
                    right
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 4).stroke(text != "" ? Color.accentColor : .black, lineWidth: 1))
        }
        .padding()
    }
}
