/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view for create notes.
*/

import SwiftUI

struct CreateNote: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var model: Model
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextFieldUI(placeHolder: "Notes", text: $model.newNotes, isFirstResponder: true)
                        .padding(.top, 10)
                        .padding(.bottom, 60)
                }
            }
            .navigationBarTitle("Create a new note", displayMode: .inline)
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
                        model.addNewNotes()
                        dismiss()
                    },
                    label: {
                        Text("Add")
                            .foregroundColor(model.newNotes.isEmpty ? .gray : .blue)
                    })
                    .buttonStyle(.plain)
                    .disabled(model.newNotes.isEmpty)
                }
            }
        }
    }
}
                             
struct CreateNote_Previews: PreviewProvider {
    static var previews: some View {
        CreateNote()
            .environmentObject(Model())
    }
}
