//
//  ContentView.swift
//  Notoday
//
//  Created by Jamie Joung on 11/6/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var toNote: Bool = false

    var body: some View {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }
    }
}
