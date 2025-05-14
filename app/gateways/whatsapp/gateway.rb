require 'openssl'
require 'base64'

module Whatsapp
  class Gateway
    include HTTParty
    base_uri "https://mmg.whatsapp.net"

    def get_image(path, media_key)
      blob = self.class.get(path)
      decrypt_image(
        blob,
        media_key
      )
    end

    private

    def decrypt_image(blob, media_key_b64)
      # 1) Read blob (ciphertext + 10-byte HMAC tag)
      ciphertext = blob[0...-10]
      mac_tag    = blob[-10,10]

      # 2) Decode keys from Base64
      media_key = Base64.decode64(media_key_b64)

      # 3) HKDF (Extract+Expand) → 112 bytes
      key_material = OpenSSL::KDF.hkdf(
        media_key,
        salt:   "".b,                         # make salt ASCII-8BIT
        info:   "WhatsApp Image Keys".b,      # ← force this into ASCII-8BIT
        hash:   "SHA256",
        length: 112
      )

      iv         = key_material[0,16]
      cipher_key = key_material[16,32]
      mac_key    = key_material[48,32]
      # (the remaining 32 bytes are the “refKey,” unused here)

      # 4) Verify HMAC-SHA256(macKey, IV∥ciphertext) truncated to 10 bytes
      computed_tag = OpenSSL::HMAC.digest('SHA256', mac_key, iv + ciphertext)[0,10]
      unless OpenSSL.fixed_length_secure_compare(computed_tag, mac_tag)
        abort "❌ HMAC mismatch – aborting"
      end

      # 5) AES-256-CBC decrypt
      cipher = OpenSSL::Cipher.new('aes-256-cbc')
      cipher.decrypt
      cipher.key = cipher_key
      cipher.iv  = iv
      plaintext  = cipher.update(ciphertext) + cipher.final

      # 6) Verify SHA256(plaintext) == filehash
      digest = OpenSSL::Digest::SHA256.digest(plaintext)
      # unless OpenSSL.fixed_length_secure_compare(digest, filehash)
      #   abort "❌ Filehash mismatch – decrypted data corrupt"
      # end

      # 7) Write out as .jpg or .webp
      hdr = plaintext.byteslice(0,4)
      ext = if hdr.start_with?("\xFF\xD8".b) then 'jpg'
            elsif hdr == 'RIFF'.b      then 'webp'
            else 'bin'
            end

      { extension: ext, blob: plaintext }
    end
  end
end
