//
//  HelpRequestFormView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct HelpRequestFormView: View {
    
    @State var progress: HelpRequestFormStage = .category
    
    let criticalSituations = CriticalSituation.allCases
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                ProgressBarView(progress: $progress)
                
                Text("Choose Category")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Grid(horizontalSpacing: 16) {
                    GridRow {
                        ForEach(0..<2) { index in
                            CriticalSituationItemView(situation: criticalSituations[index])
                                .frame(width: (bounds.width - 16 * 3) / 2, height: 200)
                                .id(criticalSituations[index].rawValue)
                        }
                    }
                    
                    GridRow {
                        ForEach(2..<4) { index in
                            CriticalSituationItemView(situation: criticalSituations[index])
                                .frame(width: (bounds.width - 16 * 3) / 2, height: 200)
                                .id(criticalSituations[index].rawValue)
                        }
                    }
                    
                    GridRow {
                        CriticalSituationItemView(situation: criticalSituations[4])
                            .frame(width: (bounds.width - 16 * 3) / 2, height: 200)
                            .id(criticalSituations[4].rawValue)
                    }
                    
                }
                .padding([.leading, .trailing])
                
                Spacer()
            }
            .navigationTitle(Text("Help Request"))
            .toolbar {
                Button {
                    //action
                } label: {
                    Text("Cancel")
                }

            }
        }
    }
}

struct HelpRequestFormView_Previews: PreviewProvider {
    static var previews: some View {
        HelpRequestFormView()
    }
}
