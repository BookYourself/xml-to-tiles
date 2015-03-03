// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library xml_to_tiles.example;

import 'package:xml_to_tiles/xml_to_tiles.dart';
import 'package:tiles/tiles_browser.dart';
import 'package:tiles/tiles.dart';
import 'dart:html';

main() {
  Element container = querySelector("#container");
  
  mountComponent(xmlToTiles('''
    <div>
      <h1>H1</h1>
      <h2>H2</h2>
      <h3>H3</h3>
      <h4>H4</h4>
      <h5>H5</h5>
      <h6>H6</h6>
      <span>span</span>
      <div>[placeholder1]</div>
      <div><h2>[placeholder2]</h2></div>
      <img src="http://www.artista-me.com/wp-content/uploads/2014/05/Metallic_Mosaic_Tiles.jpg" />
    </div>
  ''', {
    "placeholder1": input(props: {
      "type": "text", 
      "placeholder": "Hello this is placeholder"
    }),
    "placeholder2": h1(children: "Hello this is placeholder 2"),    
  }), container);
}