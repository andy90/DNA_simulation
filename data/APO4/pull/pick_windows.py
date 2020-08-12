# pick the configuration with the right spacing

import numpy as np


t,x=np.loadtxt("pullx.xvg",unpack=True)

dr=0.05  # pick the spacing
nwindow=18 # number of windows

spacing=np.zeros(nwindow)

for i in range(nwindow):
    spacing[i]=0.3+dr*i




index=np.zeros(nwindow,np.int)
real_spacing=np.zeros(nwindow)
for j in range(nwindow):

    index[j]=min(range(len(x)),key=lambda i: abs(x[i]-spacing[j]))
    real_spacing[j]=x[index[j]]
print index
print real_spacing

import os
import shutil
if not os.path.exists("./windows"):
    os.mkdir("./windows")

for i in range(nwindow):
    
    shutil.copyfile("./conf"+str(index[i])+".gro","./windows/start_"+str(i)+".gro")
    print "./conf"+str(index[i])+".gro  copied"
