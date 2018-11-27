/*
 * LCD1602_Qsys.h
 *
 *  Created on: 2017年7月9日
 *      Author: DaYa
 */

#ifndef LCD1602_QSYS_H_
#define LCD1602_QSYS_H_

#include "system.h"

/*
 * 函数名      ：   LCD_Disp()
 * 功能           :  将指定长度的数据在DE2-115开发板LCD1602上显示
 * 输入参数 ：   Row     ->显示行位置 ,范围1或2。
 *            position->数据显示位置，从0开始到15
 *            *pData  ->输入显示缓存指针
 *            len     ->待显示字数，这里注意显示长度+位置之和不能超过LCD一行最大值15
 * 返回参数 ：   无
 */
void LCD_Disp(unsigned char Row, unsigned char position , unsigned char *pData , unsigned char len);

/*
 * 函数名      ：   LCD_Clear()
 * 功能           :  将当前LCD1602上显示的内容清除
 * 输入参数 ：   无
 * 返回参数 ：   无
 */
void LCD_Clear();

/*
 * 函数名      ：   LCD_Reset()
 * 功能           :  复位LCD1602,显示内容全部清除
 * 输入参数 ：   无
 * 返回参数 ：   无
 */
void LCD_Reset();

#endif /* LCD1602_QSYS_H_ */
