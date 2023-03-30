import os
import argparse

argParser = argparse.ArgumentParser()
argParser.add_argument("-w", "--workspace", help="Workspace of vscode")
argParser.add_argument("-cwd", "--workingdirectory", help="Current working directory")
argParser.add_argument("-r", "--rel", help="Relative File")
argParser.add_argument("-b","--basename", help="Basename of file")
args = argParser.parse_args()

dir = "./temp"

inputfile=args.basename+".asm"

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
data = data.replace("linux-ex/","")

#creates/cleans directory for files
cleanDir(dir+"/"+args.basename)

fileOpen = open(dir+"/"+args.basename+"/"+inputfile,"w")
fileOpen.write(data)
fileOpen.close()

nasm="nasm -f elf {relativeFile} -o temp/{fileBasename}/{fileBasename}.o".format(relativeFile=args.rel,fileBasename=args.basename)
gcc="gcc -m32 -o temp/{fileBasename}/{fileBasename} temp/{fileBasename}/{fileBasename}.o {workspace}/linux-ex/driver.c {workspace}/linux-ex/asm_io.o".format(workspace=args.workspace,fileBasename=args.basename)
print(nasm, "\n", gcc)
os.system(nasm)
os.system(gcc)