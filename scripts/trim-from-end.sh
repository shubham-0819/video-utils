#!/bin/bash

# Check if video file and seconds to cut are provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 input_video.mp4 seconds_to_cut"
  exit 1
fi

input_video="$1"
seconds_to_cut="$2"

# Get the base name and extension of the input video
filename=$(basename -- "$input_video")
extension="${filename##*.}"
basename="${filename%.*}"

# Generate a timestamp for the output file
timestamp=$(date +"%Y%m%d%H%M%S")
output_video="${basename}_trimmed_${timestamp}.${extension}"

# Get the duration of the video in seconds
duration=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of csv=p=0 "$input_video")

# Calculate the new duration by subtracting seconds to cut
new_duration=$(echo "$duration - $seconds_to_cut" | bc)

# Use ffmpeg to trim the video to the new duration
ffmpeg -i "$input_video" -t "$new_duration" -c copy "$output_video"

echo "Trimmed video saved as $output_video"
