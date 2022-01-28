#!/usr/bin/env ruby

# file: xml_row_finder.rb

require 'nokorexi'


class XMLRowFinder

  attr_reader :to_a

  def initialize(raws, debug: false)

    @debug = debug

    doc = Nokorexi.new(raws, filter: true).to_doc

    @doc = Rexle.new(doc.root.xml)

    a = []

    doc.root.each_recursive do |e|
      e.attributes.delete
      a << e.backtrack.to_xpath
    end

    @to_a = a2 = a.map {|e| [a.count(e), e] }.uniq
    xpath = a2.max_by(&:first).last

    a3 = xpath.split('/')
    a4 = [xpath]
    p1 = []

    until (a3.length < 1) do
      p1 << a3.pop; a4 << a3.join('/') + "[%s]" % p1.reverse.join('/')
    end

    # using Nokogiri since Rexle has a bug with xpath predicates
    #
    @doc2 = Nokogiri::XML(doc.root.xml)

    a5 = a4[0..-2].map do |xpath2|
      [@doc2.xpath(xpath2).length, xpath2]
    end

    puts 'a5: ' + a5.inspect if @debug
    rows_xpath = a5.reverse.detect {|num, xpath2| num > 1}.last
    doc3 = Document.new @doc.root.xml
    @rows = XPath.match(doc3, rows_xpath)
    @xpath = rows_xpath
    #@xpath = BacktrackXPath.new(@rows.first).to_xpath.gsub("[@class='']",'')

    last_row = XPath.match(doc3, @xpath).last
    puts '@xpath: ' + @xpath.inspect

    # find the container element
    xpath = @xpath[/^[^\[]+/]
    axpath = xpath.split('/')

    e = XPath.first(doc3, xpath)
    puts 'e: ' + e.to_s

    until (e.nil? or e.to_s.include?(last_row.to_s)) do
      axpath.pop
      e = XPath.first(doc3, axpath.join('/'))
    end

    @cont_xpath = axpath.join('/')

  end

  # returns the container element for all rows
  #
  def body()
    Rexle.new(@doc.element(@cont_xpath).xml)
  end

  # returns the xpath pointing to the container element for all rows
  #
  def body_xpath()
    @cont_xpath
  end

  # returns rows
  # object returned: An array of Nokogiri XML Element object
  #
  def rows()
    @rows
  end

  # returns the xpath pointing to the rows
  #
  def to_xpath()
    @xpath
  end

  alias rows_xpath to_xpath


end
