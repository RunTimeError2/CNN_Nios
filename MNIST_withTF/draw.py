import tensorflow as tf
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import codecs

def rgb2gray(rgb):
    return np.dot(rgb[..., :3], [0.299, 0.587, 0.114])

img = mpimg.imread('./circle.png')
img_gray = rgb2gray(img)
print(img_gray.size)
print(img_gray)
f=codecs.open("guess.txt", 'w', 'utf-8');
[rows,cols]=img_gray.shape
for i in range(rows):
    for j in range(cols):
        temp = 1-img_gray[i, j]
        f.write("%d, " % (255 - temp * 255.0))
        # if j == cols-1:
        #     f.write("\n")
    f.write("\r\n")
