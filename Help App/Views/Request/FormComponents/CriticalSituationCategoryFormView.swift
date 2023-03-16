//
//  CriticalSituationCategoryFormView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct CriticalSituationCategoryFormView: View {
    
    @Binding var selectedCriticalSituation: CriticalSituation
    var onSelect: (CriticalSituation) -> Void = {_ in}
    
    let criticalSituations = CriticalSituation.allCases
    
    var body: some View {
        HStack {
            Text("Choose Category")
                .font(.title3)
                .fontWeight(.bold)
            .padding(.leading)
            
            Spacer()
        }
        
        GeometryReader { reader in
            Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                GridRow {
                    ForEach(0..<2) { index in
                        CriticalSituationItemView(
                            onSelect: onSelect,
                            situation: criticalSituations[index]
                        )
                            .id(criticalSituations[index].id)
                            .frame(width: (bounds.width - 16 * 3) / 2,
                                   height: abs((reader.size.height - 16 * 3) / 3))
                    }
                }

                GridRow {
                    ForEach(2..<4) { index in
                        CriticalSituationItemView(
                            onSelect: onSelect,
                            situation: criticalSituations[index]
                        )
                            .id(criticalSituations[index].id)
                            .frame(width: (bounds.width - 16 * 3) / 2,
                                   height: abs((reader.size.height - 16 * 3) / 3))
                    }
                }

                GridRow {
                    CriticalSituationItemView(
                        onSelect: onSelect,
                        situation: criticalSituations[4]
                    )
                        .id(criticalSituations[4].id)
                        .frame(width: (bounds.width - 16 * 3) / 2,
                               height: abs((reader.size.height - 16 * 3) / 3))
                }

            }
            .padding([.leading, .trailing])
            
            Spacer()
                .frame(height: 16)
        }
        .frame(width: bounds.width)
        .frame(maxHeight: .infinity)
    }
}

struct CriticalSituationCategoryFormView_Previews: PreviewProvider {
    static var previews: some View {
        CriticalSituationCategoryFormView(selectedCriticalSituation: .constant(.trauma))
    }
}
