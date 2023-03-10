#!/usr/bin/python3
import argparse
import json
import os
import re
from colorama import Fore
Success = False
LAGO_DIR=''
Top_level_file=''
#################### LAGO ROOT address #######################################
def LAGO_USR_INFO():
        global LAGO_DIR,Top_level_file,file
        Linux_file_path = os.path.expanduser("~/.LAGO_USR_INFO")
        with open(Linux_file_path, "r") as Shell_file:
            sh_file=Shell_file.readlines()
            LAGO_DIR=sh_file[0].replace("LAGO_DIR=","")+"/files/";
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
CURRENT_DIR=os.getcwd();
def update_ranges(file_name, new_range, port_name):
    with open(file_name, "r") as f:
        lines = f.readlines()
        found = False
        for i, line in enumerate(lines):
            if re.search(fr"\[(\d.*:\d.*)\].*\b{port_name}\b", line):
                found = True
                old_range = re.search(fr'\[(\d.*:\d.*)\]', line).group()
                if old_range == new_range:
                    print(Fore.RED + f"Error: Port status is already {new_range}" + Fore.RESET)
                    Success = False
                    return
                else:
                    updated_line = re.sub(fr"\[(\d.*:\d.*)\]", f"{new_range}", line)
                    lines[i] = updated_line
                    with open(file_name, "w") as f_out:
                        f_out.writelines(lines)
                    print(Fore.LIGHTGREEN_EX + f"Range for {port_name} port updated from {old_range} to {new_range}" + Fore.RESET)
                    Success = True
                    return Success
        if not found:
            print(Fore.RED + f"Error: {port_name} or range not found in {file_name}." + Fore.RESET)
            Success = False
            return Success


def update_ranges_json(new_range, port_name):
    with open(f'{Baseboard_path}/{Json_Top_file}.json', 'r') as f:
        data = json.load(f)
        old_range = data['clock']['ports'][port_name]['range']
        data['clock']['ports'][port_name]['range'] = new_range
        with open(f"{Baseboard_path}/{Json_Top_file}.json", 'w') as outfile:
            json.dump(data, outfile, indent=4)


def change_IO_status(file_name, new_status, port_name):
    with open(file_name, "r") as f:
        lines = f.readlines()
        found = False
        for i, line in enumerate(lines):
            if re.search(fr'\b(input|output)\b.*\b{port_name}\b', line):
                found = True
                port_type = re.search(fr'\b(input|output)\b', line).group()
                if port_type == new_status:
                    print(Fore.RED + f"Error: Port status is already {new_status}" + Fore.RESET)
                    Success = False
                    return Success
                else:
                    lines[i] = re.sub(fr'\b{port_type}\b', new_status, line)
                    with open(file_name, "w") as f:
                        f.writelines(lines)
                    print(Fore.LIGHTGREEN_EX +
                          f"Port status of {port_name} changed from {port_type} to {new_status}." + Fore.RESET)
                    Success = True
                    return Success
        if not found:
            print(Fore.RED + f"Error: {port_name} not found in {file_name}." + Fore.RESET)


def change_IO_status_json(port_name, new_status):
    with open(f'{Baseboard_path}/{Json_Top_file}.json', 'r') as f:
        data = json.load(f)
        old_status = data['clock']['ports'][port_name]['type']
        data['clock']['ports'][port_name]['type'] = new_status
        with open(f"{Baseboard_path}/{Json_Top_file}.json", 'w') as outfile:
            json.dump(data, outfile, indent=4)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Update file contents')
    parser.add_argument('-f','--file_name', help='Name of the file to update')
    parser.add_argument('-a','--operation', choices=['update_range', 'update_range_json', 'change_IO_status', 'change_IO_status_json'])
    parser.add_argument('-nr','--new_range', help='New range to update (for update_range and update_range_json operations)')
    parser.add_argument('-p','--port_name', help='Name of the port to update (for update_range, update_range_json, change_IO_status, and change_IO_status_json operations)')
    parser.add_argument('-ns','--new_status', choices=['input', 'output'], help='New status to update (for change_IO_status and change_IO_status_json operations)')
    args = parser.parse_args()

    Top_level_file = arg.file_name
    LAGO_USR_INFO()
    Baseboard_path = os.path.join(LAGO_DIR,'Baseboard')
    Json_Top_file=Top_level_file.replace(".sv",'')

    if args.operation == 'update_range':
        Success = update_ranges(Top_level_file, args.new_range, args.port_name)
        if Success:
            update_ranges_json(args.new_range, args.port_name)
    elif args.operation == 'change_IO_status':
        change_IO_status(Top_level_file, args.new_status, args.port_name)
        if Success:
            change_IO_status_json(args.port_name, args.new_status)
