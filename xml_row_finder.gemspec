Gem::Specification.new do |s|
  s.name = 'xml_row_finder'
  s.version = '0.3.0'
  s.summary = 'Attempts to find repeating rows in XHTML and returns the associated xpath.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/xml_row_finder.rb']
  s.add_runtime_dependency('nokorexi', '~> 0.5', '>=0.5.4')
  s.signing_key = '../privatekeys/xml_row_finder.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/xml_row_finder'
end
