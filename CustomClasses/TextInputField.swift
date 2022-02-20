//
//  TextInputField.swift
//  LoginExample
//
//  Created by Jacob MacKinnon on 2022-02-17.
//

import SwiftUI

struct TextInputField: View {
    var title: String
    @Binding var text: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(text.isEmpty ? Color(.placeholderText) : .pink)
                .offset(y: text.isEmpty ? 0 : -25)
                .scaleEffect(text.isEmpty ? 1 : 0.8, anchor: .leading)
            TextField("", text: $text)
        }
        .padding(.top, text.isEmpty ? 0 : 15)
    }
}
