function textToSpeech(text, voice, flac)
    text = strrep(text, ' ', '%20');
    disp(text);
    username = '807e27a9-53ed-41fc-9d51-02fc424151e1';
    password = 'OjtAQJTelGTk';
    h1 = '--header "Accept: audio/flac" ';
    api = ['"https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=' voice '&text='];
    disp(api);
    curl_pre = 'env LD_LIBRARY_PATH='''' curl -u ';
    
    command = [curl_pre username ':' password ' -X GET ' h1 api text '" > ' flac];
    unix(command);
