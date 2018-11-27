/*
 * LCD1602_Qsys.c
 *
 *  Created on: 2017年7月9日
 *      Author: DaYa
 */
#include "LCD1602_Qsys.h"
#include "system.h"
unsigned int *pUser_LCD=LCD1602_DEMO_BASE; //定义指针指向在Qsys中生成的LCD1602控制模块

/*
 * 函数名      ：   LCD_Disp()
 * 功能           :  将指定长度的数据在DE2-115开发板LCD1602上显示
 * 输入参数 ：   Row     ->显示行位置 ,范围1或2。
 *            position->数据显示位置，从0开始到15
 *            *pData  ->输入显示缓存指针
 *            len     ->待显示字数，这里注意显示长度+位置之和不能超过LCD一行最大值15
 * 返回参数 ：   无
 */
void LCD_Disp(unsigned char Row, unsigned char position , unsigned char *pData , unsigned char len)
{
	unsigned char i;
	unsigned char busy;
	unsigned int j;
	unsigned char Row_Line;
	//判断写入行位置是否正确
	if(Row==1)
		Row_Line=0x00;
	else if(Row==2)
	    Row_Line=0x40;
	else
		Row_Line=0x00;

	//检查写入位置是否越界
	if(position<0)
		position=0;
	else if(position>15)
		position=15;
	//检查单行写入是否会超过最大显示个数
	if((len+position)>15)
		len=15-position;
	//将待显示数据写入缓存数据
	for(i=0;i<len;i++)
	{
		*(pUser_LCD+i+1)=*(pData+i); //写入地址从1开始
	}
	//检查写入模块当前是否忙
	do{
		busy=*(pUser_LCD) & 0xf ;
	  }
	while(busy!=5);
    //写入使能指令
	*(pUser_LCD)=(position<<24)+(len<<16)+(Row_Line<<8)+0x33;
	for(j = 0; j < 50000; j++);
}


/*
 * 函数名      ：   LCD_Clear()
 * 功能           :  将当前LCD1602上显示的内容清除
 * 输入参数 ：   无
 * 返回参数 ：   无
 */
void LCD_Clear()
{
	unsigned char busy;
	//检查写入模块当前是否忙
	do{
		busy=*(pUser_LCD) & 0xf ;
	  }
	while(busy!=5);
	//写入使能指令
	*(pUser_LCD)=0x55;
}

/*
 * 函数名      ：   LCD_Reset()
 * 功能           :  复位LCD1602,显示内容全部清除
 * 输入参数 ：   无
 * 返回参数 ：   无
 */
void LCD_Reset()
{
	unsigned char busy;
	//检查写入模块当前是否忙
	do{
		busy=*(pUser_LCD) & 0xf ;
	  }
	while(busy!=5);
	//写入使能指令
	*(pUser_LCD)=0xff;
}

