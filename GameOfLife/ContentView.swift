//
//  ContentView.swift
//  GameOfLife
//
//  Created by Laurent Jeanjean on 30/04/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game = GameOfLifeModel(rows: 32, cols: 32)
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            GridView(viewModel: game)
                .padding()
            
            HStack {
                Button("Prochaine Génération") {
                    game.nextGeneration()
                }
                .padding()
                
                Button(isRunning ? "Arrêter" : "Lancer") {
                    isRunning.toggle()
                    if isRunning {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }
                .padding()
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            game.nextGeneration()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}


#Preview {
    ContentView()
}

struct GridView: View {
    @ObservedObject var viewModel: GameOfLifeModel
    @State private var previousModifiedCell: (x: Int, y: Int)?
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let availableHeight = geometry.size.height
            let effectiveCellSize = min(
                availableWidth / CGFloat(viewModel.cols),
                availableHeight / CGFloat(viewModel.rows)
            )
            
            let xOffset = (availableWidth - effectiveCellSize * CGFloat(viewModel.cols)) / 2
            let yOffset = (availableHeight - effectiveCellSize * CGFloat(viewModel.rows)) / 2
            
            Canvas { context, size in
                for x in 0..<viewModel.cols {
                    for y in 0..<viewModel.rows {
                        let rect = CGRect(
                            x: xOffset + CGFloat(x) * effectiveCellSize,
                            y: yOffset + CGFloat(y) * effectiveCellSize,
                            width: effectiveCellSize,
                            height: effectiveCellSize
                        )
                        
                        if viewModel.grid[x][y] {
                            context.fill(Path(rect), with: .color(.blue))
                        } else {
                            context.fill(Path(rect), with: .color(.black))
                        }
                        
                        context.stroke(
                            Path(rect),
                            with: .color(.gray.opacity(0.5)),
                            lineWidth: 1
                        )
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // Convertir les coordonnées du geste en coordonnées de la grille
                        let x = Int((value.location.x - xOffset) / effectiveCellSize)
                        let y = Int((value.location.y - yOffset) / effectiveCellSize)
                        
                        let isValidCell = x >= 0 && x < viewModel.cols && y >= 0 && y < viewModel.rows
                        guard isValidCell else { return }
                        
                        // Vérifier si la cellule est déjà modifiée, si oui on passe pour éviter un effet de blink pour chaque pixel parcouru
                        var isSameCell: Bool {
                            guard let previousModifiedCell else { return false }
                            
                            return previousModifiedCell.x == x && previousModifiedCell.y == y
                        }
                        guard isSameCell == false else { return }
                        
                        viewModel.toggleCell(row: x, col: y)
                        previousModifiedCell = (x, y)
                    }
                    .onEnded { _ in
                        previousModifiedCell = nil
                    }
            )
        }
    }
}
