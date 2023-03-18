#!/usr/bin/python3
import argparse
import os
import json
import re
from colorama import Fore
found = False

LAGO_DIR=''
Top_level_file=''
CURRENT_DIR=os.getcwd()
#################### LAGO ROOT address #######################################
def LAGO_USR_INFO():
        global LAGO_DIR,Top_level_file
        Linux_file_path = os.path.expanduser("~/.LAGO_USR_INFO")
        with open(Linux_file_path, "r") as Shell_file:
            sh_file=Shell_file.readlines()
            LAGO_DIR=sh_file[0].replace("LAGO_DIR=","")+"/files/"
            if Top_level_file:
             if f"TOP_FILE={Top_level_file}\n" in sh_file:
                pass
             else:
                print(f"{Top_level_file} is not present")
                exit()
            else:
                Top_level_file=sh_file[-1]
        LAGO_DIR=LAGO_DIR.replace("\n","")
        Top_level_file=Top_level_file.replace("TOP_FILE=",'')
##############################################################################
      
def check_range_equality(inst1, inst2, k1, k2):
    instance2 = Top_level_file.replace('.sv','')
    global found
    try:
        for i1, i2, k1, k2 in zip(args.instance1, instance2,args.input_ports, args.output_ports):
            range1 = data[inst1]['ports'][k1]['range']
            range2 = data[inst2]['ports'][k2]['range']
            if range1 == range2:
                found = True
            else:
                print(
                    Fore.RED + f'Error: Range of {k1} is {range1} and range of {k2} is {range2} which is not equal!!' + Fore.RESET)
                exit()
        return found
    except KeyError:
        for i1, i2, k1, k2 in zip(args.instance1,args.input_ports, args.output_ports):
            if inst1 not in data:
                print(
                    Fore.RED + f'Error: Instance {inst1} not found' + Fore.RESET)
            elif inst2 not in data:
                print(
                    Fore.RED + f'Error: Instance {inst2} not found' + Fore.RESET)
            elif k1 not in data[inst1]['ports']:
                print(
                    Fore.RED + f'Error: Port {k1} not found of instance {inst1}' + Fore.RESET)
            elif k2 not in data[inst2]['ports']:
                print(
                    Fore.RED + f'Error: Port {k2} not found of instance {inst2}' + Fore.RESET)
            found = False
        return found

def change_line_in_instance(found, instance1, input_ports, output_ports):
    with open(f"{Top_level_file}", 'r') as f:
        content = f.read()
    pattern = rf'{instance1}\s*(([\s\S]*?));'
    match = re.search(pattern, content)
    if found and match:
        block = match.group()
        for input_port, output_port in zip(input_ports, output_ports):
            pattern = rf'\.{input_port}\s*\((?P<connected_port>.*)\)'
            existing_connections = re.findall(pattern, block)
            for connected_port in existing_connections:
                pattern = rf'\.{input_port}\s*\([\s\S]*?\)' 
                if connected_port:
                    connected_ports_list = [port.strip() for port in connected_port.strip('(){}').split(',')]
                    if output_port in connected_ports_list:
                        print(Fore.RED + f"Error: {output_port} already connected to {input_port}" + Fore.RESET)
                        exit()
                    else:
                        connected_ports_list.append(output_port)
                    connected_ports_str = '{{{}}}'.format(', '.join(connected_ports_list))
                    block = re.sub(pattern, fr'.{input_port} \t\t\t\t({connected_ports_str})', block)
                else:
                    block = re.sub(pattern, f'.{input_port} \t\t\t\t({output_port})', block)       
            pattern = rf'{instance1}\s*(([\s\S]*?));'
            content = re.sub(pattern, block, content)
            print(Fore.LIGHTGREEN_EX + 'Ports Connected.' + Fore.RESET)
        
    # Write the modified content back to the file
    with open(f'{Top_level_file}', 'w') as f:
        f.write(content)


if __name__ == '__main__':
    # Create an argument parser
    parser = argparse.ArgumentParser(
        description='Change lines in instances in  file')
    # Add arguments for the instances and ports
    parser.add_argument('-i', '--instance1',help='Name of the first instance')
    
    parser.add_argument('-o', '--instance2',  help='Name of the second instance')
    
    parser.add_argument('-ip', '--input_ports', nargs='+', type=str,help='Input ports of the first instance')
    
    parser.add_argument('-op', '--output_ports', nargs='+', type=str,help='Output ports of the second instance')
    
    parser.add_argument('-f', '--filename', help='other top level file',type=str)
    # Parse the arguments
    args = parser.parse_args()
    Top_level_file = args.filename

    LAGO_USR_INFO()
    Baseboard_path = os.path.join(LAGO_DIR,'Baseboard')
    json_file=Top_level_file.replace(".sv",'.json')
    
    with open(f'{Baseboard_path}/{json_file}', 'r') as f:
       data = json.load(f)

    instance2 = Top_level_file.replace('.sv','')
    found = check_range_equality(
       args.instance1, instance2, args.input_ports, args.output_ports)
    change_line_in_instance(found, args.instance1,
                           args.input_ports, args.output_ports)