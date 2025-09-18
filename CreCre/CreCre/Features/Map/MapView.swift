//
//  MapView.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var position: MapCameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), // 서울
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        )

    var body: some View {
        Map(position: $position)
            .onAppear { print("MapView onAppear") }
    }
}

#Preview {
    MapView()
}
