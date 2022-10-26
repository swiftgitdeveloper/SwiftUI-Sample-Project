/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view for create reminders.
*/

import SwiftUI

struct CreateReminder: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var model: Model
   
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextFieldUI(placeHolder: "Title", text: $model.reminderTitle, isFirstResponder: true).padding(.vertical, 10)
                    
                    TextField("Notes", text: $model.reminderBody)
                        .padding(.top, 10)
                        .padding(.bottom, 60)
                }
                
                Section {
                    HStack {
                        Text("Trigger Time")
                        Spacer()
                        DatePicker("", selection: $model.date, displayedComponents: [.hourAndMinute])
                    }
                }
                
            }
            .navigationBarTitle("New Reminder", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.cancellationAction) {
                    Button(action: {
                        dismiss()
                    },
                    label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    })
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
                    Button(action: {
                        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: model.date)
                        guard let hour = dateComponents.hour, let minute = dateComponents.minute else { return }
                        model.createLocalNotification(title: model.reminderTitle, body: model.reminderBody, hour: hour, minute: minute) { error in
                            if error == nil {
                                DispatchQueue.main.async {
                                    dismiss()
                                }
                            }
                        }
                    },
                    label: {
                        Text("Add")
                            .foregroundColor(model.reminderTitle.isEmpty ? .gray : .blue)
                    })
                    .buttonStyle(.plain)
                    .disabled(model.reminderTitle.isEmpty)
                }
            }
            .onDisappear {
                model.refreshLocalNotifications()
            }
        }
    }
}

struct TextFieldUI: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

    }
    let placeHolder: String
    @Binding var text: String
    var isFirstResponder: Bool = false

    func makeUIView(context: UIViewRepresentableContext<TextFieldUI>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = placeHolder
        return textField
    }

    func makeCoordinator() -> TextFieldUI.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldUI>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
                             
struct CreateReminder_Previews: PreviewProvider {
    static var previews: some View {
        CreateReminder()
            .environmentObject(Model())
    }
}
