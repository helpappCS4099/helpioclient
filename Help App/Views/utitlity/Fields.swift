//
//  Fields.swift
//  Help App
//
//  Created by Artem Rakhmanov on 01/02/2023.
//

import SwiftUI

enum FocusedField {
    case email, password, firstName, lastName, search
}

struct Field: View {
    
    var fieldLabel: String = "Field"
    var placeholder: String = ""
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = {}
    @FocusState var focusedField: FocusedField?
    var type: UITextContentType? = .password
    
    func textField() -> some View {
        ZStack {
            if (type != .password && type != .newPassword) {
                TextField(placeholder, text: $text)
                    .textContentType(type)
                    .onSubmit {
                        commit()
                    }
            } else {
                SecureField(placeholder, text: $text)
                    .textContentType(type)
                    .onSubmit {
                        commit()
                    }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text(fieldLabel)
                .font(.footnote)
            
            textField()
                .padding(.leading)
                .frame(width: bounds.width * 0.9, height: 75)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(Color("TextFieldColor"))
                )
        }
    }
}

struct Fields_Previews: PreviewProvider {
    static var previews: some View {
        Field(placeholder: "hello",
              text: .constant("")
        )
    }
}
