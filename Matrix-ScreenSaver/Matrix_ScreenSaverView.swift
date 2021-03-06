//
//  Matrix_ScreenSaverView.swift
//  Matrix-ScreenSaver
//
//  Created by Sam Wong on 11/5/2021.
//

import ScreenSaver

class Matrix_ScreenSaverView: ScreenSaverView {
    var chars: [Character?]
    var onPreview: Bool
    var inFrame: NSRect
    var timer: Timer? = nil
    
    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        inFrame = frame
        chars = [
            // Character(frame: inFrame, isPreview: isPreview)
        ]
        onPreview = isPreview
        super.init(frame: inFrame, isPreview: isPreview)
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: onTimer)
    }
    
    deinit {
       timer = nil
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
            char!.draw()
        }
    }
    
    private func onTimer(timer: Timer) {
        var idx = 0
        for char in self.chars {
            char!.move()
            idx += 1
            if (char!.Y < self.inFrame.minY - 100) {
                //  self.chars.remove(at: idx)
                char!.reset()
                // char = nil
            }
        }
        
        if self.onPreview {
            for _ in 1 ... Int.random(in: 1 ... 5) {
                if self.chars.count <= 200 {
                    self.chars.append(Character(frame: self.inFrame, isPreview: true))
                }
            }
        } else {
            for _ in 1 ... Int.random(in: 1 ... 5) {
                if self.chars.count <= 200 {
                    self.chars.append(Character(frame: self.inFrame, isPreview: false))
                }
            }
        }
    }
}

class Character: NSObject {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"
    public var X: CGFloat
    public var Y: CGFloat
    public var char: String = ""
    public var lifespan: Float = 50
    public var speed: Float = 10
    private var frame: NSRect
    private var totalLifespan: Float = 50
    private var special: Bool = false
    private var isPreview: Bool = false
    private let fontSize: Int = 12
    
    init (frame: NSRect, isPreview: Bool) {
        X = CGFloat(Int(CGFloat.random(in: frame.minX ... frame.maxX) / CGFloat(fontSize)) * fontSize)
        Y = CGFloat.random(in: frame.maxY ... frame.maxY + 50) // frame.maxY // frame.midY
        speed = Float.random(in: 2 ... 12)
        lifespan = Float.random(in: 100 ... 500)
        totalLifespan = lifespan
        if Double.random(in: 0 ... 1) >= 0.99 {
            char = "NEO, PICK UP THE PHONE"
            special = true
        } else {
            for _ in 5 ... Int.random(in: 6 ... 20) {
                char += String(letters.randomElement()!)
            }
        }
        self.frame = frame
        self.isPreview = isPreview
    }
    
    deinit {

    }
    
    public func reset() {
        X = CGFloat(Int(CGFloat.random(in: frame.minX ... frame.maxX) / CGFloat(fontSize)) * fontSize)
        Y = CGFloat.random(in: frame.maxY ... frame.maxY + 50) // frame.maxY // frame.midY
        speed = Float.random(in: 2 ... 12)
        lifespan = Float.random(in: 100 ... 500)
        totalLifespan = lifespan
        char = ""
        if Double.random(in: 0 ... 1) >= 0.99 {
            char = "NEO, PICK UP THE PHONE"
            special = true
        } else {
            for _ in 5 ... Int.random(in: 6 ... 20) {
                char += String(letters.randomElement()!)
            }
        }
    }
    
    public func draw() {
        var idx = char.count
        for letter in char.reversed() {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: idx == char.count ? NSColor(red: 0.75, green: 1, blue: 0.75, alpha: 1) : NSColor(red: 0, green: 1, blue: 0, alpha: CGFloat(lifespan) * CGFloat(Double(idx/char.count) < 0.5 ? char.count / 2 : idx) / (CGFloat(totalLifespan) * CGFloat(char.count))),
                .font: NSFont.systemFont(ofSize: CGFloat(self.isPreview ? fontSize / 2 : fontSize))
            ]
            let attrChar = NSAttributedString(string: String(letter), attributes: attributes)
            let location = NSPoint(x: X, y: Y - CGFloat(idx) * CGFloat(fontSize))
            
            guard let gc = NSGraphicsContext.current else { return }
            gc.saveGraphicsState()
            //defer {
            //    gc.restoreGraphicsState()
            //}
            if !special {
                gc.cgContext.translateBy(x: frame.origin.x + frame.size.width, y: frame.origin.y)
                gc.cgContext.scaleBy(x: -1, y: 1)
            }
            attrChar.draw(at: location)
            gc.restoreGraphicsState()
            idx -= 1
        }
    }
    
    public func move() {
        X += 0 // CGFloat.random(in: -10 ... 10)
        Y -= CGFloat(speed) // CGFloat.random(in: -10 ... 10)
        lifespan -= speed * 0.1
        if (Int(lifespan) % 6 == 0 && !special) {
            char += String(letters.randomElement()!)
        }
    }
}
