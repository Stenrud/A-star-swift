//
//  GraphivsView.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

var number = 1

class GraphicsView : NSView{
    
    var algo: IAlgorithm?
    
    // the calculated centered position for the board
    var boardBounds : NSRect?
    
    // the sice of each cell on the map
    var pixelSize : CGFloat?
    
    // keeps track wether the window is being resized or not
    var isResizing = false
    
    // should be set to true whenever the window changed size or a new board is loaded
    // so that the boardounds can be recalculated
    var needsResizing = true
    
    // chooses wether the solution path should be rendered alone or with the open/closed nodes
    var showOnlySolution = true
    
    // the colors of the start and end nodes
    let startColor = NSColor(red: 1, green: 0, blue: 1, alpha: 1)
    let endColor = NSColor(red: 0, green: 0.5, blue: 1, alpha: 1)
    
    // the colors used to render the map, based on their move cost
    let numberToColor = [
        -1 : NSColor.red,
        1 : NSColor(red: 0.843, green: 0.843, blue: 0.843, alpha: 1),
        2 : NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
        3 : NSColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),
        4 : NSColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1),
        5 : NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
    ]
    
    // is called when user starts resizing the window
    override func viewWillStartLiveResize() {
        isResizing = true
    }
    
    // is called when user ends resizing the window
    override func viewDidEndLiveResize() {
        isResizing = false
    }
    
    // is used to change pathfindig algorithm
    func loadAlgorithm(_ algo: IAlgorithm){
        self.algo = algo;
        needsResizing = true
        self.needsDisplay = true
    }
    
    // is called when the user clicks the board
    override func mouseDown(with event: NSEvent) {
        drawDot(point: event.locationInWindow)
    }
    
    // is called when the user draggs on the board
    override func mouseDragged(with event: NSEvent) {
        drawDot(point: event.locationInWindow)
    }
    
    // draws one dot on the board, currently only drawing obstacles
    func drawDot(point : NSPoint){
        guard let rect = boardBounds, let size = pixelSize else{
            return
        }

        let point = convert(point, from: nil)
        
        if(!rect.contains(point)){
            return
        }
        
        let x = Int((CGFloat(point.x) - rect.minX) / size)
        let y = Int((CGFloat(point.y) - rect.minY) / size)
        
        guard let algorithm = algo else{
            return
        }
        
        algorithm.set(x, y, -1)
        needsDisplay = true
    }
    
    
    // renders the board/map
    override func draw(_ dirtyRect: NSRect) {
        
        guard let aStar = algo else{
            fatalError("An algorithm should be loaded")
        }
        
        let board = aStar.maze
        
        // calculates new bounds for the board if needed
        // bounds should always be centered in the window
        if (isResizing || needsResizing || pixelSize == nil){
            pixelSize = min(bounds.width / CGFloat(board.width), bounds.height / CGFloat(board.height))
            
            let boardWidth = CGFloat(board.width) * pixelSize!
            let boardHeight = CGFloat(board.height) * pixelSize!
            
            let offsetX = bounds.width / 2.0 - boardWidth / 2
            let offsetY = bounds.height / 2.0 - boardHeight / 2
            
            boardBounds = NSRect(x: offsetX, y: offsetY, width: boardWidth, height: boardHeight)
            
            needsResizing = false
        }
        
        // pixelSize and boardBounds in optionals
        guard let pixelSize = pixelSize, let boardBounds = boardBounds else{
            fatalError()
        }
        
        // converts and draws map coordinates to pixel coordinates
        func drawRect(x: CGFloat, y:CGFloat, size: CGFloat){
            
            let pixelOffset = pixelSize * (1 - size)
            
            NSRect(x: boardBounds.minX + x * pixelSize + pixelOffset / 2, y: boardBounds.minY + y * pixelSize + pixelOffset / 2, width: pixelSize - pixelOffset, height: pixelSize - pixelOffset).fill()
        }
        
        for x in 0...board.width - 1{
            
            for y in 0...board.height - 1{
                
                numberToColor[board.board[x][y]]?.setFill()
                drawRect(x: CGFloat(x), y: CGFloat(y), size: 1.1)
                
            }
        }
        
        startColor.setFill()
        drawRect(x: board.start_pos.x, y: board.start_pos.y, size: 1)
        endColor.setFill()
        drawRect(x: board.end_pos.x, y: board.end_pos.y, size: 1)
        
        if(algo?.solution.count == 0 || !showOnlySolution){
            NSColor.red.setFill()
            for point in aStar.closed{
                drawRect(x: point.point.x, y: point.point.y, size: 0.5)
            }
            
            for point in aStar.open{
                drawRect(x: point.point.x, y: point.point.y, size: 0.5)
            }
            
            NSColor.green.setFill()
            for point in aStar.open{
                drawRect(x: point.point.x, y: point.point.y, size: 0.3)
            }
            
        }
        
        let size = CGFloat(0.2)
        let pixelOffset = pixelSize * (1 - size)
        
        
        NSColor.yellow.setFill()
        var lastPoint : NSPoint?
        
        for point in aStar.solution{
            
            if let lastPoint = lastPoint{
                let x = boardBounds.minX + min(point.x, lastPoint.x) * pixelSize + pixelOffset / 2
                let y = boardBounds.minY + min(point.y, lastPoint.y) * pixelSize + pixelOffset / 2
                
                var width = pixelSize - pixelOffset
                var height = pixelSize - pixelOffset
                
                width += pixelSize * abs(point.x - lastPoint.x)
                height += pixelSize * abs(point.y - lastPoint.y)
                
                NSRect(x: x, y: y, width: width, height: height).fill()
            }
            
            lastPoint = point//drawRect(x: point.x, y: point.y, size: 0.3)
        }
    }
}
