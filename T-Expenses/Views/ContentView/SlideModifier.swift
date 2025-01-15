//
//  SlideModifier.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 15/01/25.
//

import SwiftUI


extension AnyTransition {

    struct SlideModifier: ViewModifier {
        let width: CGFloat
        @Binding var direction: TransitionDirection

        func body(content: Content) -> some View {
            switch direction {
                case .Forward: return content.offset(x: width)
                case .Backward: return content.offset(x: -width)
                case .None: return content.offset(y: 0)
            }
        }
    }

    static func dynamicSlide(forward: Binding<TransitionDirection>, size: CGSize) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: SlideModifier(width: size.width, direction: forward),
                identity: SlideModifier(width: 0, direction: .constant(.Forward))
            ),

            removal: .modifier(
                active: SlideModifier(width: -size.width, direction: forward),
                identity: SlideModifier(width: 0, direction: .constant(.Forward))
            )
        )
    }
}
