//
//  Fields.swift
//  Help App
//
//  Created by Artem Rakhmanov on 01/02/2023.
//

import SwiftUI

enum FocusedField: Hashable {
    case email, password, firstName, lastName, search
}

struct Field: View {
    
    var fieldLabel: String = "Field"
    var placeholder: String = ""
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = {}
    var fieldType: FocusedField = .password
    var focusedField: FocusState<FocusedField?>.Binding
    var type: UITextContentType? = .password
    
    func textField() -> some View {
        ZStack {
            if (type != .password && type != .newPassword) {
                TextField(placeholder, text: $text)
                    .focused(focusedField, equals: fieldType)
                    .textContentType(type)
                    .submitLabel(.next)
                    .contentShape(Rectangle())
                    .onSubmit {
                        commit()
                    }
            } else {
                SecureField(placeholder, text: $text)
                    .focused(focusedField, equals: fieldType)
                    .contentShape(Rectangle())
                    .textContentType(type)
                    .submitLabel(.continue)
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
                .frame(width: bounds.width * 0.9, height: 50)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(Color("TextFieldColor"))
                )
        }
    }
}

//struct Fields_Previews: PreviewProvider {
//
//    @FocusState var focus: FocusedField? = .password
//
//    var body: some View {
//        Field(placeholder: "hello",
//              text: .constant(""), focusedField: $focus
//        )
//    }
//
//    static var previews: some View {
//        Self()
//    }
//}
