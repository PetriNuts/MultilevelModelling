# -*- coding: utf-8 -*-
"""
Created on Sat Sep 12 13:19:05 2020

@author: hs
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# the number of the hexagons
GridRow = 8
GridColumn = 8
NotchNumber = GridRow * GridColumn

# 颜色与样式
color_high = [1,0.8549,0.7686]    # NA大于1的颜色
color_low = [1,1,1]  # NA小于1的颜色
edge_type = 'k-' # 边框

# 从csv文件读取数据
dataDN = pd.read_csv(r'./Delta-Notch-patternformation.csv', sep=',')
row, column = dataDN.shape

DN = dataDN.iloc[row - 1, 1 : 1 + NotchNumber]
DD =  dataDN.iloc[row - 1, 1 + NotchNumber : 1 + NotchNumber * 2]

# the parameters of the hexagon
theta = np.linspace(0, 2 * np.pi, 7)
r = 3
d = 3 * r / 2
h = np.sqrt(3) * r / 2

# the center coordinates of the first hexagon
x0 = h
y0 = r

fig = plt.figure(figsize=(h * (GridColumn * 2 + 1) / 5, r * (0.5 + 1.5 * GridRow) / 5))
ax = fig.add_subplot(1, 1, 1)

count = 0

for j in range(GridRow - 1, -1, -1):
    if j % 2 == 1:
        for i in range(0, GridColumn):
            x = x0 + i * 2 * h    # x为cell的中心位置的x坐标
            y = y0 + j * d;       # y为cell的中心位置的y坐标
            plt.plot(r * np.sin(theta) + x, r * np.cos(theta) + y, edge_type)
            pgon = plt.Polygon([[xi, yi] for xi, yi in zip(r * np.sin(theta) + x, r * np.cos(theta) + y)],
                         color=color_low)
            ax.add_patch(pgon)
            
            if DN[count] >= 1:
                pgon = plt.Polygon([[xi, yi] for xi, yi in zip(r * np.sin(theta) + x, r * np.cos(theta) + y)],
                             color=color_high)
                ax.add_patch(pgon)
                
            plt.text(x - 2, y - 0.5, '%f' % DD[count], FontSize=8)
            plt.text(x - 2, y + 0.5, '%f' % DN[count], FontSize=8)
            count = count + 1;

    else:
        for i in range(0, GridColumn):
            x = x0 + h + i * 2 * h;    # x为cell的中心位置的x坐标
            y = y0 + j * d;            # y为cell的中心位置的y坐标
            plt.plot(r * np.sin(theta) + x, r * np.cos(theta) + y, edge_type)
            pgon = plt.Polygon([[xi, yi] for xi, yi in zip(r * np.sin(theta) + x, r * np.cos(theta) + y)],
                                color= color_low)
            ax.add_patch(pgon)
               
            if DN[count] >= 1:
                pgon = plt.Polygon([[xi, yi] for xi, yi in zip(r * np.sin(theta) + x, r * np.cos(theta) + y)],
                             color=color_high)
                ax.add_patch(pgon)
                
            plt.text(x - 2, y - 0.5, '%f' % DD[count], FontSize=8)
            plt.text(x - 2, y + 0.5, '%f' % DN[count], FontSize=8)
            count = count + 1


ax.set_xticks(np.linspace(h, h * (GridColumn * 2), GridColumn * 2))
ax.set_xticklabels([i for i in range(1, GridColumn * 2 + 1)])
ax.xaxis.set_ticks_position('top')
ax.set_yticks(np.linspace(r, r * (GridRow * 1.5 - 0.5), GridRow))
ax.set_yticklabels([i for i in range(GridRow, 0, -1)])
ax.set_xlim(0, h * (GridColumn * 2 + 1))
ax.set_ylim(0, r * (0.5 + 1.5 * GridRow))
plt.show()