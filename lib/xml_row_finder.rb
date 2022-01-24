#!/usr/bin/env ruby

# file: xml_row_finder.rb

require 'nokorexi'


class XMLRowFinder

  attr_reader :to_a

  def initialize(raws, debug: false)

    @debug = debug

    doc = if raws =~ /^http/ then

      nki = Nokorexi.new(url=raws) do |doc1|
        doc1.xpath('//*[@onclick]').each do |e|
          e.attributes['onclick'].value = ''
        end

        doc1.xpath('//*[@onmousedown]').each do |e|
          e.attributes['onmousedown'].value = ''
        end

      end

      nki.to_doc

    else
      Rexle.new(raws)
    end

    @doc = Rexle.new(doc.xml)

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

    @xpath = a5.reverse.detect {|num, xpath2| num > 1}.last

    last_row = @doc2.xpath(@xpath).last

    # find the container element
    xpath = @xpath[/^[^\[]+/]
    axpath = xpath.split('/')
    e = doc.element xpath

    until (e.xml.include? last_row) do
      axpath.pop
      e = doc.element axpath.join('/')
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
    @doc2.xpath @xpath
  end

  # returns the xpath pointing to the rows
  #
  def to_xpath()
    @xpath
  end

  alias rows_xpath to_xpath


end
