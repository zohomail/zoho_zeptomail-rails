Gem::Specification.new do |s|
  s.name        = "zoho_zeptomail-rails"
  s.version     = "0.0.1"
  s.summary     = "Zoho ZeptoMail official Ruby SDK"
  s.authors     = ["ZohoMail"]
  s.email       = "me@unmb.pw"
  s.files       = ["lib/zohozeptomail_rails.rb"]
  s.homepage    = "https://www.zoho.com/zeptomail"
  s.license       = "MIT"

  s.add_dependency 'zoho_zeptomail-ruby'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'minitest-rails'
  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'net-smtp'
end
