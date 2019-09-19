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
    var timer = Timer()
    
    // what to draw
    
    private var board = Array(repeating: Array(repeating: 1, count: 40), count: 80)
    private(set) var boardHeight = 40
    private(set) var boardWidth = 80
    private var start_pos: NSPoint?
    private var end_pos: NSPoint?

    // how fast to draw
    private(set) var iterationsPerFrame = 1
    private(set) var speed = 25.0
    
    var showOnlySolution = true
    
    // where to draw
    var boardBounds : NSRect?
    var pixelSize : CGFloat?
    
    // info
    var isResizing = false
    var needsResizing = true
    var isDragging = false
    
    var lastCell = NSPoint(x:0, y:0)
    
    // colors
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
    
    // when the user starts resizing window
    override func viewWillStartLiveResize() {
        isResizing = true
    }

    // when the user stops resizing window
    override func viewDidEndLiveResize() {
        isResizing = false
    }
    
    override func mouseDown(with event: NSEvent) {
        reset()
        handleLeftClick(point: event.locationInWindow)
        isDragging = true
    }
    
    override func mouseUp(with event: NSEvent) {
        isDragging = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        handleLeftClick(point: event.locationInWindow)
    }
    
    func handleLeftClick(point : NSPoint){
        guard let rect = boardBounds, let size = pixelSize else{
            return
        }

        let point = convert(point, from: nil)
        
        if(!rect.contains(point)){
            return
        }
        
        let (x, y) = convertToCellCoordinates(locationInView: point, boardBounds: rect, pixelSize: size)
        
        onCellClicked(x: x, y: y)
        needsDisplay = true
    }
    
    func setIterationsPerFrame(_ steps: Int){
        if(steps > 0){
            self.iterationsPerFrame = steps
        }
    }
    
    func setFrameSpeed(_ speed : Double){
        
        if(speed >= 0){
            self.speed = speed
        }
        
        if(timer.isValid){
            initiateTimer()
        }
    }
    
    func convertToCellCoordinates(locationInView: NSPoint, boardBounds: NSRect, pixelSize: CGFloat) -> (Int, Int){
        
        let x = Int((CGFloat(locationInView.x) - boardBounds.minX) / pixelSize)
        let y = Int((CGFloat(locationInView.y) - boardBounds.minY) / pixelSize)
        
        return (x, y)
    }

    func onCellClicked(x: Int, y: Int){
        if start_pos == nil {
            start_pos = NSPoint(x: x, y: y)
            return
        }
        if end_pos == nil {
            end_pos = NSPoint(x: x, y: y)
            return
        }
        
        let clickValue = -1
        
        if(isDragging){
            let newCell = NSPoint(x:x, y:y)
            drawLine(from: lastCell, to: newCell, with: clickValue)
            lastCell = newCell
        }else{
            board[x] [y] = board[x][y] == 1 ? -1 : 1
            lastCell = NSPoint(x: x, y: y)
        }
    }
    
    func drawLine(from: NSPoint, to: NSPoint, with: Int){
        let difX = to.x - from.x
        let difY = to.y - from.y
        
        let nCells = max(abs(difX), abs(difY))
        
        if(nCells == 0){
            return
        }
        
        let stepX = difX / nCells
        let stepY = difY / nCells
        
        for i in 0...Int(nCells){
            let floatI = CGFloat(i)
            let x = Int(round(from.x + floatI * stepX))
            let y = Int(round(from.y + floatI * stepY))
            board[x][y] = with
        }
    }
    
    func execute(_ nameOfAlgo: String){
        
        initiateAlgorithm(nameOfAlgo: nameOfAlgo)
        
        guard let algo = algo else{
            fatalError("Call initiateAlgorithm first")
        }
        
        if(algo.execute()){
            needsDisplay = true
        }
        else{
            // show alert, no path found
        }
        
    }
    
    func step() -> Bool {
        guard let algo = algo else{
            fatalError("Call initiateAlgorithm first")
        }
        needsDisplay = true
        return algo.step()
    }
    
    fileprivate func initiateTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: (50 - self.speed) / 100, repeats: true, block: { _ in
            for _ in 1...self.iterationsPerFrame{
                if(!self.step()){
                    self.timer.invalidate()
                    break
                }
            }
        })
    }
    
    func startAnimation(_ nameOfAlgo: String){
        initiateAlgorithm(nameOfAlgo: nameOfAlgo)
        
        initiateTimer()
    }
    
    private func initiateAlgorithm(nameOfAlgo: String){
        
        guard let start = start_pos, let end = end_pos else{
            // to be changed with visual error
            fatalError("Gotta pick start and end pos")
            //return
        }
        
        switch nameOfAlgo {
        case String(describing: AStar.self):
            algo = AStar(board: board, start: start, end: end)
        case String(describing: Dijkstra.self):
            algo = Dijkstra(board: board, start: start, end: end)
        case String(describing: Bfs.self):
            algo = Bfs(board: board, start: start, end: end)
        default:
            // not sure what to do here
            fatalError("Algorithm must be added to switch case: " + nameOfAlgo)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let a = DispatchTime.now()
        
        if (isResizing || needsResizing || pixelSize == nil){
            pixelSize = min(bounds.width / CGFloat(boardWidth), bounds.height / CGFloat(boardHeight))
            
            let boardBoundsWidth = CGFloat(boardWidth) * pixelSize!
            let boardBoundsHeight = CGFloat(boardHeight) * pixelSize!
            
            let offsetX = bounds.width / 2.0 - boardBoundsWidth / 2
            let offsetY = bounds.height / 2.0 - boardBoundsHeight / 2
            
            boardBounds = NSRect(x: offsetX, y: offsetY, width: boardBoundsWidth, height: boardBoundsHeight)
            
            needsResizing = false
        }
        
        guard let pixelSize = pixelSize, let boardBounds = boardBounds else{
            fatalError()
        }
        
        func drawRect(x: CGFloat, y:CGFloat, size: CGFloat){
            
            let pixelOffset = pixelSize * (1 - size)
            
            NSRect(x: boardBounds.minX + x * pixelSize + pixelOffset / 2, y: boardBounds.minY + y * pixelSize + pixelOffset / 2, width: pixelSize - pixelOffset, height: pixelSize - pixelOffset).fill()
        }
        
        for x in 0...board.count - 1{
            
            for y  in 0...board[x].count - 1{
                
                numberToColor[board[x][y]]?.setFill()
                drawRect(x: CGFloat(x), y: CGFloat(y), size: 1.1)
                
            }
        }
        
        if let start = start_pos {
            startColor.setFill()
            drawRect(x: start.x, y: start.y, size: 1)
        }
        
        if let end = end_pos {
            endColor.setFill()
            drawRect(x: end.x, y: end.y, size: 1)
        }
        
        guard let algo = algo else{
            let b = DispatchTime.now()
            print((b.uptimeNanoseconds - a.uptimeNanoseconds) / 1_000_000)
            return
        }
        if(algo.solution.count == 0 || !showOnlySolution){
            NSColor.red.setFill()
            for point in algo.closed{
                drawRect(x: point.point.x, y: point.point.y, size: 0.5)
            }

            for point in algo.open{
                drawRect(x: point.point.x, y: point.point.y, size: 0.5)
            }

            NSColor.green.setFill()
            for point in algo.open{
                drawRect(x: point.point.x, y: point.point.y, size: 0.3)
            }
        
         }
        
        let size = CGFloat(0.2)
        let pixelOffset = pixelSize * (1 - size)


        NSColor.yellow.setFill()
        var lastPoint : NSPoint?

        for point in algo.solution{

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
    
    func reset(){
        timer.invalidate()
        algo = nil
        needsDisplay = true
    }
    
}
