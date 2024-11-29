//
//  JourneyViewModel.swift
//  exploreTest
//
//  Created by Siddharth Chaudhary on 29/11/24.
//

import Foundation

class JourneyViewModel: ObservableObject {
    @Published var journeys: [Journey] = []
    @Published var problemFilters: [ProblemFilter] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private let apiURL = "https://dummyjson.com/c/8e57-9a9a-4a6c-ba39"

    func fetchJourneys() {
        isLoading = true
        guard let url = URL(string: apiURL) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Failed to load data: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(JourneyResponse.self, from: data)
                    
                    // Update journeys
                    self?.journeys = decodedResponse.data ?? []
                    
                    // Update problem filters and add "All"
                    var filters = decodedResponse.problemFilter ?? []
                    let allFilter = ProblemFilter(title: "All", id: 100)
                    filters.insert(allFilter, at: 0)
                    self?.problemFilters = filters
                    
                    print("Problem filters after API fetch: \(filters.map { $0.title })") // Debug statement
                } catch {
                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
