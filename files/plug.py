#!/usr/bin/python3
import os
import argparse
import json
import Extracting_data
import add_in_out
import colorama
import shutil
from colorama import Fore
LAGO_DIR=''
Top_level_file=''
#################### LAGO ROOT address #######################################
def LAGO_USR_INFO():
        global LAGO_DIR,Top_level_file,file,top_file
        Linux_file_path = os.path.expanduser("~/.LAGO_USR_INFO")
        with open(Linux_file_path, "r") as Shell_file:
            sh_file=Shell_file.readlines()
            LAGO_DIR=sh_file[0].replace("LAGO_DIR=","")+"/files/";
            if top_file:
             if f"TOP_FILE={top_file}\n" in sh_file:
                Top_level_file=top_file
             else:
                print(f"{top_file} is not present")
                exit()
            else:
                Top_level_file=sh_file[-1]
        LAGO_DIR=LAGO_DIR.replace("\n","")
        Top_level_file=Top_level_file.replace("TOP_FILE=",'')
##############################################################################
CURRENT_DIR=os.getcwd();
def copy_file(file):
   global CURRENT_DIR,library_file
   if not os.path.exists(f"{CURRENT_DIR}/{file}"):
        shutil.copy(library_file,CURRENT_DIR)

def extract_data(file):                   # it will open library file
    global Top_level_file,CURRENT_DIR,instance
    with open(f"{file}", 'r') as f:
        lines = f.readlines()
    in_module = False
    input_or_output_count = 0
    output_string = ""
    for line in lines:
        if 'module' in line and not in_module:
            in_module = True
            module_name = line.split()[1]
            output_string += module_name + ' ' + f'{instance}' + '\n'
            output_string += "(\n"
        if 'input' in line or 'output' in line:
            input_or_output_count += 1
            words = line.strip().split()
            x = words[-1]
            if "," in x:
                x = x.split(",")[0]
            if input_or_output_count == sum(('input' in line) or ('output' in line) for line in lines):
                output_string += '.' + x + '\t\t\t()\n'
            else:
                output_string += '.' + x + '\t\t\t(),\n'

    with open(f"{CURRENT_DIR}/{Top_level_file}", "r") as f:      #open top level file for inst checking
        content = f.read()
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if instance in line and ('input' or 'output') not in line:
                print(Fore.RED +
                      f'Error: instance {instance} already exists at line {i+1}. Please Enter different name!' + Fore.RESET)
                exit()
        with open(f"{CURRENT_DIR}/{Top_level_file}", "a+") as f:   #open top file in append mode
            if 'endmodule' in content:
                r_end = (f.tell())-9
                x = f.truncate(r_end)
                f.write('\n\n' + output_string)
                f.write(');')
                f.write('\n\nendmodule')
            print(
                Fore.GREEN + f'instance {instance} is successfully pluged in {Top_level_file}.' + Fore.RESET)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--instance_name', help='Name of instance')
    parser.add_argument('-f', '--file_name',
                        help='Name of file from which instance is taken',type=str)
    parser.add_argument('-t', '--top_file', help='other top level file',type=str)
    parser.add_argument('-i', '--inputs', type=str,
                        nargs='+', help='Input port name')
    parser.add_argument('-ir', '--input_ranges', type=str,
                        nargs='+', help='Input port range')
    parser.add_argument('-o', '--outputs', type=str,
                        nargs='+', help='Output port name')
    parser.add_argument('-or', '--output_ranges',
                        nargs='+', help='Output port range')
    args = parser.parse_args()
    file = args.file_name
    top_file=args.top_file
###################################################################################################
    LAGO_USR_INFO()			      #---->
    Baseboard_path = os.path.join(LAGO_DIR,'Baseboard')
######################################################################################################
    if args.inputs or args.outputs:
       add_in_out.add_inputs_outputs(           # add extra inputs and outputs
       Top_level_file,args.inputs,args.outputs,args.input_ranges,args.output_ranges,Baseboard_path)
#####################################################################################################
    if file and Top_level_file:
      library = os.path.join(LAGO_DIR,'library')
      library_file = os.path.join(library,file) #--->
      if args.instance_name:
         instance = args.instance_name
      else:
         instance = file.replace(".sv",'')

      copy_file(library_file)
      extract_data(library_file)
      data = Extracting_data.get_ranges_from_file(library_file)
      Top_level_file=Top_level_file.replace(".sv",'')
      with open(f"{Baseboard_path}/{Top_level_file}.json", "rb") as f:
            content = f.read()
            f.seek(0, 2)
      with open(f'{Baseboard_path}/{Top_level_file}.json', 'a+') as f:
            r_end = (f.tell())-1
            x = f.truncate(r_end)
            f.write(f',\n\"{instance}\":')
            json.dump(data, f, indent=4)
            f.write("\n}")
