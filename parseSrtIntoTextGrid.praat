
############################################################################################################################################################################################

# Parse .srt to TextGrid (not multiline srt) 

############################################################################################################################################################################################
# DESCRIPTION
# this script is design to convert .srt files resulting from whisper and, specially, https://www.softcatala.org/transcripcio/ to TextGrid files in order to work in Praat with those transcriptions.
#
# it will fail to transcribe usual srt files to textgrid because those are usually multiline and this code expects to have only one line in each frame.
#
# INSTRUCTIONS
# Write the path (directory or folder) where you have your srt files stored at the form that will appear and it will create 1 Textgrid per file.

#
#						CREDITS
# Feedback is always welcome, please if you notice any bugs or come up with anything that can improve this script, let me know!
# 	
# Wendy Elvira-García 
# wendyelvira@ub.edu // www.wendyelvira.ga
# first version: May 2023
############################################################################################################################################################################################


# form
form From srt to TextGrid
	sentence Folder /Users/weg/Desktop/
endform




# creating the loop
files = Create Strings as file list: "list", folder$ +"/" + "*.srt"
numberOfFiles = Get number of strings

for file to numberOfFiles
	selectObject:  files
	file$ = Get string: file
	base$ = file$- ".srt"
	path$= folder$ + "/" + file$

	# this does the trick, check it below
	@srtToGrid(path$)

	selectObject: srtToGrid.myTextGrid

	Save as text file: folder$ + "/" + base$ + ".TextGrid"
endfor






## procedure that I use to parse

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
