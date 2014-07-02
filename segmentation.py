import cv2

'''
This file is for segmentating the pupil in a image of the eye, returns the set 
of pixel points that are inside the pupil.
'''

def segmentate(img_eye):
	# Do segmentation
	bw_img_eye = cv2.cvtColor(img_eye, cv2.COLOR_BGR2GRAY)
	_, contours, hierarchy = cv2.findContours(bw_img_eye, cv2.RETR_LIST,
		cv2.CHAIN_APPROX_SIMPLE)
	max_area = 0
	for cnt in contours:
		area = cv2.contourArea(cnt)
		if (area > max_area):
			max_area = area
			best_cnt = cnt
	return best_cnt