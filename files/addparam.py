#!/usr/bin/python3
import re
from colorama import Fore

def adding_parameters(filename, param, ranges):
    # open the file and read its contents
    with open(filename, 'r') as file:
        content = file.read()
        pattern = r'module\s+clock\s*#\(\s*([^)]*)\s*\)'
        match = re.search(pattern, content, re.DOTALL)
        if match:
            existing_param = match.group(1)
            existing_param = existing_param.rstrip()
            if existing_param != '':
                existing_param += ','
            else:
                existing_param += ' '
            Body = ''
            if param:
                p = ''
                for prm, rng in zip(param, ranges):
                    if prm in existing_param:
                        print(
                            Fore.RED + f"{prm} already exists in {filename}" + Fore.RESET)
                        exit()
                    else:
                        if rng == 'None':
                            param_text = f'\n\tparameter\t{(p.join(prm))},'
                        else:
                            param_text = f'\n\tparameter\t{rng}\t{(p.join(prm))},'
                        Body += param_text  # append the new parameter text to Body
                print(Fore.GREEN + f"{prm} added to {filename}" + Fore.RESET)
            Body = Body.rstrip(',')
            new_text = f"module clock \n#(\n\t{existing_param}{Body}\n)"
            new_content = content.replace(match.group(0), new_text)
            with open(filename, 'w') as f:
                f.write(new_content)
        else:
            pattern_text = 'module clock\n#(\n)'
            if param:
                p = ''
                Body = ''
                for prm, rng in zip(param, ranges):
                    if rng == 'None':
                        param_text = f'\n\tparameter\t{(p.join(prm))},'
                    else:
                        param_text = f'\n\tparameter\t{rng}\t{(p.join(prm))},'
                    Body += param_text  # append the new parameter text to Body
                print(Fore.GREEN + f"{prm} added to {filename}" + Fore.RESET)
                Body = Body.rstrip(',')
                pattern_text = f"module clock\n#(\n\t{Body}\n)"
                # pattern_text += Body
            content = content.replace('module clock', pattern_text)
            with open(filename, 'w') as file:
                file.write(content)
