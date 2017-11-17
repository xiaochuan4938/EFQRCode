//
//  ViewController.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/4/20.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Cocoa
import EFQRCode

class ViewController: NSViewController {

    let backgroundView: NSView = NSView()

    let leftBarView: NSView = NSView()
    let leftLineView: NSView = NSView()
    let buttonRecognize: NSImageView = EFImageView()
    let buttonGenerate: NSImageView = EFImageView()

    let imageView: NSImageView = EFImageView()

    var indexSelected = 0

    // ViewController+Recognizer
    let recognizerView = NSView()
    let recognizerViewImage: DragDropImageView = DragDropImageView()
    let recognizerViewPick: NSButton = NSButton()
    let recognizerViewScan: NSButton = NSButton()
    let recognizerViewResult: NSTextView = NSTextView()

    // ViewController+Generator
    let generatorView = NSView()
    let generatorViewImage: NSImageView = NSImageView()
    let generatorViewCreate: NSButton = NSButton()
    let generatorViewSave: NSButton = NSButton()
    let generatorViewContent: NSTextView = NSTextView()
    let generatorViewTable: NSTableView = NSTableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        addControl()
        refreshSelect()
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.view.window?.title = "EFQRCode"
    }

    func addControl() {
        backgroundView.wantsLayer = true
        backgroundView.layer?.backgroundColor = NSColor.theme.cgColor
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            (make) in
            make.top.left.right.bottom.equalTo(0)
            make.width.equalTo(600)
            make.height.equalTo(350)
        }

        backgroundView.addSubview(leftBarView)
        leftBarView.snp.makeConstraints {
            (make) in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(48)
        }

        leftLineView.wantsLayer = true
        leftLineView.layer?.backgroundColor = NSColor.white.cgColor
        backgroundView.addSubview(leftLineView)
        leftLineView.snp.makeConstraints {
            (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(leftBarView.snp.right)
            make.width.equalTo(1)
        }

        buttonRecognize.wantsLayer = true
        buttonRecognize.imageAlignment = .alignCenter
        buttonRecognize.imageScaling = .scaleAxesIndependently
        buttonRecognize.image = NSImage(named: NSImage.Name("Recognizer"))
        buttonRecognize.action = #selector(buttonRecognizeClicked)
        leftBarView.addSubview(buttonRecognize)
        buttonRecognize.snp.makeConstraints {
            (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(buttonRecognize.snp.width)
        }

        buttonGenerate.wantsLayer = true
        buttonGenerate.imageAlignment = .alignCenter
        buttonGenerate.imageScaling = .scaleAxesIndependently
        buttonGenerate.image = NSImage(named: NSImage.Name("Generator"))
        buttonGenerate.action = #selector(buttonGenerateClicked)
        leftBarView.addSubview(buttonGenerate)
        buttonGenerate.snp.makeConstraints {
            (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(buttonRecognize.snp.bottom)
            make.height.equalTo(buttonGenerate.snp.width)
        }

        imageView.imageAlignment = .alignCenter
        imageView.imageScaling = .scaleAxesIndependently
        imageView.image = NSImage(named: NSImage.Name("launchimage"))
        imageView.action = #selector(imageViewClicked)
        leftBarView.addSubview(imageView)
        imageView.snp.makeConstraints {
            (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(imageView.snp.width)
        }

        for tabView in [recognizerView, generatorView] {
            tabView.wantsLayer = true
            tabView.layer?.backgroundColor = NSColor.white.cgColor
            tabView.isHidden = true
            backgroundView.addSubview(tabView)
            tabView.snp.makeConstraints {
                (make) in
                make.top.bottom.right.equalTo(0)
                make.left.equalTo(leftLineView.snp.right)
            }
        }

        addControlRecognizer()
        addControlGenerator()
    }

    func refreshSelect() {
        let imageArray = ["Recognizer", "Generator"]
        let imageSelectedArray = ["Recognizer_D", "Generator_D"]
        let views = [recognizerView, generatorView]
        for (index, button) in [buttonRecognize, buttonGenerate].enumerated() {
            button.image = NSImage(
                named: NSImage.Name((index == indexSelected ? imageSelectedArray : imageArray)[index])
            )
            button.layer?.backgroundColor = (index == indexSelected ? NSColor.white : NSColor.theme).cgColor
            views[index].isHidden = index != indexSelected
        }
    }

    @objc func buttonRecognizeClicked() {
        if 0 != indexSelected {
            indexSelected = 0
            refreshSelect()
        }
    }

    @objc func buttonGenerateClicked() {
        if 1 != indexSelected {
            indexSelected = 1
            refreshSelect()
        }
    }

    @objc func imageViewClicked() {
        if let url = URL(string: "https://github.com/EyreFree/EFQRCode") {
            NSWorkspace.shared.open(url)
        }
    }
}

class EFImageView: NSImageView {

    override func mouseDown(with event: NSEvent) {
        if let action = self.action {
            NSApp.sendAction(action, to: self.target, from: self)
        }
    }
}
