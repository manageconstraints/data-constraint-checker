import subprocess
import os
import sys
def findCommits(commits,d):
    size = 5
    location = d
    os.chdir(location)
    ans = []
    for i in range(0,size-1):
        ci = commits[i].strip()
        ci1 = commits[i+1].strip()
        print(ci, " vs ",ci1)
        system("")
        childp = subprocess.Popen([d, 'git diff ' + ci + ' ' + ci1 + '*.rb'],stdout=subprocess.PIPE, stderr= subprocess.STDOUT) 
        log, logerr = childp.communicate()
        ans.append(str(log).split('\\'))

    return ans


if __name__ == "__main__":
    location = "commits.txt"
    directory = sys.argv[1]
    fp = open(location,'r')
    with open(location,'r') as fp:
        commits = fp.readlines()
    #print(len(commits))
    results = findCommits(commits,directory)
    for i in results:
        print(i)
    


