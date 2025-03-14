require 'cgi'

module ZohozeptomailRails
  class RailsMsgToMsMsg
    def self.msg_to_ms_msg(msg)
      ms_msg = ZohoZeptoMail::SendMail.new

      if msg.from_addrs.empty?
        raise 'From address should not be empty or nil'
      else
        ms_msg.add_from(rails_from_addr(msg.from_addrs))
      end

      if msg.subject.empty?
        raise 'Subject should not be empty or nil'
      else
        ms_msg.add_subject(msg.subject)
      end

      if msg.to_addrs.empty?
        raise 'Recipients address should not be empty or nil'
      else
        msg.to_addrs.each do |i|
          ms_msg.add_recipients(rails_addr(i))
        end
      end

      body_text = msg_text(msg) || ""
      body_html = CGI.unescapeHTML(msg_html(msg))
      if body_text != ""
          body_text += '<br>' + body_html
      else
          body_text += body_html
      end
      ms_msg.add_body(body_text)

      if msg.reply_to
        msg.reply_to.each do |i|
          ms_msg.add_reply_to(rails_addr(i))
        end
      end

      rails_attach(msg.attachments, ms_msg)

      if msg.cc_addrs
        msg.cc_addrs.each do |i|
          ms_msg.add_cc(rails_addr(i))
        end
      end

      if msg.bcc_addrs
        msg.bcc_addrs.each do |i|
          ms_msg.add_bcc(rails_addr(i))
        end
      end

      ms_msg
    end

    private

    def self.rails_attach(attach, ms_msg)
        if !attach.nil?
            attach.each do |attachments|
                ms_msg.add_attachments(content: attachments.body.decoded.to_s, filename: attachments.filename, mime_type: attachments.content_type)
            end
        end
    end

    def self.rails_addr(addr)
        if addr.is_a?(Mail::Address)
            name = addr.name || addr.address
            email = addr.address
        else
            name = nil
            email = addr
        end
        if name.nil?
            {address: email}
        else
            { name: name, address: email }
        end
    end

    def self.rails_from_addr(from_addrs)
        if from_addrs.is_a?(Mail::Address)
            name = from_addrs.name || from_addrs.address
            email = from_addrs.address
        else
            name = nil
            email = from_addrs
        end
        if name.nil?
            { address: email[0] }
        else
            { name: name, address: email[0] }
        end
    end

    def self.msg_text(msg)
      text_parts = []
      if msg.multipart?
        msg.parts.each do |part|
          if part.content_type =~ /^multipart\/alternative/i
            text_parts.concat(extract_text_from_multipart_alternative(part))
          end
        end
      end

      if msg.mime_type =~ /^text\/plain$/i
        text_parts << msg.body.decoded.to_s.strip
      end
      text_parts.join("<br>") unless text_parts.empty?
    rescue => e
      Rails.logger.error("Error extracting text from email: #{e.message}") if defined?(Rails)
      raise
    end

    def self.extract_text_from_multipart_alternative(part)
      nested_text_parts = []
      part.parts.each do |sub_part|
        if sub_part.content_type =~ /^text\/plain[;$]/i
          nested_text_parts << sub_part.body.decoded.to_s.strip
        end
      end
      nested_text_parts
    end

    def self.msg_html(msg)
        html_parts = []
        if msg.multipart?
            msg.parts.each do |part|
              if part.content_type =~ /^multipart\/alternative/i
                html_parts.concat(extract_text_html_multipart_alternative(part))
              elsif part.content_type =~ /^text\/html[;$]/i
                html_parts << part.body.decoded.to_s.strip
              end
            end
          end
          if msg.mime_type =~ /^text\/html$/i
            html_parts << msg.body.decoded.to_s.strip
          end
          clean_html = html_parts.join("<br>").gsub(/<\/?[^>]*>/, '').strip
          clean_html
      end

    def self.extract_text_html_multipart_alternative(part)
        nested_text_parts = []
        part.parts.each do |sub_part|
            if sub_part.content_type =~ /^text\/html[;$]/i
               nested_text_parts << sub_part.body.decoded.to_s.strip
            end
        end
        nested_text_parts
    end
  end
end