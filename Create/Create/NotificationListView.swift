/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing notification reminders.
*/

import SwiftUI

struct NotificationListView: View {
    
    @State var createReminders: Bool = false
    @EnvironmentObject private var model: Model
    
    private static var notificationDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    private func timeDisplayText(from notification: UNNotificationRequest) -> String {
        guard let nextTriggerDate = (notification.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() else {
            return ""
        }
        return Self.notificationDateFormatter.string(from: nextTriggerDate)
    }

    @ViewBuilder
    var infoOverlayView: some View {
        switch model.authorizationStatus {
        case .authorized:
            if model.notifications.isEmpty {
                OverLayView(
                    infoMessage: "No Reminders"
                )
            }
        case .denied:
            OverLayView(
                infoMessage: "Please Enable Notification Permission in Settings in order to push Reminders"
            )
        default:
            EmptyView()
        }
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                ForEach(model.notifications, id: \.identifier) { notification in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(notification.content.title)
                            
                            Text(notification.content.body)
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                }
                .onMove(perform: model.moveNotification)
                .onDelete(perform: model.deleteLocalNotifications)
            }
            .searchable(text: $model.searchText, placement: .navigationBarDrawer(displayMode: .always)) {
                ForEach(model.notifications, id: \.identifier) { notification in
                    HStack {
                        Text(notification.content.title)
                            .foregroundColor(.black)
                            .searchCompletion(notification.content.title)
                        
                        Spacer()
                    }
                }
                .searchCompletion(model.searchText)
            }
            .refreshable(action: {
                model.refreshLocalNotifications()
            })
            .navigationTitle("Reminders")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        createReminders.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    })
                    .buttonStyle(.plain)
                    .sheet(isPresented: $createReminders, content: {
                        CreateReminder()
                            .environmentObject(model)
                            .interactiveDismissDisabled()
                    })
                }
            }
            .overlay(infoOverlayView)
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

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
            .environmentObject(Model())
    }
}
