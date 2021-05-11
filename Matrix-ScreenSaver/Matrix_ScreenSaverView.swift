//
//  Matrix_ScreenSaverView.swift
//  Matrix-ScreenSaver
//
//  Created by Sam Wong on 11/5/2021.
//

import ScreenSaver

class Matrix_ScreenSaverView: ScreenSaverView {
    var chars: [Character]
    var onPreview: Bool
    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        chars = [
            Character(frame: frame, isPreview: isPreview)
        ]
        self.onPreview = isPreview
        super.init(frame: frame, isPreview: isPreview)
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func draw(_ rect: NSRect) {
        drawBackground(.black)
        drawCharacter()
        // Draw a single frame in this function
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        var idx = 0
        for char in chars {
            char.move()
            idx += 1
            if char.lifespan <= 0 {
                chars.remove(at: idx)
            }
        }
        
        if self.onPreview {
            chars.append(Character(frame: bounds, isPreview: true))
        } else {
            for _ in 1 ... 3 {
                chars.append(Character(frame: bounds, isPreview: false))
            }
        }
        
        setNeedsDisplay(bounds)
        // Update the "state" of the screensaver in this function
    }

    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }
    
    private func drawCharacter() {
        for char in chars {
            char.draw()
        }
    }
}

class Character: NSObject {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789あアかカさサたタなナはハまマやヤらラわワいイきキしシちチにニひヒみミりリゐヰうウくクすスつツぬヌふフむムゆユるルえエけケせセてテねネへヘめメれレゑヱおオこコそソとトのノほホもモよヨろロをヲんンゃゅょ"
    public var X: CGFloat
    public var Y: CGFloat
    public var char: String = "X"
    public var lifespan: Int = 50
    public var speed: Int = 10
    private var frame: NSRect
    private var totalLifespan: Int = 50
    private var special: Bool = false
    private var isPreview: Bool = false
    
    init (frame: NSRect, isPreview: Bool) {
        X = CGFloat.random(in: frame.minX ... frame.maxX)
        Y = CGFloat.random(in: frame.minY ... frame.maxY) // frame.maxY // frame.midY
        lifespan = Int.random(in: 100 ... 200)
        totalLifespan = lifespan
        speed = Int.random(in: 12 ... 24)
        if Double.random(in: 0 ... 1) >= 0.99 {
            char = "NEO, PICK UP THE PHONE"
            special = true
        } else {
            char = String(letters.randomElement()!)
        }
        self.frame = frame
        self.isPreview = isPreview
    }
    
    public func draw() {
        var idx = 0
        for letter in char {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: NSColor(red: 0, green: 1, blue: 0, alpha: CGFloat(lifespan) / CGFloat(totalLifespan)),
                .font: NSFont.systemFont(ofSize: self.isPreview ? 6 : 12)
            ]
            let attrChar = NSAttributedString(string: String(letter), attributes: attributes)
            let location = NSPoint(x: X, y: Y - CGFloat(idx) * CGFloat(speed))
            
            guard let gc = NSGraphicsContext.current else { return }
            gc.saveGraphicsState()
            defer {
                gc.restoreGraphicsState()
            }
            gc.cgContext.translateBy(x: frame.origin.x + frame.size.width, y: frame.origin.y)
            gc.cgContext.scaleBy(x: -1, y: 1)
            attrChar.draw(at: location)
            idx += 1
        }
    }
    
    public func move() {
        X += 0 // CGFloat.random(in: -10 ... 10)
        Y -= 0 // CGFloat(speed) // CGFloat.random(in: -10 ... 10)
        lifespan -= 1
        if (lifespan % 12 == 0 && !special) {
            char += String(letters.randomElement()!)
        }
    }
}
