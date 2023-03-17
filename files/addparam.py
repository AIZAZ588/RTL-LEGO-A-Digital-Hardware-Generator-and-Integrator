#!/usr/bin/python3
import re
import os
from colorama import Fore

def adding_parameters(filename, param, ranges):
    print("top file is  : ", filename)
    print(os.getcwd())
    with open (filename,'r') as topfile:
        data=topfile.readlines()
        print(data)
        if data[0].endswith("#(\n"):
            if any(param in s for s in data):
                print(Fore.RED + f"{param} already exists in {filename}" + Fore.RESET)
                exit()
            else:
                print("hello")
                existing_param = data[1]
                existing_param = existing_param+f"\tparameter {param}  \t = {ranges}\n"
                data.remove(data[1])
                data.insert(1,existing_param)
                print(Fore.BLUE + f"{param} added in {filename}" + Fore.RESET)
        else:
            first_line = data[0].replace("(\n","#(\n")
            data.remove(data[0])
            data.insert(0,first_line)
            data.insert(1,f"\tparameter {param}  \t = {ranges}\n)\n\n(\n")
            print(Fore.BLUE + f"{param} added in {filename}" + Fore.RESET)
        print(data)
        with open (filename,'w') as topfile:
            topfile.writelines(data)

            #topfile.writelines(contents)
        #data = data.insert(2,"hello")
        #print(data)
    # print("top file is  : ", filename )
    # # open the file and read its contents
    # with open(filename, 'r') as file:
    #     content = file.read()
    #     #print(content)
    #     pattern = r'module\s+clock\s*#\(\s*([^)]*)\s*\)'
    #     match = re.search(pattern, content, re.DOTALL)
    #     if match:
    #         #print(match)
    #         existing_param = match.group(1)
    #         existing_param = existing_param.rstrip()
    #         if existing_param != '':
    #             existing_param += ','
    #         else:
    #             existing_param += ' '
    #         Body = ''
    #         if param:
    #             p = ''
    #             for prm, rng in zip(param, ranges):
    #                 if prm in existing_param:
    #                     print(
    #                         Fore.RED + f"{prm} already exists in {filename}" + Fore.RESET)
    #                     exit()
    #                 else:
    #                     if rng == 'None':
    #                         param_text = f'\n\tparameter\t{(p.join(prm))},'
    #                     else:
    #                         param_text = f'\n\tparameter\t{rng}\t{(p.join(prm))},'
    #                     Body += param_text  # append the new parameter text to Body
    #             print(Fore.GREEN + f"{prm} added to {filename}" + Fore.RESET)
    #         Body = Body.rstrip(',')
    #         new_text = f"module clock \n#(\n\t{existing_param}{Body}\n)"
    #         new_content = content.replace(match.group(0), new_text)
    #         with open(filename, 'w') as f:
    #             f.write(new_content)
    #     else:
    #         pattern_text = 'module clock\n#(\n)'
    #         if param:
    #             p = ''
    #             Body = ''
    #             for prm, rng in zip(param, ranges):
    #                 if rng == 'None':
    #                     param_text = f'\n\tparameter\t{(p.join(prm))},'
    #                 else:
    #                     param_text = f'\n\tparameter\t{rng}\t{(p.join(prm))},'
    #                 Body += param_text  # append the new parameter text to Body
    #             print(Fore.GREEN + f"{prm} added to {filename}" + Fore.RESET)
    #             Body = Body.rstrip(',')
    #             pattern_text = f"module clock\n#(\n\t{Body}\n)"
    #             # pattern_text += Body
    #         content = content.replace('module clock', pattern_text)
    #         with open(filename, 'w') as file:
    #             file.write(content)
