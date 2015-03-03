// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library xml_to_tiles.test;

import 'package:unittest/unittest.dart';
import 'package:xml_to_tiles/xml_to_tiles.dart';
import 'package:tiles/tiles.dart';

main() {
  group('(XML to Tiles)', () {

    ComponentDescription result;
    DomComponent component;

    parse(String text, [Map content]) {
      result = xmlToTiles(text, content);
      component = result.createComponent();
    }

    setUp(() {

    });

    test('method exist', () {
      expect(xmlToTiles, isNotNull);
      expect(xmlToTiles is Function, isTrue);
    });

    test('should parse basic xml', () {
      parse("<img />");
      expect(component is DomComponent, isTrue);
      expect(component.tagName, equals("img"));

      parse("<input />");
      expect(component.tagName, equals("input"));

    });

    test('should parse attributes of flat xml', () {
      parse("<img src='something' />");
      expect(component.props, isNot(isEmpty));
      expect(component.props['src'], equals('something'));

      result = xmlToTiles("<input src='else'/>");
      component = result.createComponent();
      expect(component.props['src'], equals('else'));
    });

    test('should recognize pair and not pair element based on its children', () {
      parse("<img />");
      expect(component.pair, isFalse);

      parse("<div><span /></div>");
      expect(component.pair, isTrue);
    });

    test("should parse 2 layer xml", () {
      parse("<div><span></span></div>");
      expect(component.children, isNotEmpty);
      DomComponent children = component.children.first.createComponent();
      expect(children.tagName, equals("span"));
    });

    test("should parse text", () {
      parse("<div>text</div>");
      DomTextComponent children = component.children.first.createComponent();
      expect(children is DomTextComponent, isTrue);
      expect(children.props, equals("text"));
    });

    test("should parse deep attributes", () {
      parse('''
        <div>
          <div>
            <footer>
              <span class="icon">
                icontext
              </span>
            </footer>
          </div>
        </div>
      ''');
      DomComponent children = component.children[1].createComponent(); // second div
      children = children.children[1].createComponent(); // footer
      children = children.children[1].createComponent(); // span
      expect(children.props, isNotEmpty);
      expect(children.props["class"], equals("icon"));

      Component textChild = children.children.first.createComponent();

      expect(textChild is DomTextComponent, isTrue);
      expect(textChild.props, contains("icontext"));
    });

    test("should fill placeholder by content in paramether", () {
      parse('''
        <div>ahoj[placeholder]caw</div>
      ''', {
        "placeholder": span(children: "content")
      });
      Component children = component.children[0].createComponent(); // second div
      expect(children is DomTextComponent, isTrue);
      expect(children.props, equals("ahoj"));

      DomComponent children2 = component.children[1].createComponent(); // second div
      expect(children2.tagName, equals("span"));
      children = children2.children[0].createComponent(); // second div
      expect(children.props, equals("content"));

      Component children3 = component.children[2].createComponent(); // second div
      expect(children3 is DomTextComponent, isTrue);
      expect(children3.props, equals("caw"));

    });
    test("should fill placeholder in deep structure", () {
      parse('''
        <div>
          <div>
            <footer>
              <span class="icon">
                [placeholder]
              </span>
            </footer>
          </div>
        </div>
      ''', {
        "placeholder": span(props: {
          "class": "placeholder"
        }, children: "placeholder content")
      });
      DomComponent children = component.children[1].createComponent(); // second div
      children = children.children[1].createComponent(); // footer
      children = children.children[1].createComponent(); // span
      expect(children.props, isNotEmpty);
      expect(children.props["class"], equals("icon"));

      children = children.children[1].createComponent(); // placeholder span
      expect(children.props, isNotEmpty);
      expect(children.props["class"], equals("placeholder"));


      Component textChild = children.children.first.createComponent(); // placeholder content

      expect(textChild is DomTextComponent, isTrue);
      expect(textChild.props, contains("placeholder content"));
    });
  });
}
