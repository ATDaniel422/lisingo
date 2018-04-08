#MP3Generator.rb
require 'aws-sdk'


module Module1

  def generateAudio(inText,userVoice = "Joanna")
    client  = Aws::Polly::Client.new(region: 'us-east-1')
    strings = text.split(/(?<=[.!?]) /)
    file = Tempfile.new('test')
    file.binmode
    for string in strings do
      string.insert(0,'<speak>')
      string.insert(string.length-1, '<break strength ="strong"></speak>')
      output = client.synthesize_speech({lexicon_names: [],
      output_format:"mp3",
      sample_rate: "8000",
      text: inText,
      text_type:"ssml",
      voice_id: userVoice,})
      file.write(output.audio_stream.read)
    end
    s3 = Aws::S3::Resource.new(region:'us-east-1')
    key = SecureRandom.uuid
    bucket = s3.bucket('lisingo').object(key)
    bucket.put(body: file)
    file.close
    file.unlink
  end
end
      


  
