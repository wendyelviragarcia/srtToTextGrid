# srtToTextGrid
srt to TextGrid is a Praat script that parses srt files that come from transcriptions from Whisper generated with [Buzz](https://github.com/chidiwilliams/buzz) to Textgrids files.

## Instructions
Download the Praat file, open it in Praat and write the path where your srt files are stored. It will read them (as a string list) and create a Textgrid where each interval is a frame in the srt using the timestamp in the file.
