/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Setting Up a Notes Model.
*/

import Foundation
import SwiftUI
import Combine

struct Notes: Identifiable, Codable {
    var id = String()
    var NotesItem = String()
    var completedNote: Bool
    
    init(id: String, NotesItem: String, completedNote: Bool) {
        self.id = id
        self.NotesItem = NotesItem
        self.completedNote = completedNote
    }
    
    func updateCompletion() -> Notes {
        return Notes(id: id, NotesItem: NotesItem, completedNote: !completedNote)
    }
}
