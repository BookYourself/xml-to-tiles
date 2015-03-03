# xml_to_tiles

Small library to convert xhtml to tiles on the fly.

## Usage

    import 'package:xml_to_tiles/xml_to_tiles.dart';

    main() {
      mountComponent(xmlToTiles('''
        <div>
          <span>
            Hello world!
          </span>
        </div>
      '''), container);
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/BookYourself/xml-to-tiles/issues
