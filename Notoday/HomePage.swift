//
//  HomePage.swift
//  Notoday
//
//  Created by Jamie Joung on 11/7/22.
//

import Foundation
import SwiftUI
import CoreData

struct HomePage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var noteText: String = "test"
    @State private var noteTitle: String = ""
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(key: "noteTimestamp", ascending: false)])
    private var allNotes: FetchedResults<Note>
    
    var body: some View {
        NavigationView{
            List {
                Text("Testing:")
                ForEach(allNotes) {note in
                    HStack {
                        VStack{
                            Text("Title: \(note.noteTitle ?? "")")
                            Text("Text: \(note.noteText ?? "")")

                        }
                        
                    }
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomePage()
        }
    }
}
