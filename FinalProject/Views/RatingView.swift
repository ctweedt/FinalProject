//
//  RatingView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/9/22.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating : Int
    let highestRating = 5
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    let font: Font = .largeTitle
    let fillColor: Color = .cyan
    let emptyColor: Color = .black
    
    var body: some View {
        HStack {
            ForEach(1...highestRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundColor(number <= rating ? fillColor: emptyColor)
                    .onTapGesture {
                        rating = number
                    }
            }
            .font(font)
        }
        
        
    }
    func showStar( for number: Int) -> Image {
        if number > rating {
            return unselected
        } else {
            return selected
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
