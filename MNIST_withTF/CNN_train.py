from tensorflow.examples.tutorials.mnist import input_data
import tensorflow as tf


# Load data set and define sess & placeholders
mnist = input_data.read_data_sets('MNIST_data', one_hot=True)
sess = tf.Session()

x = tf.placeholder(tf.float32, shape=[None, 784], name='x')     # input
y_ = tf.placeholder(tf.float32, shape=[None, 10], name='y_')    # label
keep_prob = tf.placeholder(tf.float32)

# Convert original data vectors to 28*28 images
x_image = tf.reshape(x, [-1, 28, 28, 1])


# Convolution layer 1 (including weights, biases and relu)
W_conv1 = tf.Variable(tf.truncated_normal(shape=[3, 3, 1, 8], stddev=0.1))
b_conv1 = tf.Variable(tf.constant(value=0.1, shape=[8]))
h_conv1 = tf.nn.relu(tf.nn.conv2d(x_image, W_conv1, strides=[1, 1, 1, 1], padding='SAME') + b_conv1)

# Max-pooling layer 1
h_pool1 = tf.nn.max_pool(h_conv1, ksize=[1, 2, 2, 1], strides=[1, 2, 2, 1], padding='SAME')

# Convolution layer 1 (including weights, biases and relu)
W_conv2 = tf.Variable(tf.truncated_normal(shape=[3, 3, 8, 4], stddev=0.1))
b_conv2 = tf.Variable(tf.constant(value=0.1, shape=[4]))
h_conv2 = tf.nn.relu(tf.nn.conv2d(h_pool1, W_conv2, strides=[1, 1, 1, 1], padding='SAME') + b_conv2)

# Max-pooling layer 2
h_pool2 = tf.nn.max_pool(h_conv2, ksize=[1, 2, 2, 1], strides=[1, 2, 2, 1], padding='SAME')

# Flatten the image for fc layers
h_pool2_flat = tf.reshape(h_pool2, [-1, 7*7*4])

# FC layer 1
W_fc1 = tf.Variable(tf.truncated_normal(shape=[7*7*4, 32], stddev=0.1))
b_fc1 = tf.Variable(tf.constant(value=0.1, shape=[32]))
h_fc1 = tf.nn.relu(tf.matmul(h_pool2_flat, W_fc1) + b_fc1)

# Dropout layer for training only
h_fc1_drop = tf.nn.dropout(h_fc1, keep_prob)

# FC layer 2
W_fc2 = tf.Variable(tf.truncated_normal(shape=[32, 10], stddev=0.1))
b_fc2 = tf.Variable(tf.constant(value=0.1, shape=[10]))
# The final output of the network
# Softmax is not necessary because only the largest element is needed for classifying the images
y_conv = tf.matmul(h_fc1_drop, W_fc2) + b_fc2

# Loss function
cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y_conv))

# Training op
train_step = tf.train.AdamOptimizer(1e-4).minimize(cross_entropy)

# Measuring accuracy
correct_prediction = tf.equal(tf.argmax(y_conv, 1), tf.argmax(y_, 1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

# defaults to saving all variables
saver = tf.train.Saver()


# Training steps
sess.run(tf.global_variables_initializer())
epochs = 20000
batch_size = 50
print("Start training ...")
for i in range(epochs):
    batch = mnist.train.next_batch(batch_size)
    # Measure the accuracy every 100 epochs
    if i % 100 == 0:
        train_accuracy = sess.run(accuracy, feed_dict={x: batch[0], y_: batch[1], keep_prob: 1.0})
        print("step %d, training accuracy %g" % (i, train_accuracy))
    # Training
    sess.run(train_step, feed_dict={x: batch[0], y_: batch[1], keep_prob: 0.5})

# Save the model
saver.save(sess, './model.ckpt')  # Save the model
print("Model saved.")

# Test the model
print("test accuracy %g" % sess.run(accuracy, feed_dict={x: mnist.test.images, y_: mnist.test.labels, keep_prob: 1.0}))

# Save all the parameters in the format that C programs can understand
print("Saving parameters ...")

with open("conv1_w.txt", "w") as f:
    list = W_conv1.eval(session=sess).tolist()
    for i in range(3):
        for j in range(3):
            for k in range(1):
                for l in range(8):
                    f.write("%.12f  " % list[i][j][k][l])
                f.write("\n")
            f.write("\n")
        f.write("\n")

with open("conv1_b.txt", "w") as f:
    list = b_conv1.eval(session=sess).tolist()
    for i in range(8):
        f.write("%.12f  " % list[i])

with open("conv2_w.txt", "w") as f:
    list = W_conv2.eval(session=sess).tolist()
    for i in range(3):
        for j in range(3):
            for k in range(8):
                for l in range(4):
                    f.write("%.12f  " % list[i][j][k][l])
                f.write('\n')
            f.write('\n')
        f.write('\n')

with open("conv2_b.txt", "w") as f:
    list = b_conv2.eval(session=sess).tolist()
    for i in range(4):
        f.write("%.12f  " % list[i])

with open("fc1_w.txt", "w") as f:
    list = W_fc1.eval(session=sess).tolist()
    print(W_fc1.shape)
    for i in range(7*7*4):
        for j in range(32):
            f.write("%.12f  " % list[i][j])
        f.write('\n')

with open("fc1_b.txt", "w") as f:
    list = b_fc1.eval(session=sess).tolist()
    for i in range(32):
        f.write("%.12f  " % list[i])

with open("fc2_w.txt", "w") as f:
    list = W_fc2.eval(session=sess).tolist()
    for i in range(32):
        for j in range(10):
            f.write("%.12f  " % list[i][j])
        f.write("\n")

with open("fc2_b.txt", "w") as f:
    list = b_fc2.eval(session=sess).tolist()
    for i in range(10):
        f.write("%.12f  " % list[i])

sess.close()
print("Done.")
