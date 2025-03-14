# Zoho ZeptoMail Rails

### Setup

```bash
gem install zoho_zeptomail-rails
```

You will have to initalize it in your Gem file with `require "zoho_zeptomail-rails"`.

1. Use the adapter:
```ruby
  ActionMailer::Base.delivery_method = :zohozeptomail
```
2. `zoho_zeptomail-ruby` gem requires `ZOHO_ZEPTOMAIL_API_KEY_TOKEN` and `ZOHO_ZEPTOMAIL_HOSTED_REGION` environment variable,
   so make sure it's set.

## Email

### Send an email
```ruby
class TestMailer < ActionMailer::Base
  default from: 'michael@zylker.com'

  def msg(from, to, subject)
    mail(
      from: from,
      to: to,
      subject: subject,
      cc: 'rebeca@zylker.com'
    ) do
        |format|
        format.text { render plain: 'hello' }
        format.html { render html: '<div>This is a test email</div>'}
        attachments['filename.pdf'] = File.read('test/mailers/Hello.pdf')
        attachments['text_filename.txt'] = File.read('test/mailers/Hello.txt')
        attachments['image_filename.png'] = File.read('test/mailers/test.png')
    end
  end
end

class MailerTest < Minitest::Test
  def setup
  end

  def test_text_message
    TestMailer.msg( 'jerry@zylker.com', 'hello').deliver!
  end
end
```
