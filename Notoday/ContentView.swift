//
//  ContentView.swift
//  Notoday
//
//  Created by Jamie Joung on 11/6/22.
//

import SwiftUI
import CoreData

public var noteCreatedToday = false

struct ContentView: View {
    @State private var toNote: Bool = false
    
    
    
    
//    func checkToday() -> Bool{
//        let dateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            return formatter
//        }()
//        let today = dateFormatter.string(from: Date())
//
//            if (dateFormatter.string(from: note.noteTimestamp!)) == today {
//                noteCreatedToday = true
//                print("already done!")
//                return true
//            }
//            else{
//                noteCreatedToday = false
//                print("time to write !")
//            }
//
//        return false
//    }
    
    @ViewBuilder
    var body: some View {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.sortDescriptors = [NSSortDescriptor(key: "noteTimestamp", ascending:false)];
        request.fetchLimit=1
        
        if noteCreatedToday==false {
            NavigationView{
                VStack{
                    Text("Welcome")
                    NavigationLink(destination: NotePage(), isActive: $toNote)
                    {
                        Button(action: {
                            toNote = true
                            
                        }){
                            Text("Create Note")
                        }
                        
                    }
                    
                }
                
            }
        }
        else {
            HomePage()
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
