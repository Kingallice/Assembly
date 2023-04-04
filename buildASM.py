import os
import argparse

argParser = argparse.ArgumentParser()
argParser.add_argument("-w", "--workspace", help="Workspace of vscode")
argParser.add_argument("-cwd", "--workingdirectory", help="Current working directory")
argParser.add_argument("-r", "--rel", help="Relative File")
argParser.add_argument("-b","--basename", help="Basename of file")
args = argParser.parse_args()

dir = "./Projects/"

inputfile=args.rel

#Ensures temp directory exists
if os.path.isdir(dir) == False:
    os.mkdir(dir)

def cleanDir(dir_path):
    if os.path.isdir(dir_path) == False:
        os.mkdir(dir_path)
    for file in os.scandir(dir_path):
        os.remove(file.path)

fileOpen = open(inputfile, "r")
data = fileOpen.read()
fileOpen.close()

includeString = "%include \""
data1 = data.replace(includeString, includeString+"linux-ex/")

print()

arrIncludes = []
location = 0
while data.find(includeString, location) != -1:
    location = data.find(includeString, location) + len(includeString)
    end = data.find("\"", location)
    arrIncludes.append(data[location:end])
    location = end

#creates/cleans directory for files
cleanDir(dir+"/"+args.basename)

fileOpen = open(dir+"/"+args.basename+"/"+"DEP"+args.basename+".asm","w")
fileOpen.write(data1)
fileOpen.close()
fileOpen = open(dir+"/"+args.basename+"/"+args.basename+".asm","w")
fileOpen.write(data)
fileOpen.close()

includes = ""
for inc in arrIncludes:
    includes += "'{workspace}/linux-ex/".format(workspace=args.workspace) + "".join(inc.split(".")[0:-1]) + ".o' "

nasm="nasm -f elf '{dir}{fileBasename}/DEP{fileBasename}.asm' -o '{dir}{fileBasename}/{fileBasename}.o'".format(dir=dir, relativeFile=args.rel,fileBasename=args.basename)
gcc="gcc -m32 -o '{dir}{fileBasename}/{fileBasename}' '{dir}{fileBasename}/{fileBasename}.o' '{workspace}/linux-ex/driver.c' {includes}".format(dir=dir, workspace=args.workspace,fileBasename=args.basename, includes=includes)
#print(nasm, "\n", gcc)
os.system(nasm)
os.system(gcc)
os.remove(dir+"/"+args.basename+"/"+"DEP"+args.basename+".asm")
os.system("{dir}{fileBasename}/{fileBasename}".format(dir=dir,fileBasename=args.basename))