import numpy as np
import matplotlib.pyplot as plt
import os
from matplotlib import colors as mcolors

app_names = open("app_names.txt").read().split("\n")
colors = dict(mcolors.BASE_COLORS, **mcolors.CSS4_COLORS)

for app in app_names:
    filename = "log/codechange_{}.log".format(app)
    if os.path.exists(filename):
        output = "output/{}.png".format(app)
        array = np.loadtxt("log/codechange_{}.log".format(app))
        print(len(array))
        print(app)
        color = colors['salmon']
        area = np.pi*3

        x = array[:, 1] + array[:, 2]
        y = array[:,3] + array[:,4] + array[:,5] + array[:, 6] + array[:,11] + array[:, 12]
        plt.xlabel('line of code change')
        plt.ylabel('added/changed constraints')
        plt.title(app)
        plt.scatter(x, y, s=area, c=color, alpha=0.5)
        plt.savefig(output, dpi = 300)
        plt.close()
