// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library xml_to_tiles.base;

import 'package:tiles/tiles.dart';
import 'package:xml/xml.dart';

ComponentDescription xmlToTiles(String xml, [Map<String, ComponentDescription> placeholders]) {
  var document = parse(xml);

  XmlElement root = document.rootElement;

  return _parseNode(root, placeholders);
}

_parseNode(XmlNode node, [Map<String, ComponentDescription> placeholders]) {

  if (node is XmlElement) return _parseElement(node, placeholders);
  if (node is XmlText) return _parseText(node, placeholders);
}

ComponentDescription _parseElement(XmlElement element, [Map<String, ComponentDescription> placeholders]) {
  Map<String, String> attrs = {};
  element.attributes.forEach((XmlAttribute attribute) => attrs[attribute.name.local] = attribute.value);

  return _registerDomComponent(element.name.local, pair: element.children.length > 0)(props: attrs, children: _parseChildren(element, placeholders));
}

_parseChildren(XmlElement element, [Map<String, ComponentDescription> placeholders]) {
  List flatChildren = [];
  var parsedChildren = element.children.map((node) => _parseNode(node, placeholders));
  
  parsedChildren.forEach((child) {
    if(child is List) {
      flatChildren.addAll(child);
    } else {
      flatChildren.add(child);
    }
  });
  return flatChildren;
}

_parseText(XmlText text, [Map<String, ComponentDescription> placeholders]) {
  if (text.text.contains(_placeholerRegex)) {
    return _parsePlaceholders(text, placeholders);
  }
  return _domTextComponentDescriptionFactory(props: text.text);
}

_parsePlaceholders(XmlText text, [Map<String, ComponentDescription> placeholders]) {
  num start = 0;
  List components = [];
  _placeholerRegex.allMatches(text.text).forEach((Match match) {
    components.add(text.text.substring(start, match.start));
    var key = match.group(0).replaceAll(new RegExp(r"[\[\]]"), "");
    components.add(placeholders[key]);
    start = match.end;
  });
  components.add(text.text.substring(start));
  return components;
}

ComponentDescriptionFactory _registerDomComponent(String tagname, {bool pair, bool svg: false, ComponentFactory factory}) {

  if (factory == null) {
    /**
     * create default factory which create DomComponent
     */
    factory = ({Map props, List<ComponentDescription> children}) => new DomComponent(props: props, children: children, tagName: tagname, pair: pair, svg: svg);
    ;
  }

  return registerComponent(factory);
}

ComponentDescriptionFactory _domTextComponentDescriptionFactory = registerComponent(({String props, children}) => new DomTextComponent(props));
RegExp _placeholerRegex = new RegExp(r"\[[^\[\]]*\]");
