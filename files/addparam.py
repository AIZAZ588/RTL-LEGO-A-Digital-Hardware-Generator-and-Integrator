#!/usr/bin/python3
from colorama import Fore
def adding_parameters(filename, param, ranges):
    with open (filename,'r') as topfile:
        data=topfile.readlines()
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
        with open (filename,'w') as topfile:
            topfile.writelines(data)