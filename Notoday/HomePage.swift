//
//  HomePage.swift
//  Notoday
//
//  Created by Jamie Joung on 11/7/22.
//

import Foundation
import SwiftUI
import CoreData

struct NoteCell : View {
    
    @State var note: Note
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        return VStack(alignment: .leading) {
            Text(note.noteTitle!)
                .font(.headline)
            
            Text(note.noteText!)
                .font(.subheadline)
                .lineLimit(3)
            
            Text(dateFormatter.string(from: note.noteTimestamp!))
                .font(.footnote)
        }.padding(8)
        
    }
}

struct HomePage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var noteText: String = "test"
    @State private var noteTitle: String = ""
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(key: "noteTimestamp", ascending: false)])
    private var allNotes: FetchedResults<Note>
    
    
    private func deleteNote(at offsets: IndexSet) {
        offsets.forEach { index in
            let note = allNotes[index]
            viewContext.delete(note)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    
    var body: some View {
            List {
                Text("Testing:")
                ForEach(allNotes) {note in
                    HStack {
                        VStack{
                            NavigationLink(destination: NoteCell(note: note)) {
                                Text("Title: \(note.noteTitle ?? "")")
                                Text("Text: \(note.noteText ?? "")")
                                    .padding()
                                               }
                        }
                        
                    }
                }.onDelete(perform: deleteNote)
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
