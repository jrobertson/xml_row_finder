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
    @doc2 = Document.new(s)

    a = []

    doc.root.each_recursive do |e|
      e.attributes.delete
      a << e.backtrack.to_xpath
    end

    @to_a = a2 = a.map {|e| [a.count(e), e] }
    xpath = a2.max_by(&:first).last

    a3 = xpath.split('/')
    a4 = [xpath]
    p1 = []

    until (a3.length < 1) do
      p1 << a3.pop; a4 << a3.join('/') + "[%s]" % p1.reverse.join('/')
    end

    a5 = a4[0..-2].map do |xpath2|
      [XPath.match(@doc2, xpath2).length, xpath2]
    end

    @xpath = a5.reverse.detect {|num, xpath2| num > 1}.last

  end

  def rows()
    XPath.match(@doc2, @xpath)
  end

  def to_xpath()
    @xpath
  end

end
