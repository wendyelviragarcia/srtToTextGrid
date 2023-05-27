#myTimings= Read Table from semicolon-separated file: "/Users/weg/Desktop/test (Transcribed on 13-abr-2023 20-53-07).srt"
form From srt to TextGrid
	sentence Folder /Users/weg/Desktop/
endform


files = Create Strings as file list: "list", folder$ +"/" + "*.srt"
numberOfFiles = Get number of strings

for file to numberOfFiles
	selectObject:  files
	file$ = Get string: file
	base$ = file$- ".srt"
	path$= folder$ + "/" + file$
	@srtToGrid(path$)

	selectObject: srtToGrid.myTextGrid

	Save as text file: folder$ + "/" + base$ + ".TextGrid"
endfor








procedure srtToGrid: .path$
	myTimings= Read Strings from raw text file: .path$

	# let's create the textgrid with the last info of the srt
	nRows=Get number of strings
	lastData$ = Get string: nRows-2
	echo 'lastData$'

	word$ = extractWord$(lastData$, "-->")
	@hourToSecs(word$)


	.myTextGrid= Create TextGrid: 0, hourToSecs.time, "ort", ""

	# for each frame find the timestamp and the content and insert a boundary


	numberOfIntervals = nRows/4
	index=1
	for n to numberOfIntervals
		selectObject: myTimings
		wholetimeStamp$= Get string: index+1
		wholetimeStamp= number (wholetimeStamp$)
		timeStamp$ = extractWord$(wholetimeStamp$, "-->")
		@hourToSecs(timeStamp$)
		text$ = Get string: index+2

		selectObject: .myTextGrid

		if n < numberOfIntervals
			Insert boundary: 1, hourToSecs.time
		endif
		Set interval text: 1, n, text$
		index= index+4
	endfor
endproc


#######
# procedure that reads date format with commas and returns seconds
#####

procedure hourToSecs: .myTime$
	#.myTime$ = '01:50:60,80'
	#echo '.myTime$'

	.myTime$=replace$ (.myTime$, ",", ".", 1)
	largo= length (.myTime$)

	.hours$ = mid$(.myTime$ , 2, 2)
	.minutes$= mid$(.myTime$ , 5, 2)
	.seconds$= mid$(.myTime$ , 7, largo)

	.hours= number(.hours$)
	.minutes= number(.minutes$)
	.seconds= number(.seconds$)

	# minutes are 60 seconds. Hours are  60 minutes.
	.time = .hours * 60 * 60 + .minutes * 60 + .seconds
endproc