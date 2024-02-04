import subprocess
import re
import os
import argparse
#from pathlib import Path

parser = argparse.ArgumentParser(
	description='Calculate average Euler number from lh.orig.nofix and rh.orig.nofix surfaces to estimate image quality. Freesurfer needs to be installed.')

parser.add_argument('-i','--input_file', metavar='INPUTFILE', help = 'file with list of freesurfer subject ids, one per line.', required=True)
parser.add_argument('-o','--output_file', metavar='OUTPUTFILE', help = 'output csv file', required=True)
args = parser.parse_args()

# Specify the environment variable name
variable_name = 'SUBJECTS_DIR'

# Get the value or raise an error if it's not set
variable_value = os.environ.get(variable_name)

if variable_value is None:
    raise ValueError(f"The environment variable {variable_name} is not set.")
else:
    # Use the variable_value as needed
    #print(f"The value of {variable_name} is: {variable_value}")
    fsSubDir = os.getenv('SUBJECTS_DIR')

# error messages
# SUBJECTS_DIR not set - done
# lh/rh.orig.nofix not found


def extractEuler(myOrigNoFix):
	subProcOut = subprocess.run(["mris_euler_number", myOrigNoFix], capture_output=True, text=True)
	# need to check if stdout or stderr captures the mris_euler_number output
	if subProcOut.stdout:
		#print("stdout")
		first_line = subProcOut.stdout.split('\n')[0]
		if "euler #" in first_line:
			s = subProcOut.stdout.splitlines()[0]
	else:
		if subProcOut.stderr:
			#print("stderr")
			first_line = subProcOut.stderr.split('\n')[0]
			if "euler #" in first_line:
				s = subProcOut.stderr.splitlines()[0]
	pattern = r'= (-?\d+) -->'
	match = re.search(pattern, s)
	return(int(match.group(1)))

def calcAvgEuler(subjectId,fsSubDir):
	# create paths to lh.orig.nofix and rh.orig.nofix
	lhPath = os.path.join(fsSubDir,subjectId,'surf/lh.orig.nofix')
	rhPath = os.path.join(fsSubDir,subjectId,'surf/rh.orig.nofix')
	lhEuler = extractEuler(lhPath)
	rhEuler = extractEuler(rhPath)
	eulerAvg = (lhEuler + rhEuler)/2
	return(eulerAvg)

with open(args.output_file, 'w') as output_file:
	
	output_file.write("subjectId,avgEuler\n")

	with open(args.input_file, 'r') as file:
	    for line in file:
	        # Process each line as needed
	        subject = line.strip()  # strip removes leading and trailing whitespaces
	        try:
	        	myEuler = calcAvgEuler(subject,fsSubDir)
	        except:
	        	print("calcAveEuler failed, file probably missing")
	        else:
	        	myEuler = calcAvgEuler(subject,fsSubDir)
	        	print('subject',subject,'average euler = ',myEuler)
	        	output_file.write(f"{subject},{myEuler}\n")

print(f"Results written to {args.output_file}")
	        
