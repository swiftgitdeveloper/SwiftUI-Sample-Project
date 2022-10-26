/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing notes.
*/

import SwiftUI

struct NotesListView: View {
    
    @State var createNotes: Bool = false
    @Environment(\.isSearching) private var isSearching
    @EnvironmentObject private var model: Model
    
    var body: some View {
        if #available(iOS 15.0, *) {
            if !model.note.isEmpty {
                List {
                    Section(header: Text("Notes")
                                .fontWeight(.bold)
                                .font(.system(.title3, design: .rounded))
                                .foregroundColor(.black), content: {
                        ForEach(model.note) { note in
                            HStack {
                                Image(systemName: note.completedNote ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(note.completedNote ? .yellow : .gray)
                                    .imageScale(.large)
                                    .onTapGesture(perform: {
                                        model.updateNotes(item: note)
                                    })
                                
                                Text(note.NotesItem)
                            }
                        }
                        .onMove(perform: model.moveNotes)
                        .onDelete(perform: model.deleteNotes)
                    })
                    .textCase(nil)
                }
                .listStyle(.insetGrouped)
                .searchable(text: $model.searchText, placement: .navigationBarDrawer(displayMode: .always)) {
                    ForEach(model.note) { note in
                        HStack {
                            Text(note.NotesItem)
                        }
                    }
                    searchCompletion(model.searchText)
                }
                .refreshable(action: {
                    model.refreshNotes()
                })
                .navigationTitle("Notes")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    //Navigation Bar Trailing Button
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            createNotes.toggle()
                        }, label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(.blue)
                        })
                        .buttonStyle(.plain)
                        .sheet(isPresented: $createNotes, content: {
                            CreateNote()
                                .environmentObject(model)
                        })
                    }
                }
            } else {
                if !isSearching && model.note.isEmpty {
                    Button(action: {
                        createNotes.toggle()
                    }, label: {
                        if #available(iOS 16.0, *) {
                            HStack {
                                Spacer()
                                Text("Create Your First Note")
                                    .foregroundColor(.blue)
                                
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                        } else {
                            // Fallback on earlier versions
                        }
                    })
                    .buttonStyle(.plain)
                    .sheet(isPresented: $createNotes, content: {
                        CreateNote()
                            .environmentObject(model)
                            .interactiveDismissDisabled()
                    })
                    .navigationTitle("No Notes")
                    .navigationBarTitleDisplayMode(.large)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotesListView()
                .environmentObject(Model())
        }
    }
}
