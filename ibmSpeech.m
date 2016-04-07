flacFiles    = '/u/cs401/speechdata/Testing/*.flac';
testDir      = '/u/cs401/speechdata/Testing/';
FD           = dir(flacFiles);

% Speech-to-text
for i=1:length(FD)
    % Get the absolute file path
    flac = [testDir '/' FD(i).name];
    text = speechToText(flac);
    disp(text);
end
