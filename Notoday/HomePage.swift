//
//  HomePage.swift
//  Notoday
//
//  Created by Jamie Joung on 11/7/22.
//

import Foundation
import SwiftUI
import CoreData

extension EditMode {
    var title: String {
        self == .active ? "Done" : "Edit"
    }
    
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}

struct NoteCell : View {
    let emotions = ["Happy", "Satisfied", "Neutral", "Tired", "Upset"]

    @State var note: Note
    //@State private var editable = false
    //@Environment(\.editMode) private var editMode
    @State var editMode: EditMode = .inactive

    
    //@State var updatedIndex = 0
    @State var updatedText = ""
    @State var updatedEmotion = "Neutral"
    @State var updatedTitle = ""
 
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //updatedIndex = find(emotions, note.noteEmotion)!

    func updateNote() {
        let existingNote = note
        //?? NSEntityDescription.insertNewObject(forEntityName: "Note", into: viewContext) as? Note
        
        existingNote.noteID = UUID()
        existingNote.noteTitle = self.updatedTitle
        existingNote.noteText = self.updatedText
        existingNote.noteTimestamp = Date()
        existingNote.noteEmotion = self.updatedEmotion
        do {
            try viewContext.save()
            print("Note updated.")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    init(note: Note) {
        _note = State(initialValue: note)
        //_editable = State(initialValue: false)
        _editMode = State(initialValue: EditMode.inactive)
        _updatedTitle = State(initialValue: note.noteTitle!)
        _updatedText = State(initialValue: note.noteText!)
        _updatedEmotion = State(initialValue: note.noteEmotion!)
        
        }
    
    
    private var editButton: some View {
        if editMode == .inactive {
                    return Button(action: {
                        self.editMode.toggle()
                    }) {
                        Text(self.editMode.title)
                    }
                }
        else {
                    return Button(action: {
                        self.editMode.toggle()
                        updateNote()
                    }) {
                        Text(self.editMode.title)
                    }
                }
        }
    
    var body: some View {
        return VStack(spacing: 20) {
            HStack{
                Text(dateFormatter.string(from: note.noteTimestamp!))
                    .font(.footnote)
            }
            
            if editMode == .active {
                TextField("", text: $updatedTitle, axis: .vertical)
                    .lineLimit(2, reservesSpace:true)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                Divider()
                
                Picker(selection: $updatedEmotion, label: Text("Emotion")){
                        ForEach(emotions, id: \.self){ Text($0)}
                }.padding()
                .listRowBackground(styleEmotions(rawValue: updatedEmotion)!.emotionColor)
                
                Divider()
                TextField("", text: $updatedText, axis: .vertical)
                    .lineLimit(15, reservesSpace:true)
                    .font(.subheadline)
                    .padding()
                    
                Spacer()
                
            }
            
            else {
                Text(note.noteTitle!)
                    .font(.headline)
                Divider()
                let emo = styleEmotions(rawValue: note.noteEmotion!)
                Text(note.noteEmotion!)
                    .background(emo!.emotionColor)
                    .cornerRadius(10)
                    .padding()
                    .font(.subheadline)
                    .lineLimit(1)
                Divider()
                Text(note.noteText!)
                    .font(.subheadline)
                    .padding(10)
                Spacer()
            }
        }
        .environment(\.editMode, self.$editMode)
        .toolbar {
            ToolbarItem() {
                editButton
            }
        }
    }
}

struct HomePage: View {
    
    @State private var noteText: String = "test"
    @State private var noteTitle: String = ""
    @Environment(\.managedObjectContext) private var viewContext

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
                    .navigationBarBackButtonHidden(true)
                        
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
