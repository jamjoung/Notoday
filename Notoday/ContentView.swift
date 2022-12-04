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
            VStack{
                if checkDate==false{
                    Text("Welcome")
                    Button {
                        toNote = true
                    } label: {
                        Text("Create Note")
                    }.navigationDestination(isPresented: $toNote) {
                        NotePage()
                    }
                }
                else {
                    Text("You already wrote a note for today!")
                    Button {
                        toHome = true
                    } label: {
                        Text("View All Notes")
                    }.navigationDestination(isPresented: $toHome) {
                        HomePage()
                    }
                }
            }.onAppear(){
                if (checkToday() == true) {
                    checkDate = true
                }
                else {
                    checkDate = false
                }
            }

            //        if checkDate == false{ //usually false, change!!
            //            NavigationStack{
            //                VStack{
            //                    Text("Welcome")
            //                    Button {
            //                        toNote = true
            //                    } label: {
            //                        Text("Create Note")
            //                    }
            //                }.navigationDestination(isPresented: $toNote) {
            //                    NotePage()
            //                }
            //            }
            //        }
            //        else {
            //            NavigationStack{
            //                VStack{
            //                    Text("You already wrote a note for today!")
            //                    Button {
            //                        toHome = true
            //                    } label: {
            //                        Text("View All Notes")
            //                    }
            //                }.navigationDestination(isPresented: $toHome) {
            //                    HomePage()
            //                }
            //
            //            }
            //        }
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
