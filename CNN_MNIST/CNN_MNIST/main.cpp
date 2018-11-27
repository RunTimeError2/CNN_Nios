/*
 * Using CNN for MNIST
 * This program will be deployed on FPGA SOPC
 * 
 * Created by RunTimeError2 at 2018.7.11
 */

#include <iostream>
#include <fstream>
#include <iomanip>
#include <stdio.h>
#include <math.h>

// Structure of CNN
// Convolution Layer [3, 3, 1, 8], bias [8] with relu()
// Max-pooling Layer [1, 2, 2, 1]
// Convolution Layer [3, 3, 8, 4], bias [4] with relu()
// Max-pooling Layer [1, 2, 2, 1]
// Flatten (reshape)
// Fully-connected Layer [7*7*4, 32], bias [32] with relu()
// Fully-connected Layer [32, 10], bias [10]
#define IMAGE_DIM 28
#define CONV_CORE_DIM 3
#define CONV_RANGE 1
#define CONV_MID 1
#define CONV1_OUT_DIM 8
#define CONV2_OUT_DIM 4
#define FC1_OUT_DIM 32
#define FC2_OUT_DIM 10

#define RELU(x) (((x)>0)?(x):(0))

double Input_Image[IMAGE_DIM][IMAGE_DIM];
double Conv1_W[CONV_CORE_DIM][CONV_CORE_DIM][1][CONV1_OUT_DIM];
double Conv1_B[CONV1_OUT_DIM];
double Conv1_Image[IMAGE_DIM][IMAGE_DIM][CONV1_OUT_DIM];
double Pool1_Image[IMAGE_DIM / 2][IMAGE_DIM / 2][CONV1_OUT_DIM];
double Conv2_W[CONV_CORE_DIM][CONV_CORE_DIM][CONV1_OUT_DIM][CONV2_OUT_DIM];
double Conv2_B[CONV2_OUT_DIM];
double Conv2_Image[IMAGE_DIM / 2][IMAGE_DIM / 2][CONV2_OUT_DIM];
double Pool2_Image[IMAGE_DIM / 4][IMAGE_DIM / 4][CONV2_OUT_DIM];
double Flat_Image[(IMAGE_DIM / 4)*(IMAGE_DIM / 4)*CONV2_OUT_DIM];
double Fc1_W[(IMAGE_DIM / 4)*(IMAGE_DIM / 4)*CONV2_OUT_DIM][FC1_OUT_DIM];
double Fc1_B[FC1_OUT_DIM];
double FC1_Image[FC1_OUT_DIM];
double Fc2_W[FC1_OUT_DIM][FC2_OUT_DIM];
double Fc2_B[FC2_OUT_DIM];
double FC2_Image[FC2_OUT_DIM];
double Softmax[FC2_OUT_DIM];
int ans;
int calc_cnt;

// Load all parameters and image from file
// This function should be replaced with constant declaration when deploying on FPGA SOPC
void Load_All();

// Convolution Layer 1 with relu
void Conv1();

// Max-pooling Layer 1
void MaxPool1();

// Convolution Layer 2 with relu
void Conv2();

// Max-pooling Layer 2
void MaxPool2();

// Flatten the image
void Flatten();

// FC Layer 1 with relu
void Fc1();

// FC Layer 2
void Fc2();

// Softmax and get the result
void Get_Answer();

int main() {
	calc_cnt = 0;

	Load_All();
	Conv1();
	MaxPool1();
	Conv2();
	MaxPool2();
	Flatten();
	Fc1();
	Fc2();
	Get_Answer();

	int i;
	for (i = 0; i < 10; i++)
		printf("Number: %d, reliability: %f\n", i, (float)Softmax[i]);
	printf("Result = %d\n", ans);
	printf("Calculation times = %d\n", calc_cnt);
	getchar();
	return 0;
}

void Load_All() {
	using namespace std;
	ifstream f_conv1_w("conv1_w.txt");
	int i, j, k, l;
	for (i = 0; i < CONV_CORE_DIM; i++)
		for (j = 0; j < CONV_CORE_DIM; j++)
			for (k = 0; k < CONV1_OUT_DIM; k++)
				f_conv1_w >> Conv1_W[i][j][0][k];
	f_conv1_w.close();

	ifstream f_conv1_b("conv1_b.txt");
	for (i = 0; i < CONV1_OUT_DIM; i++)
		f_conv1_b >> Conv1_B[i];
	f_conv1_b.close();

	ifstream f_conv2_w("conv2_w.txt");
	for (i = 0; i < CONV_CORE_DIM; i++)
		for (j = 0; j < CONV_CORE_DIM; j++)
			for (k = 0; k < CONV1_OUT_DIM; k++)
				for (l = 0; l < CONV2_OUT_DIM; l++)
					f_conv2_w >> Conv2_W[i][j][k][l];
	f_conv2_w.close();

	ifstream f_conv2_b("conv2_b.txt");
	for (i = 0; i < CONV2_OUT_DIM; i++)
		f_conv2_b >> Conv2_B[i];
	f_conv2_b.close();

	ifstream f_fc1_w("fc1_w.txt");
	for (i = 0; i < (IMAGE_DIM / 4)*(IMAGE_DIM / 4)*CONV2_OUT_DIM; i++)
		for (j = 0; j < FC1_OUT_DIM; j++)
			f_fc1_w >> Fc1_W[i][j];
	f_fc1_w.close();

	ifstream f_fc1_b("fc1_b.txt");
	for (i = 0; i < FC1_OUT_DIM; i++)
		f_fc1_b >> Fc1_B[i];
	f_fc1_b.close();

	ifstream f_fc2_w("fc2_w.txt");
	for (i = 0; i < FC1_OUT_DIM; i++)
		for (j = 0; j < FC2_OUT_DIM; j++)
			f_fc2_w >> Fc2_W[i][j];
	f_fc2_w.close();

	ifstream f_fc2_b("fc1_b.txt");
	for (i = 0; i < FC2_OUT_DIM; i++)
		f_fc2_b >> Fc2_B[i];
	f_fc2_b.close();

	ifstream f_image("image.txt");
	for (i = 0; i < IMAGE_DIM; i++)
		for (j = 0; j < IMAGE_DIM; j++)
			f_image >> Input_Image[i][j];
	f_image.close();

	ofstream f_image_out("image_out_out.txt");
	for (i = 0; i < IMAGE_DIM; i++)
		for (j = 0; j < IMAGE_DIM; j++)
			f_image_out << Input_Image[i][j] << ", ";
	f_image_out << endl;
	f_image_out.close();
}

void Conv1() {
	int i, j, k;
	int i2, j2;
	double tmp_ans;
	for (i = 0; i < IMAGE_DIM; i++)
		for (j = 0; j < IMAGE_DIM; j++)
			for (k = 0; k < CONV1_OUT_DIM; k++) {
				tmp_ans = 0.0;
				for (i2 = -CONV_RANGE; i2 <= CONV_RANGE; i2++)
					for (j2 = -CONV_RANGE; j2 <= CONV_RANGE; j2++)
						if (i + i2 >= 0 && j + j2 >= 0 && i + i2 < IMAGE_DIM && j + j2 < IMAGE_DIM) {
							tmp_ans += Conv1_W[CONV_MID + i2][CONV_MID + j2][0][k] * Input_Image[i + i2][j + j2];
							calc_cnt++;
						}
				tmp_ans += Conv1_B[k];
				calc_cnt++;
				tmp_ans = RELU(tmp_ans);
				calc_cnt++;
				Conv1_Image[i][j][k] = tmp_ans;
			}
}

double max(double x1, double x2, double x3, double x4) {
	double ans = x1;
	ans = (x2 > ans) ? x2 : ans;
	ans = (x3 > ans) ? x3 : ans;
	ans = (x4 > ans) ? x4 : ans;
	return ans;
}

void MaxPool1() {
	int i, j, k;
	for (i = 0; i < IMAGE_DIM / 2; i++)
		for (j = 0; j < IMAGE_DIM / 2; j++)
			for (k = 0; k < CONV1_OUT_DIM; k++)
				Pool1_Image[i][j][k] = max(Conv1_Image[i * 2][j * 2][k],
					Conv1_Image[i * 2 + 1][j * 2][k],
					Conv1_Image[i * 2][j * 2 + 1][k],
					Conv1_Image[i * 2 + 1][j * 2 + 1][k]);
}

void Conv2() {
	int i, j, k;
	int i2, j2, k2;
	double tmp_ans;
	for (i = 0; i < IMAGE_DIM / 2; i++)
		for (j = 0; j < IMAGE_DIM / 2; j++)
			for (k = 0; k < CONV2_OUT_DIM; k++) {
				tmp_ans = 0.0;
				for (i2 = -CONV_RANGE; i2 <= CONV_RANGE; i2++)
					for (j2 = -CONV_RANGE; j2 <= CONV_RANGE; j2++)
						for (k2 = -CONV_RANGE; k2 < CONV1_OUT_DIM; k2++)
							if (i + i2 >= 0 && j + j2 >= 0 && i + i2 < IMAGE_DIM / 2 && j + j2 < IMAGE_DIM / 2) {
								tmp_ans += Conv2_W[CONV_MID + i2][CONV_MID + j2][k2][k] * Pool1_Image[i + i2][j + j2][k2];
								calc_cnt++;
							}
				tmp_ans += Conv2_B[k];
				calc_cnt++;
				tmp_ans = RELU(tmp_ans);
				calc_cnt++;
				Conv2_Image[i][j][k] = tmp_ans;
			}
}

void MaxPool2() {
	int i, j, k;
	for (i = 0; i < IMAGE_DIM / 4; i++)
		for (j = 0; j < IMAGE_DIM / 4; j++)
			for (k = 0; k < CONV2_OUT_DIM; k++)
				Pool2_Image[i][j][k] = max(Conv2_Image[i * 2][j * 2][k],
					Conv2_Image[i * 2 + 1][j * 2][k],
					Conv2_Image[i * 2][j * 2 + 1][k],
					Conv2_Image[i * 2 + 1][j * 2 + 1][k]);
}

void Flatten() {
	int i, j, k;
	for (i = 0; i < IMAGE_DIM / 4; i++)
		for (j = 0; j < IMAGE_DIM / 4; j++)
			for (k = 0; k < CONV2_OUT_DIM; k++) {
				Flat_Image[i*(IMAGE_DIM / 4)*CONV2_OUT_DIM + j * CONV2_OUT_DIM + k] = Pool2_Image[i][j][k];
				calc_cnt++;
			}
}

void Fc1() {
	int i, j;
	double tmp_ans;
	for (i = 0; i < FC1_OUT_DIM; i++) {
		tmp_ans = 0.0;
		for (j = 0; j < (IMAGE_DIM / 4)*(IMAGE_DIM / 4)*CONV2_OUT_DIM; j++) {
			tmp_ans += Flat_Image[j] * Fc1_W[j][i];
			calc_cnt++; 
		}
		tmp_ans += Fc1_B[i];
		calc_cnt++; 
		tmp_ans = RELU(tmp_ans);
		calc_cnt++;
		FC1_Image[i] = tmp_ans;
	}
}

void Fc2() {
	int i, j;
	double tmp_ans;
	for (i = 0; i < FC2_OUT_DIM; i++) {
		tmp_ans = 0.0;
		for (j = 0; j < FC1_OUT_DIM; j++) {
			tmp_ans += FC1_Image[j] * Fc2_W[j][i];
			calc_cnt++; 
		}
		tmp_ans += Fc2_B[i];
		calc_cnt++; 
		FC2_Image[i] = tmp_ans;
	}
}

void Get_Answer() {
	double max = FC2_Image[0];
	int max_point = 0;
	int i;
	for (i = 1; i < FC2_OUT_DIM; i++)
		if (FC2_Image[i] > max) {
			max = FC2_Image[i];
			max_point = i;
		}
	ans = max_point;

	double sum = 0;
	for (i = 0; i < FC2_OUT_DIM; i++) {
		Softmax[i] = exp(FC2_Image[i]);
		sum += Softmax[i];
	}
	for (i = 0; i < FC2_OUT_DIM; i++)
		Softmax[i] /= sum;
}