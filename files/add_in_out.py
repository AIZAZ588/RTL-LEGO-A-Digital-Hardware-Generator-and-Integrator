#!/usr/bin/python3
import re
import os
import argparse,json
import colorama
from colorama import Fore
# os.chdir('Baseboard')
def add_inputs_outputs(fileName,inputs,outputs,input_ranges,output_ranges,Baseboard_path):
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
