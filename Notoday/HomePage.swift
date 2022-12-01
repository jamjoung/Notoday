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
        return VStack(spacing: 20) {
            
                Text(dateFormatter.string(from: note.noteTimestamp!))
                    .font(.footnote)
                    
                Text(note.noteTitle!)
                    .font(.headline)
                    
            Divider()
            let emo = styleEmotions(rawValue: note.noteEmotion!)
            Text(note.noteEmotion!)
                .foregroundColor(emo!.emotionColor)
                .font(.subheadline)
                .lineLimit(1)
                .padding(10)
            Divider()
            Text(note.noteText!)
                .font(.subheadline)
                .padding(10)
            Spacer()
        }
           
        
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
        NavigationStack{
            List {
                ForEach(allNotes, id: \.self) {note in
                    NavigationLink(destination: NoteCell(note: note)) {
                        VStack(alignment:.leading){
                            Text(note.noteTitle!)
                                .fontWeight(.bold)
                                .padding([.bottom, .trailing], 20)
                            Text(note.noteText!)
                                .lineLimit(3)
                                .opacity(0.9)
                        }
                    }.listRowBackground(styleEmotions(rawValue: note.noteEmotion!)!.emotionColor)
                        
                }.onDelete(perform: deleteNote)
            }.navigationTitle("My Notes")
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
