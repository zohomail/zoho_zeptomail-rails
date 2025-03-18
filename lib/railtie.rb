require 'rails/railtie'
require 'delivery_method'
require 'zoho_zeptomail-ruby'

module ZohozeptomailRails
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load(:action_mailer) do
      add_delivery_method :zohozeptomail, ZohozeptomailRails::Mailer
    end
  end
end
