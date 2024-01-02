//
//  Matrix_ScreenSaverView.swift
//  Matrix-ScreenSaver
//
//  Created by Sam Wong on 11/5/2021.
//  Updated by Sam Wong on 30/12/2023.
//

import ScreenSaver
import Cocoa

class Matrix_ScreenSaverView: ScreenSaverView {
    var chars: [Character?]
    var onPreview: Bool
    var inFrame: NSRect
    var timer: Timer? = nil
    var noOfLines: Int = 100
    var message: String = "NEO, PICK UP THE PHONE"
    
    var screenSaverDefaults: ScreenSaverDefaults

    lazy var configureWindowController: ConfigureWindowController = ConfigureWindowController()
    
    override var hasConfigureSheet: Bool { get { true }}
    
    override var configureSheet: NSWindow? { get {

        return configureWindowController.window
    }}
    
    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        inFrame = frame
        chars = [
            // Character(frame: inFrame, isPreview: isPreview)
        ]
        onPreview = isPreview
        screenSaverDefaults = ScreenSaverDefaults(forModuleWithName: Bundle.main.bundleIdentifier!) ?? ScreenSaverDefaults()
        
        super.init(frame: inFrame, isPreview: isPreview)
//        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: onTimer)
        
//        if (screenSaverDefaults.string(forKey: "message") != nil) {
//            message = screenSaverDefaults.string(forKey: "message")!
//        }
//
//        if (screenSaverDefaults.integer(forKey: "noOfLines") != 0) {
//            noOfLines = screenSaverDefaults.integer(forKey: "noOfLines")
//        }
    }
    
    deinit {
//        timer?.invalidate()
//        timer = nil
        chars.removeAll()
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func draw(_ rect: NSRect) {
        // drawBackground(.black)
        drawCharacter()
        // Draw a single frame in this function
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        updateChars()
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
//        updateChars()
    }
    
    private func updateChars() {
        var idx = 0
        
        screenSaverDefaults.synchronize()
        
        if (screenSaverDefaults.string(forKey: "message") != nil) {
            message = screenSaverDefaults.string(forKey: "message")!
        }
        
        if (screenSaverDefaults.integer(forKey: "noOfLines") != 0) {
            noOfLines = screenSaverDefaults.integer(forKey: "noOfLines")
        }
        
        for char in self.chars {
            char!.move()
            if (char!.Y < self.inFrame.minY - 100) {
//                char!.reset()
//                if char!.special == true {
//                    char!.char = message
//                }
                self.chars.remove(at: idx)
            } else {
                idx += 1
            }
        }
        
        if self.onPreview {
            for _ in 1 ... Int.random(in: 1 ... 5) {
                if self.chars.count < noOfLines {
                    let character = Character(frame: self.inFrame, isPreview: true)
                    if character.special == true {
                        character.char = message
                    }
                    self.chars.append(character)
                }
            }
        } else {
            for _ in 1 ... Int.random(in: 1 ... 5) {
                if self.chars.count < noOfLines {
                    let character = Character(frame: self.inFrame, isPreview: false)
                    if character.special == true {
                        character.char = message
                    }
                    self.chars.append(character)
                }
            }
        }
    }
}

class Character: NSObject {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789あアかカさサたタなナはハまマやヤらラわワいイきキしシちチにニひヒみミりリゐヰうウくクすスつツぬヌふフむムゆユるルえエけケせセてテねネへヘめメれレゑヱおオこコそソとトのノほホもモよヨろロをヲんンゃゅょ"
    public var X: CGFloat
    public var Y: CGFloat
    public var char: String = ""
    public var lifespan: Float = 50
    public var speed: Float = 10
    private var frame: NSRect
    private var totalLifespan: Float = 50
    public var special: Bool = false
    private var isPreview: Bool = false
    private let fontSize: Int = 12
    
    init (frame: NSRect, isPreview: Bool) {
        X = CGFloat(Int(CGFloat.random(in: frame.minX ... frame.maxX) / CGFloat(fontSize)) * fontSize)
        Y = CGFloat.random(in: frame.maxY ... frame.maxY + 50) // frame.maxY // frame.midY
        speed = Float.random(in: 2 ... 12)
        lifespan = Float.random(in: 300 ... 500)
        totalLifespan = lifespan
        if Double.random(in: 0 ... 1) >= 0.99 {
            char = ""
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
        lifespan = Float.random(in: 300 ... 500)
        totalLifespan = lifespan
        char = ""
        if Double.random(in: 0 ... 1) >= 0.99 {
            char = ""
            special = true
        } else {
            for _ in 5 ... Int.random(in: 6 ... 20) {
                char += String(letters.randomElement()!)
            }
        }
    }
    
    public func draw() {
        if (self.Y < self.frame.minY) {
            return
        }
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

class ConfigureWindowController: NSObject {
    
    @IBOutlet weak var textLines: NSTextField!
    @IBOutlet weak var textMesssage: NSTextField!
    @IBOutlet weak var stepper: NSStepper!
    @IBOutlet var window: NSWindow?
    
    var screenSaverDefaults: ScreenSaverDefaults = ScreenSaverDefaults(forModuleWithName: Bundle.main.bundleIdentifier!) ?? ScreenSaverDefaults()
    
    var configuration = Configuration()
    
    override init() {
        super.init()
        let myBundle = Bundle(for: ConfigureWindowController.self)
        myBundle.loadNibNamed("ConfigureWindow", owner: self, topLevelObjects: nil)
        
        if (screenSaverDefaults.string(forKey: "message") != nil) {
            configuration.message = screenSaverDefaults.string(forKey: "message")!
        }
        
        if (screenSaverDefaults.integer(forKey: "noOfLines") > 0) {
            configuration.noOfLines = screenSaverDefaults.integer(forKey: "noOfLines")
        }
        
        textLines.integerValue = configuration.noOfLines
        textMesssage.stringValue = configuration.message
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonCancelClicked(_ sender: Any) {
        window?.sheetParent?.endSheet(window!)
    }
    
    @IBAction func buttonSaveClicked(_ sender: Any) {
        if textLines.integerValue > 0 {
            configuration.noOfLines = textLines.integerValue
        }
        configuration.message = textMesssage.stringValue
        
        screenSaverDefaults.setValue(configuration.noOfLines, forKey: "noOfLines")
        screenSaverDefaults.setValue(configuration.message, forKey: "message")
        screenSaverDefaults.synchronize()
        
        window?.sheetParent?.endSheet(window!)
    }
    @IBAction func textLinesChanged(_ sender: Any) {
        let textField = sender as! NSTextField
        if textField.integerValue > 150 {
            textField.integerValue = 150
        }
        stepper.integerValue = textField.integerValue
    }
}

class Configuration {
    var noOfLines: Int = 0
    var message: String = ""
}
