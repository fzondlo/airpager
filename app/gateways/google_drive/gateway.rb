require "googleauth"
require "google/apis/drive_v3"

FACTURAS_FILE_ID = "1qw1veC6s3-7XjeKXnY8G8bSbMU2jCeta"

module GoogleDrive
  class Gateway

    def initialize(auth_json)
      @auth_json = auth_json
    end

    def find_files
      drive.list_files()
    end

    def create_image(base64_image, file_prefix)
      decoded_image = Base64.decode64(base64_image)
      image_io = StringIO.new(decoded_image)
      name = "#{file_prefix}-#{Time.current.strftime("%Y-%m-%d-%-H-%M")}-#{SecureRandom.alphanumeric(6)}.jpg"
      file_metadata = {
        name: name,
        mime_type: "image/jpeg",
        parents: [FACTURAS_FILE_ID]  # omit or [] to drop in root
      }
      uploaded = drive.create_file(
        file_metadata,
        upload_source: image_io,
        content_type:  "image/jpeg",
        fields:        "id, name"
      )
      puts "Uploaded file #{uploaded.name} (ID: #{uploaded.id})"
      permission = {
        type: "anyone",
        role: "reader"
      }
      drive.create_permission(
        uploaded.id,
        permission,
        fields: "id"
      )
      file = drive.get_file(
        uploaded.id,
        fields: "webViewLink"
      )
      public_url = file.web_view_link

      puts "Public URL for image: #{public_url}"
      public_url
    end

    private

    def drive
      @drive ||= begin
         credentials = Google::Auth::ServiceAccountCredentials.make_creds(
           json_key_io: StringIO.new(JSON.generate(@auth_json)),
           scope:       Google::Apis::DriveV3::AUTH_DRIVE_FILE
         )
         credentials.fetch_access_token!
         drive = Google::Apis::DriveV3::DriveService.new
         drive.authorization = credentials
         drive
       end
    end
  end
end
