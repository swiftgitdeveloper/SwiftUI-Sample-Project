/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of reminders.
*/

import SwiftUI

struct ContentView: View {
    
    @State var createReminders: Bool = false
    @State var createNotes: Bool = false
    @EnvironmentObject private var model: Model
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List {
                    Section(content: {
                        NavigationLink(destination: {
                            NotificationListView()
                                .environmentObject(model)
                        }, label: {
                            HStack {
                                Image(systemName: "list.bullet.circle.fill")
                                    .imageScale(.large)
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                
                                Text("Reminders")
                            }
                            .padding(.vertical, 6)
                        })
            
                        NavigationLink(destination: {
                            NotesListView()
                                .environmentObject(model)
                        }, label: {
                            HStack {
                                Image(systemName: "folder.circle.fill")
                                    .imageScale(.large)
                                    .font(.title2)
                                    .foregroundColor(.yellow)
                                
                                Text("Notes")
                            }
                            .padding(.vertical, 6)
                        })
                    }, header: {
                        Text("My Lists")
                        .fontWeight(.bold)
                        .font(.system(.title3, design: .rounded))
                        .foregroundColor(.black)
                    })
                    .textCase(nil)
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Create")
                .toolbar {
                    //Botton Bar Button
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {
                            createReminders.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                                
                                Text("New Reminder")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                        })
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        Button(action: {
                            createNotes.toggle()
                        }, label: {
                            HStack {
                                Text("Add Notes")
                                    .foregroundColor(.yellow)
                                
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.yellow)
                            }
                        })
                        .buttonStyle(.plain)
                    }
                }
                .sheet(isPresented: $createReminders, content: {
                    CreateReminder()
                        .environmentObject(model)
                        .interactiveDismissDisabled()
                })
                .sheet(isPresented: $createNotes, content: {
                    CreateNote()
                        .environmentObject(model)
                        .interactiveDismissDisabled()
                })
                .onAppear(perform: model.reloadAuthorizationStatus)
                .onChange(of: model.authorizationStatus) { authorizationStatus in
                    switch authorizationStatus {
                    case .notDetermined:
                        model.requestAuthorization()
                    case .authorized:
                        model.reloadLocalNotifications()
                    default:
                        break
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    model.reloadAuthorizationStatus()
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Model())
    }
}
