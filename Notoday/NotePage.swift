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

extension Color {
    static let happyColor = Color(red: 255/255.0, green: 219/255.0, blue: 112/255.0)
    static let satisfiedColor = Color(red: 153/255.0, green: 217/255.0, blue: 140/255.0)
    static let neutralColor = Color(red: 82/255.0, green: 182/255.0, blue: 154/255.0)
    static let tiredColor = Color(red: 22/255.0, green: 138/255.0, blue: 173/255.0)
    static let upsetColor = Color(red: 35/255.0, green: 111/255.0, blue: 168/255.0)
}



enum styleEmotions: String, CaseIterable{
//        let emotion = Emotion(rawValue: value)
    case Happy
    case Satisfied
    case Neutral
    case Tired
    case Upset
    var emotionColor: Color{
        switch self {
        case .Happy:
            return Color.happyColor
        case .Satisfied:
            return Color.satisfiedColor
        case .Neutral:
            return Color.neutralColor
        case .Tired:
            return Color.tiredColor
        case .Upset:
            return Color.upsetColor
        default:
            return Color.neutralColor
        }
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
            print(newNote.noteTitle!)
            print(newNote.noteEmotion!)
            print("Note saved.")
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
                            }.listRowBackground(styleEmotions(rawValue: emotions[selectedIndex])!.emotionColor)
                        }
                    
                    TextField("Write about your day!", text: $text, axis: .vertical)
                        .lineLimit(15, reservesSpace:true)
                }
                
                Button {
                    goHome = true
                    saveNote()
                } label: {
                    Text("Save Note")
                }
            }.navigationDestination(isPresented: $goHome) {
                              HomePage()
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

