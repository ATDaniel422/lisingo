#MP3Generator.rb
require 'aws-sdk-polly'
#Aws.config.update({credentials: Aws::Credentials.new()})
module MP3Generator

module Module1

  def generateAudio(inText,userVoice = "Joanna")
    client  = Aws::Polly::Client.new(region: 'us-east-1')
    strings = text.split(/(?<=[.!?]) /)
    file = Tempfile.new('test')
    file.binmode
    for string in strings do
      string.insert(0,'<speak>')
      string.append( '<break strength ="strong"></speak>')
      output = client.synthesize_speech({lexicon_names: [],
      output_format:"mp3",
      sample_rate: "8000",
      text: inText,
      text_type:"ssml",
      voice_id: userVoice,})
      file.write(output.audio_stream.read)
    end

    threads.map(&:join)
    files = threads.map(&:value)
    files.each(&:close)
    combined_filename = Dir::Tmpname.create(["mp3wrapped", ".mp3"], nil) {}
    `#{Rails.root + "bin/mp3wrap"} #{combined_filename} #{files.map(&:path).join(" ")}`
    files.each(&:unlink)
    return combined_filename
  end
end
