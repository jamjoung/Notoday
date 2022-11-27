//
//  NotePage.swift
//  Notoday
//
//  Created by Jamie Joung on 11/7/22.
//


import Foundation
import SwiftUI
import CoreData


//enum Emotion: String, Identifiable, CaseIterable {
//
//    var id: UUID {
//        return UUID()
//    }
//
//    case happy = "Happy"
//    case satisfied = "Satisfied"
//    case neutral = "Neutral"
//    case tired = "Tired"
//    case upset = "Upset"
//}
//
//extension Emotion {
//    var title: String {
//        switch self {
//            case .happy:
//                return "Happy"
//            case .satisfied:
//                return "Satisfied"
//            case .neutral:
//                return "Neutral"
//            case .tired:
//                return "Tired"
//            case .upset:
//                return "Upset"
//        }
//    }
//}
private func styleEmotions(_ value: String) -> Color {
//        let emotion = Emotion(rawValue: value)
        
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

struct NotePage: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var selectedEmotion = "Neutral"
    @State var selectedIndex = 0
    @State var text = ""
    @State var title = ""
    @State private var goHome: Bool = false
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(key: "noteTimestamp", ascending:false)]) private var allNotes : FetchedResults<Note>
    
    
    let emotions = ["Happy", "Satisfied", "Neutral", "Tired", "Upset"]
    
    

    func saveNote() {
        let newNote = Note(context:viewContext)
        newNote.noteID = UUID()
        newNote.noteTitle = self.title
        newNote.noteText = self.text
        newNote.noteTimestamp = Date()
        newNote.noteEmotion = self.emotions[selectedIndex]
        do {
            try viewContext.save()
            print(newNote.noteTitle)
            print(newNote.noteEmotion)
            print("Note saved.")
            noteCreatedToday=true
           
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
            VStack{
                Form{
                    Section(header: Text("Note Title")){
                        TextField("Enter Title", text: $title)
                    }
                        Section(header: Text("Select Emotion")){
                            Picker(selection: $selectedIndex, label: Text("Emotion")){
                                ForEach(0 ..< emotions.count){ Text(self.emotions[$0]).tag($0)
                                }
                            }.background(styleEmotions(emotions[selectedIndex]))
                        }
                    
                    TextField("Write about your day!", text: $text, axis: .vertical)
                        .lineLimit(15, reservesSpace:true)
                }
                
                NavigationLink(destination: HomePage(), isActive: $goHome)
                {
                    Button(action: {
                        saveNote()
                        goHome = true
                    }){
                        Text("Save Note")
                    }
                    
                }
            }
        }
    }


struct NotePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            let persistentContainer = CoreDataHelper.shared.persistentContainer
            NotePage().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}

