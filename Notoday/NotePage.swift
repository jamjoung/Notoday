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
    static let happyColor = Color(red: 242/255, green: 187/255, blue: 201/255) // Pastel orange
    static let satisfiedColor = Color(red: 242/255, green: 206/255, blue: 216/255) // Peach
    static let neutralColor = Color(red: 233/255, green: 225/255, blue: 234/255) // Light green
    static let tiredColor = Color(red: 174/255, green: 179/255, blue: 218/255) // Light blue
    static let upsetColor = Color(red: 96/255, green: 106/255, blue: 169/255) // Pastel blue
    static let bgColor = Color(red: 243/255, green: 242/255, blue: 248/255) // Pastel blue
    
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
        }
    }
}


struct NotePage: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var selectedEmotion = "Neutral"
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
        newNote.noteEmotion = self.selectedEmotion
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
                    Picker(selection: $selectedEmotion, label: Text("Emotion")){
                        ForEach(emotions, id: \.self){ Text($0)}
                    }.listRowBackground(styleEmotions(rawValue: selectedEmotion)!.emotionColor)
                }
                
                TextField("Write about your day!", text: $text, axis: .vertical)
                    .lineLimit(15, reservesSpace:true)
            }
            
            Button {
                goHome = true
                saveNote()
            } label: {
                Text("Save Note")
                    .foregroundColor(Color.black)
            }
            .navigationBarBackButtonHidden(true)
            .padding()
            .padding([.leading, .trailing], 20)
            .background(styleEmotions(rawValue: selectedEmotion)!.emotionColor)
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            
        }.background(Color.bgColor)
            .navigationDestination(isPresented: $goHome) {
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

