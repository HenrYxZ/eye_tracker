import cv2
import numpy as np
from segmentation import segmentate

'''
This project is an eye tracker that gets a video of an eye watching another 
video and that video which is watched by the eye. The output is a log with the
2D position of the center of the eye on every frame (in pixels) and the diameter
of the pupil also gave in pixels for every frame, and a new video which is the
video watched by the eye but with a red cross indicating the pixel where the eye
is looking.

Created on 20-6-2014

@author: Hernaldo Henriquez
'''

def get_videos(source_1, source_2):
	first_cap = cv2.VideoCapture(source_1)
	second_cap = cv2.VideoCapture(source_2)

	if (first_cap is None) or (not first_cap.isOpened()):
		print('Warning: unable to open video source: ' +  source_1)
	if (second_cap is None) or (not second_cap.isOpened()):
		print('Warning: unable to open video source: ' + source_2)

	return first_cap, second_cap

def report(log, frame_number, center, radius):
	header = "New frame number :" + str(frame_number) + "\n"
	log.write(header)
	line = "Center: ({0},{1})\n"
	log.write(line.format(str(center.x), str(center.y)))
	line = "Radius: {0}\n\n"
	log.write(line.format(str(radius))) 

def get_circle(cnt):
	(x,y),radius = cv2.minEnclosingCircle(cnt)
	#center = (int(x),int(y))
	center = (200,200)
	#radius = int(radius)
	radius = 30
	return center, radius

def process_by_frame(eye_capture, looked_capture):
	#log = open("log.txt", "w")
	counter = 1
	while True:
		ret_eye, img_eye = eye_capture.read()
		#ret_looked, img_looked = looked_capture.read()
		#if not ret_eye or not ret_looked:
		if not ret_eye:
			break
		new_eye_img = img_eye.copy()
		pupil = segmentate(new_eye_img)
		# TODO process pupil
		center, radius = get_circle(pupil)
		border_color = (0, 255, 0)
		cv2.circle(new_eye_img, center, radius, border_color, 2)
		cv2.imshow("EyeSegmentation", new_eye_img)
		counter = counter + 1

	#log.close()
	eye_capture.release()
	looked_capture.release()

def main():
	print ('Write the path for the video of the eye')
	#eye_video_src = raw_input()
	eye_video_src = "sujeto1/suj1_CUT.avi"

	print ('Write the path for the looked video')
	#looked_video_src = raw_input()
	looked_video_src = "sujeto1/Test1.avi"

	cv2.namedWindow("EyeSegmentation")
	eye_capture, looked_capture = get_videos(eye_video_src, looked_video_src)
	process_by_frame(eye_capture, looked_capture)
	cv2.destroyAllWindows()

if __name__ == '__main__':
	main()