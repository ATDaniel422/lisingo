#MP3Generator.rb
require 'aws-sdk-polly'
#Aws.config.update({credentials: Aws::Credentials.new()})
module MP3Generator

  def self.generateAudio(inText,userVoice = "Joanna")
    client  = Aws::Polly::Client.new(region: 'us-east-2')
    strings = inText.scan(/(.{0,1500}[.?!])/).flatten()
    p strings
    threads = []
    strings.each do |string|
      thr_string = string.clone()
      threads << Thread.new {
        p thr_string
        client  = Aws::Polly::Client.new(region: 'us-east-2')
        result =  client.synthesize_speech({lexicon_names: [],
        output_format:"mp3",
        sample_rate: "8000",
        text: thr_string,
        text_type:"text",
        voice_id: userVoice,})
        file = Tempfile.new(["mp3wrap", ".mp3"])
        file.binmode
        file.write(result.audio_stream.read)
        file
      }
    end

    threads.map(&:join)
    files = threads.map(&:value)
    files.each(&:close)
    combined_filename = Dir::Tmpname.create(["mp3wrapped", ".mp3"], nil) {}
    p "#{Rails.root + "bin/mp3wrap"} #{combined_filename} #{files.map(&:path).join(" ")}"
    `#{Rails.root + "bin/mp3wrap"} #{combined_filename} #{files.map(&:path).join(" ")}`
    files.each(&:unlink)
    return combined_filename
  end
end
