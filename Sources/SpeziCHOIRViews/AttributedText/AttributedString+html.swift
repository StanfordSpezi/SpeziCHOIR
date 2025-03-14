//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import UIKit

// swiftlint:disable function_body_length


extension AttributedString {
    /// Converts an HTML string into an `AttributedString` with styled content, using dynamic colors and Apple's system fonts.
    @MainActor
    static func html(withBody body: String) throws -> AttributedString {
        let bundle = Bundle.main
        let lang = bundle.preferredLocalizations.first
        ?? bundle.developmentLocalization
        ?? "en"
        
        let htmlString = """
        <!doctype html>
        <html lang=\"\(lang)\">
        <head>
            <meta charset=\"utf-8\">
            <style type=\"text/css\">
                /* General body styling */
                body {
                    font: -apple-system-body;
                    color: \(UIColor.label.hex);
                    line-height: 1.6;
                }
                /* Headings */
                h1, h2, h3, h4, h5, h6 {
                    font-family: -apple-system-bold;
                    margin: 1em 0;
                }
                h1 { font-size: 2em; }
                h2 { font-size: 1.75em; }
                h3 { font-size: 1.5em; }
                h4 { font-size: 1.25em; }
                h5 { font-size: 1.1em; }
                h6 { font-size: 1em; }
                /* Inline elements */
                b, strong { font-weight: bold; }
                i, em { font-style: italic; }
                u { text-decoration: underline; }
                sup { vertical-align: super; font-size: smaller; }
                /* Links */
                a {
                    color: \(UIColor.systemGreen.hex);
                    text-decoration: none;
                }
                a:hover {
                    text-decoration: underline;
                }
                /* Lists */
                ul, ol {
                    margin: 1em 0;
                    padding-left: 2em;
                }
                li {
                    margin: 0.5em 0;
                }
                li:last-child {
                    margin-bottom: 1em;
                }
                /* Paragraphs */
                p {
                    margin: 0.75em 0;
                    color: \(UIColor.label.hex);
                }
                /* Horizontal rule */
                hr {
                    border: none;
                    border-top: 1px solid \(UIColor.separator.hex);
                    margin: 1em 0;
                }
                /* Breaks */
                br {
                    content: "";
                    display: block;
                    margin: 0.5em 0;
                }
                /* Images */
                img {
                    max-width: 100%;
                    height: auto;
                    margin: 1em 0;
                }
                /* Div and Span */
                span, div {
                    display: block;
                    margin: 0.5em 0;
                }
            </style>
        </head>
        <body>
            \(body)
        </body>
        </html>
        """
        
       guard let data = htmlString.data(using: .utf8) else {
            throw HTMLConversionError.encodingFailed
        }
        
        do {
            let nsAttributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
            var attributedString = AttributedString(nsAttributedString)
            attributedString.foregroundColor = .label
            return attributedString
        } catch {
            throw HTMLConversionError.conversionFailed(underlying: error)
        }
    }
}


// MARK: Converting UIColors into CSS friendly color hex string
extension UIColor {
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(
            format: "#%02lX%02lX%02lX%02lX",
            UInt8(red * 255),
            UInt8(green * 255),
            UInt8(blue * 255),
            UInt8(alpha * 255)
        )
    }
}
