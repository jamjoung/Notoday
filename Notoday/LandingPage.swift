//
//  LandingPage.swift
//  Notoday
//
//  Created by Jamie Joung on 11/9/22.
//

import Foundation
import SwiftUI
import CoreData

struct LandingPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var noteText: String = "test"
    @State private var noteTitle: String = ""
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(key: "noteTimestamp", ascending: false)])
    private var allNotes: FetchedResults<Note>
    
    @State private var nextPage: Bool = false

    var body: some View {
        NavigationView{
            VStack{
                Text("Welcome back, user!")
                
                NavigationLink(destination: NotePage(), isActive: $nextPage)
                {
                    Button(action: {
                        
                        nextPage = true
                    }){
                        Text("Create a Note")
                    }
                    
                }
            }
            
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LandingPage()
        }
    }
}
