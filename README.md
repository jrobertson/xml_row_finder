# Introducing the xml_row_finder gem

    require 'xml_row_finder'

    s = "
    <body>
      <p>testing</p>
      <rows id='r00'>
        <row id='a123'>a 123<span></span></row>
        <row id='b123'>b 123<span></span></row>
      </rows>
    </body>"


    XMLRowFinder.new(s).to_a #=> ["body/rows[@id='r00']/row[span]"] 

## Resources

* xml_row_finder https://rubygems.org/gems/xml_row_finder

xml rows row finder xmlrowfinder xpath table recordset
