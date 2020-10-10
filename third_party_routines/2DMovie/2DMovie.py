# -*- coding: utf-8 -*-
"""
Created on Wed Oct  7 11:18:11 2020

@author: hs
"""

import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
from matplotlib import animation 
from mpl_toolkits.axes_grid1 import make_axes_locatable

 # 读取数据
data = pd.read_csv('./diffusion_2D60.csv', sep=',')

num_frames = data.shape[0]

# 设置行列数
row, col = 60, 60

mp4_filename = r'./2D_diffusion_zs.mp4'

fig, ax = plt.subplots()
ax.set_xlim(0, col - 0.5)
ax.set_ylim(0, row - 0.5)

div = make_axes_locatable(ax)
cax = div.append_axes('right', '5%', '5%')

img = ax.imshow(np.zeros((row, col)), cmap=plt.cm.inferno, vmin=0, vmax=0, origin='lower')
cbr = fig.colorbar(img, cax=cax)

def turn_line(line):
    '''
    处理csv的一行, 返回shape为(row, col)的ndarry
    '''
    res = np.zeros((row, col))
    
    for index in line.index:
        if index == 'Time':
            continue
        coordinate = []
        tokens = index.split('_')
        for token in tokens:
            if str.isdigit(token):
                coordinate.append(int(token))
        res[coordinate[0] - 1][coordinate[1] - 1] = line[index]
    return res
    
def update(i):
    X = turn_line(data.iloc[i])
    vmax = np.max(X)
    vmin = 0
    img.set_data(X)
    img.set_clim(vmin, vmax)
    filename = r'./results/frame_{0}'.format(i)
    plt.savefig(filename)

ani = animation.FuncAnimation(fig, update, frames=range(num_frames), interval=100, repeat=False)
Writer = animation.writers['ffmpeg']
writer = Writer()
ani.save(mp4_filename, writer)
plt.show()
