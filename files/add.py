#!/usr/bin/python3
import re
import os
import argparse,json
from colorama import Fore
import addparam
import changeIOandRange
LAGO_DIR = ''
Top_level_file = ''
CURRENT_DIR = os.getcwd()
#################### LAGO ROOT address #######################################


def LAGO_USR_INFO():
    global LAGO_DIR, Top_level_file
    Linux_file_path = os.path.expanduser("~/.LAGO_USR_INFO")
    with open(Linux_file_path, "r") as Shell_file:
        sh_file = Shell_file.readlines()
        LAGO_DIR = sh_file[0].replace("LAGO_DIR=", "")+"/files/"
        if Top_level_file:
            if f"TOP_FILE={Top_level_file}\n" in sh_file:
                pass
            else:
                print(f"{Top_level_file} is not present")
                exit()
        else:
            Top_level_file = sh_file[-1]
    LAGO_DIR = LAGO_DIR.replace("\n", "")
    Top_level_file = Top_level_file.replace("TOP_FILE=", '')


##############################################################################


def add_inputs_outputs(fileName,inputs,input_ranges,outputs,output_ranges,Baseboard_path):
    print("Base path is  : ",Baseboard_path)
    instance1 = fileName.replace('.sv','')
    with open(fileName, 'r') as f:
        content = f.read()
    pattern = rf'{instance1}\s*\((.*?)\);'
    match = re.search(pattern, content, re.DOTALL)
    if match:
        existing_ports = match.group(1)
        existing_ports = existing_ports.rstrip()
        if existing_ports != '':
            existing_ports += ','
        else:
            existing_ports += ' '
        Body = ''
        if inputs:
            i = ""
            for inp, inp_ranges in zip(inputs, input_ranges):
                if inp in existing_ports:
                    print(Fore.RED + f"{inp} already exist in {fileName}" + Fore.RESET)
                    exit()
                else:
                    if inp_ranges == 'None' or inp_ranges == 'none':
                        inpu = f"\ninput\tlogic\t\t{(i.join(inp))},"
                        print(Fore.GREEN + f"{inp} is added in {fileName}" + Fore.RESET)
                        Body = Body + inpu
                    else:
                        inpu = f"\ninput\tlogic\t{inp_ranges}\t{(i.join(inp))},"
                        print(Fore.GREEN + f"{inp} is added in {fileName}" + Fore.RESET)
                        Body = Body + inpu
                    with open(f'{Baseboard_path}/{instance1}.json') as f:
                        data = json.load(f)
                        data[instance1]["ports"][inp] = {
                                "type": "input", "range": inp_ranges}
                    with open(f'{Baseboard_path}/{instance1}.json', 'w') as f:
                                json.dump(data, f, indent=4)
        if outputs:
            o = ""
            for out, opt_ranges in zip(outputs, output_ranges):
                if out in existing_ports:
                    print(Fore.RED + f"{out} already exist in {fileName}" + Fore.RESET)
                    exit()
                else:
                    if opt_ranges == 'None' or opt_ranges == 'none':
                        outu = f"\noutput\tlogic\t\t{o.join(out)},"
                        print(Fore.GREEN + f"{out} is added in {fileName}" + Fore.RESET)
                        Body = Body + outu
                    else:
                        outu = f"\noutput\tlogic\t{opt_ranges}\t{o.join(out)},"
                        print(Fore.GREEN + f"{out} is added in {fileName}" + Fore.RESET)
                        Body = Body + outu
                    with open(f'{Baseboard_path}/{instance1}.json') as f:
                        data = json.load(f)
                        data[instance1]["ports"][out] = {
                                "type": "input", "range": opt_ranges}
                    with open(f'{Baseboard_path}/{instance1}.json', 'w') as f:
                                json.dump(data, f, indent=4)
        Body = Body.rstrip(",")
        new_instance_text = f'{instance1} ({existing_ports}{Body}\n);'
        new_content = content.replace(match.group(0), new_instance_text)
        with open(fileName, "w") as f:
            f.write(new_content)
    else:
        print(f"No instance of {instance1} found in {fileName}")
   
if __name__ == '__main__':
    parser = argparse.ArgumentParser()       
    parser.add_argument('-p',"--port",action='store_true')
    parser.add_argument('-c',"--chnage",type=str,help='change IO status or range')
    parser.add_argument('-P', '--parameter', type=str,help='the name of the parameter(s) to add')
    parser.add_argument('-v', '--value', dest='value', type=str,default=['None'], help='the value of the parameter(s) to add')
    
    
    parser.add_argument('-nr','--new_range', help='New range of input or output port')
    parser.add_argument('-pr','--port_name', help='Name of the port to update (for update_range, update_range_json, change_IO_status, and change_IO_status_json operations)')
    parser.add_argument('-ns','--new_status', choices=['input', 'output'], help='New status to update (for change_IO_status and change_IO_status_json operations)')

    
    parser.add_argument('-t,','--topfile',help='Top level file name', type=str)
    
    parser.add_argument('-i', '--inputs',help='Input port name')
    parser.add_argument('-ir', '--input_ranges',help='Input port range')
    parser.add_argument('-o', '--outputs',help='Output port name')
    parser.add_argument('-or', '--output_ranges',help='Output port range')
    args=parser.parse_args()
    
    Top_level_file = args.topfile
    
    
    LAGO_USR_INFO()
    Baseboard_path = os.path.join(LAGO_DIR, 'Baseboard')
    if args.port:
        if args.inputs or args.outputs:
            add_inputs_outputs(Top_level_file,args.inputs,args.input_ranges,args.outputs,args.output_ranges,Baseboard_path)
            exit()
        else:
            print("Please provide input or output port name")
            print("Example:add -p <port> -i <inputs> 'clk' -o <outputs> 'rst' -t <topfile> 'top.sv")
            exit()
    elif args.parameter:
        if args.value:
           addparam.adding_parameters(Top_level_file,args.parameter,args.value)
        else:
            print("Please provide value for parameter(s) to add")
            print("Example:add -P <parameter> 'WIDTH' -v <value> '32' -t <topfile> 'top.sv")
            exit()
            
    elif args.chnage:
        if args.change=='range':
            if args.port_name and args.new_range:
                changeIOandRange.update_range(Top_level_file,args.port_name,args.new_range,Baseboard_path)
            else:
                print("Please provide port name and new range")
                print("Example:add -c <change> 'range' -p <port_name> 'clk' -nr <new_range> '32' -t <topfile> 'top.sv")
                exit()
        elif args.change=='port':
            if args.port_name and args.new_status:
                changeIOandRange.change_IO_status(Top_level_file,args.port_name,args.new_status,Baseboard_path)
            else:
                print("Please provide port name and new status")
                print("Example:add -c <change> 'port' -p <port_name> 'clk' -ns <new_status> 'input' -t <topfile> 'top.sv")
                exit()
        else:
            print("Please provide valid change option")
            print("Example:add -c <change> 'range' -p <port_name> 'clk' -nr <new_range> '32' -t <topfile> 'top.sv")
            print("Example:add -c <change> 'port' -p <port_name> 'clk' -ns <new_status> 'input' -t <topfile> 'top.sv")
            exit()
    else:
        print("please provide valid option")
        exit()
       