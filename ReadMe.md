A friend of mine is operating one of those let's play channels on youtube. As he spends most of his time editing, he approached me and asked if I could find a faster way to render the videos.

And that's why I created the 
# One Click Let's Play Render Script

## Requirements

- AVISynth 2.6.0 or higher
- ffmpeg, build git-4160900 or higher
- Videofile(s) with two separate audio channels for voice and ingame sound

Tested with videos that are encoded with Lagarith Lossless or MagicYUV. Should work for any other codec as well.

I tested this script under windows 7/10. If you can modify it to be system-independent, please send me a pull request.

Big shoutout to SagraS for his amazing AVISynth Tool! http://www.letsplayforum.de/index.php/Thread/110277/?page=Thread&threadID=110277


## Installation

Make sure that all requirements are met. 

1. Download both files and copy them into your videocapture directory
2. Execute the convertVideo.bat
3. Have a cup of tea while you wait for your videos to finish. :)

## How does it work?

1. Find all files with a .avi extension in the current directory
2. Copy the preset for the conversion and rename it to the current video. (but with a .avs extension)
3. Convert the video
4. Delete the temporary preset file 
5. Repeat steps 2 - 5 for each file

The video conversion is a two step process. First we take the source video and preprocess it with AVISynth. The we pass this data over to ffmpeg and convert the video to our desired format.

I had to use AVISynth to process the video first because ffmpeg can not process the lossless codecs that my friend uses.

For the processing I used the awesome tool by SagraS to generate an AVISynth script with all the neccessary options. I then modified it to be independent from a specific filename.
```
AVIload(LeftStr(ScriptName(), StrLen(ScriptName()) - 4)+".avi", 0, 0, 0, -0, -0, "Auto", "Auto", 0, 0)
```

The output is then processed by ffmpeg. Because I did not receive audio stream by AVISynth I used the original file to get these streams and layered them with ffmpeg.


Quick rundown of the ffmpeg parameters:
- -i To import both the original and the preprocessed files
- -c:v libx264 -preset slow -crf 22	To set the video codec to h264 with good compression
- -map 1:0 To use the video stream of the second input (the pre-processed file)
- -filter_complex "[0:1][0:2] amerge=inputs=2" -c:a aac To merge both audio tracks of the original file and convert them to aac
- lastly you define the name of the output file.

## Some stuff I learned writing this script:

- ```setlocal enabledelayedexpansion``` is mandatory for the for loop in bash. Don't really understand why, but this stackoverflow answer seems to explain it quite well: http://stackoverflow.com/a/18464353/3545959
- ```%~dp0``` returns the directoy that contains the script. Crazy stuff, where is it explained???
- ```%%~nF``` return the name of a file without its extension. Again, why???
- ```xcopy "%preset_path%" "%current_path%!avi_path!.avs*"``` Noticed the * in this command? You use it to tell the command line that this is indeed a file you want to copy and not a directory.
- Oh and because some stack related reasons you have to use ```!``` instead of ```%``` to access the object inside a for each loop.

## Bugs or missing features?

I'm happy to help you if the script does not work for you. Post an issue or send me a message.

## Licence
The MIT License (MIT)

Copyright (c) 2016 G710

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.