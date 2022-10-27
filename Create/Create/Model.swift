/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A representing all of the data the app needs to display in its interface.
*/

import Foundation
import SwiftUI
import Combine
import UserNotifications

class Model: ObservableObject {
    
    // ContentView Variable
    @Published var searchText: String = ""
    
    // Notes
    @Published var note = [Notes]()
    @Published var newNotes: String = ""
    let NoteKey: String = "NoteList"
    
    // Reminder
    @Published var reminderTitle = ""
    @Published var reminderBody = ""
    @Published var date = Date()
    
    init() {
        refreshNotes()
    }
    
    func refreshNotes() {
        guard let data = UserDefaults.standard.data(forKey: NoteKey)
        else {
            return
        }
        
        guard let savedNotes = try? JSONDecoder().decode([Notes].self, from: data)
        else {
            return
        }
        note = savedNotes
    }
    
    func addNewNotes() {
        note.append(Notes(id: String(note.count + 1), NotesItem: newNotes, completedNote: false))
       
        saveNote()
        self.newNotes = ""
    }
    
    func moveNotes(from source : IndexSet, to destination : Int) {
        note.move(fromOffsets: source, toOffset: destination)
        saveNote()
    }
    
    func deleteNotes(at offsets : IndexSet) {
        note.remove(atOffsets: offsets)
        saveNote()
    }
    
    func updateNotes(item: Notes) {
        if let index = note.firstIndex(where: { $0.id == item.id }) {
            note[index] = item.updateCompletion()
        }
        saveNote()
    }
    
    func saveNote() {
        if let encodedData = try? JSONEncoder().encode(note) {
            UserDefaults.standard.set(encodedData, forKey: NoteKey)
        }
    }
    
    // Notifications
    @Published var notifications: [UNNotificationRequest] = []
    @Published var authorizationStatus: UNAuthorizationStatus?
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized : .denied
            }
        }
    }
    
    func reloadLocalNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }
    
    func createLocalNotification(title: String, body: String, hour: Int, minute: Int, completion: @escaping (Error?) -> Void) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
    
    func deleteLocalNotifications(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

extension Model {
    func deleteLocalNotifications(_ indexSet: IndexSet) {
        deleteLocalNotifications(
            identifiers: indexSet.map { notifications[$0].identifier }
        )
        reloadLocalNotifications()
    }
    
    func moveNotification(from source : IndexSet, to destination : Int) {
        notifications.move(fromOffsets: source, toOffset: destination)
    }
    
    func refreshLocalNotifications() {
        reloadLocalNotifications()
    }
}
