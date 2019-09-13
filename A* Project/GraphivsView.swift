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
    
    var boardBounds : NSRect?
    var pixelSize : CGFloat?
    var clickCounter = 0
    var isResizing = false
    var needsResizing = true
    
    var showOnlySolution = true
    
    let startColor = NSColor(red: 1, green: 0, blue: 1, alpha: 1)
    let endColor = NSColor(red: 0, green: 0.5, blue: 1, alpha: 1)
    
    let numberToColor = [
        -1 : NSColor.red,
        1 : NSColor(red: 0.843, green: 0.843, blue: 0.843, alpha: 1),
        2 : NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
        3 : NSColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),
        4 : NSColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1),
        5 : NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
    ]
    
    override func viewWillStartLiveResize() {
        isResizing = true
    }
    
    override func viewDidEndLiveResize() {
        isResizing = false
    }
    
    
    func loadAlgorithm(_ algo: IAlgorithm){
        self.algo = algo;
        needsResizing = true
        self.needsDisplay = true
    }
    
    override func mouseDown(with event: NSEvent) {
        drawDot(point: event.locationInWindow)
    }
    
    override func mouseDragged(with event: NSEvent) {
        drawDot(point: event.locationInWindow)
    }
    
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
        
        if(clickCounter % 2 == 0){
            algorithm.setStartPos(x: x, y: y)
        }else{
            algorithm.setEndPos(x: x, y: y)
        }
        clickCounter += 1
        needsDisplay = true
    }
    
    func calculatePhysicalMeasurements(){
        guard let aStar = algo else{
            fatalError("An algorithm should be loaded")
        }
        
        let boardWidth = CGFloat(aStar.boardWidth), boardHeight = CGFloat(aStar.boardHeight)
        
        pixelSize = min(bounds.width / boardWidth, bounds.height / boardHeight)
        
        let realBoardWidth = boardWidth * pixelSize!
        let realBoardHeight = boardHeight * pixelSize!
        
        let offsetX = bounds.width / 2.0 - realBoardWidth / 2
        let offsetY = bounds.height / 2.0 - realBoardHeight / 2
        
        boardBounds = NSRect(x: offsetX, y: offsetY, width: realBoardWidth, height: realBoardHeight)
        
        needsResizing = false
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        guard let aStar = algo else{
            fatalError("An algorithm should be loaded")
        }
        
        if (isResizing || needsResizing || pixelSize == nil){
            calculatePhysicalMeasurements()
        }
        
        guard let pixelSize = pixelSize, let boardBounds = boardBounds else{
            fatalError()
        }
        
        func drawRect(x: CGFloat, y:CGFloat, size: CGFloat){
            
            let pixelOffset = pixelSize * (1 - size)
            
            NSRect(x: boardBounds.minX + x * pixelSize + pixelOffset / 2, y: boardBounds.minY + y * pixelSize + pixelOffset / 2, width: pixelSize - pixelOffset, height: pixelSize - pixelOffset).fill()
        }
        
        for x in 0...aStar.boardWidth - 1{
            
            for y in 0...aStar.boardHeight - 1{
                
                numberToColor[aStar.get(x, y)]?.setFill()
                drawRect(x: CGFloat(x), y: CGFloat(y), size: 1.1)
                
            }
        }
        
        startColor.setFill()
        drawRect(x: aStar.startPos.x, y: aStar.startPos.y, size: 1)
        endColor.setFill()
        drawRect(x: aStar.endPos.x, y: aStar.endPos.y, size: 1)
        
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
            
            //drawRect(x: point.x, y: point.y, size: 0.3)
            lastPoint = point//drawRect(x: point.x, y: point.y, size: 0.3)
        }
    }
}
