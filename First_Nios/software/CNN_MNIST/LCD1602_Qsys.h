/*
 * LCD1602_Qsys.h
 *
 *  Created on: 2017��7��9��
 *      Author: DaYa
 */

#ifndef LCD1602_QSYS_H_
#define LCD1602_QSYS_H_

#include "system.h"

/*
 * ������      ��   LCD_Disp()
 * ����           :  ��ָ�����ȵ�������DE2-115������LCD1602����ʾ
 * ������� ��   Row     ->��ʾ��λ�� ,��Χ1��2��
 *            position->������ʾλ�ã���0��ʼ��15
 *            *pData  ->������ʾ����ָ��
 *            len     ->����ʾ����������ע����ʾ����+λ��֮�Ͳ��ܳ���LCDһ�����ֵ15
 * ���ز��� ��   ��
 */
void LCD_Disp(unsigned char Row, unsigned char position , unsigned char *pData , unsigned char len);

/*
 * ������      ��   LCD_Clear()
 * ����           :  ����ǰLCD1602����ʾ���������
 * ������� ��   ��
 * ���ز��� ��   ��
 */
void LCD_Clear();

/*
 * ������      ��   LCD_Reset()
 * ����           :  ��λLCD1602,��ʾ����ȫ�����
 * ������� ��   ��
 * ���ز��� ��   ��
 */
void LCD_Reset();

#endif /* LCD1602_QSYS_H_ */
