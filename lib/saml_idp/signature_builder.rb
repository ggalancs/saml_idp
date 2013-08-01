require 'builder'
module SamlIdp
  class SignatureBuilder
    attr_accessor :signed_info_builder

    def initialize(signed_info_builder)
      self.signed_info_builder = signed_info_builder
    end

    def raw
      @raw ||= builder.tag! "ds:Signature", "xmlns:ds" => "http://www.w3.org/2000/09/xmldsig#" do |signature|
        signature << signed_info
        signature.tag! "ds:SignatureValue", signature_value
        signature.KeyInfo xmlns: "http://www.w3.org/2000/09/xmldsig#" do |key_info|
          key_info.tag! "ds:X509Data" do |x509|
            x509.tag! "ds:X509Certificate", x509_certificate
          end
        end
      end
    end

    def x509_certificate
      SamlIdp.config.x509_certificate
    end
    private :x509_certificate

    def signed_info
      signed_info_builder.raw
    end
    private :signed_info

    def signature_value
      signed_info_builder.signed
    end
    private :signature_value

    def builder
      @builder ||= Builder::XmlMarkup.new
    end
    private :builder
  end
end
