#!/usr/bin/env ruby

# Import required gems
require 'aws-sdk-s3' # AWS SDK for s3 operations
require 'pry' # Interactive shell for debugging
require'securerandom' # For generating secure random strings (UUIDs)

# Set bucket name from environment variable
bucket_name = ENV['BUCKET_NAME']

# Create an AWS S3 client
client = Aws::S3::Client.new

# Create a new S3 bucket
resp = client.create_bucket({
  bucket: bucket_name
})

# binding.pry

# Generate a random number of files to upload (between 1 and 6)
number_of_files = 1 + rand(6)
puts "Uploading #{number_of_files} files..."

# Upload each file
number_of_files.times do |i|
  # Generate a unique filename
  filename = "file_#{i}.txt"
  output_path = "/tmp/#{filename}"

  # Create a new file with a random UUID as contents
  File.open(output_path, "w") do |f|
    f.write SecureRandom.uuid
  end
  
  # Upload the file to S3
  File.open(output_path, "rb") do |f|
    client.put_object(
      bucket: bucket_name,
      key: filename,
      body: f
    )
  end
  
  puts "Uploaded file #{i+1}: #{filename}"
end