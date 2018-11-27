import tensorflow as tf
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.image as mpimg


def rgb2gray(rgb):
    return np.dot(rgb[..., :3], [0.299, 0.587, 0.114])

'''
img = mpimg.imread('ShapeOfConv1.png')
img_gray = rgb2gray(img)
plt.subplot(2, 1, 1), plt.imshow(img_gray, cmap=matplotlib.cm.gray)
plt.axis('off')
# plt.show()
m, n = img_gray.shape
print(img_gray.shape)
print(img_gray)
'''
m, n = 5, 5
img_gray = np.array([[1,  2,  3,  4,  5.0],
                     [6,  7,  8,  9,  10],
                     [11, 12, 13, 14, 15],
                     [16, 17, 18, 19, 20],
                     [21, 22, 23, 24, 25.0]], dtype=np.float32)
img3 = np.array([[[1, 2], [3, 4], [5, 6]],
                 [[7, 8], [9, 10], [11, 12]],
                 [[13, 14], [15, 16], [17, 18]]])
img2 = tf.reshape(img3, [9*2])
# print(img2)

x = tf.placeholder(tf.float32, shape=[1, m, n, 1])
W_Conv1 = tf.constant([[[1.0, 0.5], [0.0, 0.0], [0.0, 0.0]],
                       [[0.0, 0.0], [0.5, 0.0], [0.0, 0.0]],
                       [[2.0, 0.0], [0.0, 1.0], [0.0, 0.5]]],
                      shape=[3, 3, 1, 2])
b_Conv1 = tf.constant(0.0, shape=[1])
h_Conv1 = tf.nn.relu(tf.nn.conv2d(x, W_Conv1, strides=[1, 1, 1, 1], padding='SAME') + b_Conv1)
with tf.Session() as sess:
    result = sess.run(h_Conv1, feed_dict={x: img_gray.reshape([1, m, n, 1])})
    img_result = result.reshape([m, n, 2])
    print(img_result)
    print('=----------------')
    print(sess.run(img2))
    with open("abcde.txt", "w") as f:
        list = W_Conv1.eval().tolist()
        for i in range(3):
            for j in range(3):
                for k in range(2):
                    f.write(str(list[i][j][0][k]))
                    f.write("   ")
                f.write("\n")
            f.write("\n")
    # plt.subplot(2, 1, 2), plt.imshow(img_result, cmap=matplotlib.cm.gray)
    # plt.axis('off')
    # plt.show()
