//
//  ContentView.swift
//  Notoday
//
//  Created by Jamie Joung on 11/6/22.
//

import SwiftUI
import CoreData

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

extension Font {
    static let handWrittenFont = Font.custom("BradleyHandITCTT-Bold", size: 60.0)
    static let captionFont = Font.custom("BradleyHandITCTT-Bold", size: 18.0)
    
}
struct ContentView: View {
    @State private var toNote: Bool = false
    @State private var toHome: Bool = false
    @State private var checkDate: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(key: "noteTimestamp", ascending: true)])
    private var allNotes: FetchedResults<Note>
    
    
    func checkToday() -> Bool{
        let today = dateFormatter.string(from: Date())
        var lastNoteDate = ""
        
        if allNotes.last != nil {
            lastNoteDate = dateFormatter.string(from: allNotes.last!.noteTimestamp!)
            if today == lastNoteDate {
                print(today)
                print(lastNoteDate)
                return true
            }
            else{
                print("not match??")
                print(today)
                print(lastNoteDate)
                return false
            }
        }
        return false
    }
    //    init() {
    //        checkDate = checkToday()
    //    }
    
    @ViewBuilder
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                Image("landingBG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack{
                    Text("Notoday")
                        .padding(.top, 320)
                        .font(Font.handWrittenFont)
                    
                    if checkDate==false{
                        Button {
                            toNote = true
                        } label: {
                            Text("Create Note")
                                .foregroundColor(Color.upsetColor)
                        }.navigationDestination(isPresented: $toNote) {
                            NotePage()
                        }
                        .padding()
                        .padding([.leading, .trailing], 20)
                        .background(Color.satisfiedColor)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    }
                    else {
                        Text("You already wrote a note for today!")
                            .font(Font.captionFont)
                        
                        Button {
                            toHome = true
                        } label: {
                            Text("View All Notes")
                                .foregroundColor(Color.upsetColor)
                        }.navigationDestination(isPresented: $toHome) {
                            HomePage()
                        }
                        .padding()
                        .padding([.leading, .trailing], 20)
                        .background(Color.satisfiedColor)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    }
                }.onAppear(){
                    if (checkToday() == true) {
                        checkDate = true
                    }
                    else {
                        checkDate = false
                    }
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }
    }
}
