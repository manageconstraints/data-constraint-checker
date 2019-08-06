import numpy as np
import matplotlib.pyplot as plt
import os
from matplotlib import colors as mcolors

app_names = open("app_names.txt").read().split("\n")
colors = dict(mcolors.BASE_COLORS, **mcolors.CSS4_COLORS)
fig = plt.figure()
index = 1
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
        axes = fig.add_subplot(3, 2,index)
        index += 1
        #axes.title(app)
        axes.scatter(x, y, s=area, c=color, alpha=0.5)
        axes.title.set_text(app)
        axes.title.set_size(8)
        for label in (axes.get_xticklabels() + axes.get_yticklabels()):
            label.set_fontsize(8)
        # plt.scatter(x, y, s=area, c=color, alpha=0.5)
        # plt.savefig(output, dpi = 300, bbox_inches='tight')
        # plt.close()
plt.subplots_adjust(hspace = 0.4, wspace = 0.15)
plt.savefig("output/total.png", dpi = 300, bbox_inches='tight')
