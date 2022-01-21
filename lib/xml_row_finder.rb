#!/usr/bin/env ruby

# file: xml_row_finder.rb

require 'rexle'
require 'rexml'
include REXML


class XMLRowFinder

  attr_reader :to_a

  def initialize(s, debug: false)

    @debug = debug
    doc = Rexle.new(s)

    a = []

    doc.root.each_recursive do |e|
      e.attributes.delete
      a << e.backtrack.to_xpath
    end

    a2 = a.select{ |e| a.count(e) > 1 }.map {|x| x.split('/')}.uniq

    # remove parent nodes on the same branch
    #
    a2.reject!.with_index do |x,i| 
      next if i == a2.length-1
      x == a2[i+1][0..-2]
    end

    # remove elements from rows which only exist once in the document
    #
    a3 = a2.map do |row|
      row.reject do |x|
        found = doc.root.xpath('//' + x)
        found.length < 2
      end
    end

    # add parent node to the row as a reference for the xpath
    #
    a4 = a3.map.with_index do |row,i|
      a2[i][-(row.length+1)..-1]
    end

    # find the parent node attributes
    #
    @to_a = a4.map do |col|

      # currently using REXML for this XPath since there is a bug in 
      #   Rexle when attempting the following
      # 
      doc2 = Document.new(s)
      xpath = "//%s[%s]" % [col[0], col[1..-1].join('/')]
      puts 'xpath: ' + xpath.inspect if @debug
      r = XPath.first(doc2, xpath)
      xpath_a = BacktrackXPath.new(r).to_xpath

      if col.length >= 3
        "%s/%s[%s]" % [xpath_a, col[1], col[2..-1].join('/')]
      else
        "%s/%s" % [xpath_a, col[1]]
      end
    end
    
  end

end

