import subprocess
import os
import re
import sys
#subprocess.run(["cd","~/Desktop/FormatCheck/software/cassandra"])

def FilterCommits(log):
    #m = re.findall('(?<=commit).*?(?=[Merge|Author])',str(log))
    #m = re.findall('.*?(?=\\n)',str(log))
    #m = re.findall("\\n","\\n")
    m = str(log).split('\n')
    sts2 = [x.split(' ')[1] for x in m if x.startswith("commit ") ]
    # it is strange that sometimes sts2 would contain the empty string.
    sts = [x for x in sts2 if len(x) == 40] 
    # the length of all the commit number is 40, filter them
    return sts

if __name__ == "__main__":
    location=sys.argv[1]; 
    os.chdir(location)
    childp = subprocess.Popen(["git","log"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    log,logerr = childp.communicate()
    #print(log)

    m = FilterCommits(log)
    fp = open("commits.txt", 'w')
    for i in m:
        fp.write(i)
        print(i)
    fp.close()

    

