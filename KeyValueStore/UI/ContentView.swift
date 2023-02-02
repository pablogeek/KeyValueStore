//
//  ContentView.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            ForEach($viewModel.commandViewModels) { $commandModel in
                HStack {
                    ForEach(0..<commandModel.inputTexts.count, id: \.self) { index in
                        TextField("", text: Binding(
                            get: { return commandModel.inputTexts[index] },
                            set: { (newValue) in return commandModel.inputTexts[index] = newValue}
                          ))
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                        
                    }
                    
                    Button {
                        viewModel.sendCommand(inputCommand: commandModel.command)
                    } label: {
                        Text(commandModel.command.name)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            TextEditor(text: $viewModel.commandText)
                .textSelection(.disabled)
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .background(.black)
            
            Button {
                viewModel.begin()
            } label: {
                Text("Begin")
            }.buttonStyle(.bordered)
            
            Button {
                viewModel.commit()
            } label: {
                Text("Commit")
            }
            .buttonStyle(.bordered)
            
            Button {
                viewModel.rollback()
            } label: {
                Text("Rollback")
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                keyValueTransactionsService: KeyValueTransactionsServiceImpl(
                    keyValueRepository: KeyValueMemoryRepository()
                )
            )
        )
    }
}
