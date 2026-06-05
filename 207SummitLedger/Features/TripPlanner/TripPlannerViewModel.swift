import Combine
import Foundation

final class TripPlannerViewModel: ObservableObject {
    @Published var showAddTrip = false
    @Published var editingTrip: Trip?
    @Published var selectedTrip: Trip?
}
