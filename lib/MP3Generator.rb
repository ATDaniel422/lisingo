#MP3Generator.rb
require 'aws-sdk'

module Module1

  def generateAudio(inText,userVoice = "Joanna")
    client  = Aws::Polly::Client.new(region: 'us-east2')
    strings = text.split(/(?<=[.!?]) /)
    File.open("audio.mp3", 'wb')
    for string in strings do
      output = client.SynthesizeSpeech({lexicon_names: [],
      output_format:"mp3",
      sample_rate: "8000",
      text: inText,
      text_type:"text",
      voice_id: userVoice,})
      File.write(output.audio_stream.read)
    end
  end
end
      


  
