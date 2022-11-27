//
//  HomePage.swift
//  Notoday
//
//  Created by Jamie Joung on 11/7/22.
//

import Foundation
import SwiftUI
import CoreData

private func styleEmotions(_ value: String) -> Color {
        switch value {
            case "Happy":
                return Color.green
            case "Satisfied":
                return Color.orange
            case "Neutral":
                return Color.yellow
            case "Tired":
                return Color.blue
            case "Upset":
                return Color.red
            default:
                return Color.purple
        }
    }


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
            Text(note.noteEmotion!)
                .foregroundColor(styleEmotions(note.noteEmotion ?? ""))
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
            List {
                Text("Testing:")
                ForEach(allNotes) {note in
                        VStack{
                            NavigationLink(destination: NoteCell(note: note)) {
                                VStack(alignment:.leading){
                                    Text("Title: \(note.noteTitle ?? "")")
                                    Text("Text: \(note.noteText ?? "")")
                                        .lineLimit(3)
                                                   } .background(styleEmotions(note.noteEmotion ?? ""))
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
