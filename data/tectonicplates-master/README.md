World tectonic plates and boundaries
======================
<p align="center"><img src="example_plates.png" title="Example map using tectonic plates dataset" alt="Example map using tectonic plates dataset" /></p>
This is a conversion of the dataset originally published in the paper _An updated digital model of plate boundaries_ by Peter Bird (Geochemistry Geophysics Geosystems, 4(3), 1027, [doi:10.1029/2001GC000252](http://scholar.google.se/scholar?cluster=1268723667321132798), 2003).
To bring this dataset into the modern age, the original data has been parsed, cleaned and verified using ArcGIS 10.2 and converted to shape files.
The dataset presents tectonic plates and their boundaries, and in addition orogens and information about the boundaries.
The data is useful for geological applications, analysis and education, and should be easy to use in any modern GIS software application.
For information on the fields and values, please refer to the [original](original) documentation and the scientific article.

Now with [GeoJSON](GeoJSON) data, courtesy of [csterling](https://github.com/csterling) - Thanks! (note that this data can be previewed directly in the github webinterface)

Download
-----
To get access to the full database, [download the zip-archive of all the data (some 5 MB)](https://github.com/fraxen/tectonicplates/archive/master.zip), or clone this repo using your favorite git tool.

Source data
-----
The data was downloaded from [http://peterbird.name/oldFTP/PB2002/](http://peterbird.name/oldFTP/PB2002/) in June 2014. A copy of the original data is available in the _[original](original)_ folder of this repo, with some very minor updates.

License
----
This collection is made available under the Open Data Commons Attribution License: [http://opendatacommons.org/licenses/by/1.0/](http://opendatacommons.org/licenses/by/1.0/), please refer to [LICENSE.md](LICENSE.md) for more information.
Please consider giving Hugo Ahlenius, Nordpil and Peter Bird credit and recognition as a data source.

Process
-----
All the original data were retrieved from http://peterbird.name/oldFTP/PB2002/ in June 2014 and parsed using Python and Global Mapper 11. Further data manipulation was performed in ArcGIS 10.2.
The main edits regarded segments spanning the -180/180 boundary, which had to be manually split and moved.

Finishing words
------
This work was performed by Hugo Ahlenius, and I am consultant specializing in GIS and cartography, you can read more about me and my services at [http://nordpil.com](http://nordpil.com).
I wish to extend a warm *thanks!* to Peter Brid team for creating such a wonderful resource!
Also thanks to [csterling](https://github.com/csterling) for preparing GeoJSON format data.
Please note anything that can be improved in the data, feel free to contribute, and just let me know if there is anything unclear.
