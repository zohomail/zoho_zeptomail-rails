require 'minitest/autorun'

require 'rubygems'
require 'base64'
require 'bundler'
require 'bundler/setup'
Bundler.setup(:development)
require 'nokogiri'
require 'zohozeptomail_rails'
require 'rails'
require 'action_mailer'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :zohozeptomail

class TestMailer < ActionMailer::Base
  default from: 'automation@automation.jp.ztmqa.in'

  def msg(from, to, subject)
    mail(
      from: from,
      to: to,
      subject: subject,
      cc: 'test12.testmail1@gmail.com'
    ) do
        |format|
        format.text { render plain: 'testemail123' }
        format.text { render plain: 'hello' }
        format.text { render plain: 'hellsdssdsad' }
        format.text { render plain: '<div>testemail1212343</div>'}
        format.html { render html: '<b>testemail32</b>' }
        format.html { render html: '<div>Test to much do it</div>'}
        attachments['helllo.pdf'] = File.read('test/mailers/Hello.pdf')
        attachments['hi.txt'] = File.read('test/mailers/Hello.txt')
        attachments['image.png'] = File.read('test/mailers/test.jpeg')
        attachments['test.pdf'] = File.read('test/mailers/sample.pdf')
    end
  end
end

class MailerTest < Minitest::Test
  def setup
  end

  def test_text_message
    TestMailer.msg('automation@automation.jp.ztmqa.in', 'michael.scott@zylker.com', 'hello-word').deliver!
  end
end
