function text = speechToText(speechPath)
    command = toUnix(speechPath);
    [~, json] = unix(command);
    
    text = getText(json);


function command = toUnix(speechPath)
    username = '43146a8d-b0c8-491d-a749-b221a84c5140';
    password = 'hNnjub5GXnQ9';
    h1 = '--header "Content-Type: audio/flac" ';
    h2 = '--header "Content-Type: audio/flac" ';
    flac = ['--data-binary @' speechPath];
    api = ' "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize?continuous=true"';

    command = ['env LD_LIBRARY_PATH='''' curl -u ' username ':' password ' -X POST ' h1 h2 flac api];

function text = getText(json)
    text = strsplit(json, '"');
    text = strtrim(text(10));
