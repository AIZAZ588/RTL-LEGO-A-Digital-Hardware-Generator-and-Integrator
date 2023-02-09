#########################  Imports ###############################################################
# from Baseboard.key_val import file_name,folder_name,child_path
import argparse, json
import os
found_module = False
#print(list_modules.modules)
os.chdir('Baseboard')
with open("key_val_file.json","r")as f:
    content = json.load(f)
    for i in content:
        file_name = content['toplevelfile']['file_name']
        folder_name = content['toplevelfile']['folder_name']
        child_path = content['toplevelfile']['child_path']
    

print("Top level file is  : ",file_name)
no_of_inputs = 0
no_of_outputs = 0
input_list = []
output_list = []
library = r"..\LAGO\library"
###################### Parser block ############################################################
    
parser = argparse.ArgumentParser(
    description= " use -m or --module for module name"
)
parser.add_argument(
    '-m','--module',action='append',nargs='+' ,help="usage : -m or --module",type=str
)
parser.add_argument(
    '-n','--name',action='append',nargs='+' ,help="usage : -n or --name to name your instane",type=str
)
arg = parser.parse_args()
no_of_name = 0
no_of_modules = 0
if arg.module:
    no_of_modules  = len(arg.module) 
else:
    print("Enter atleast one module name!")
    exit()
if arg.name:
    no_of_name = len(arg.name) 
#for args in vars(arg):
    #print(args, getattr(arg, args))
###########################################
def listToString(s):
   
    # initialize an empty string
    str1 = " "
    
    # return string 
    return (str1.join(s))

def get_ranges_from_file(filename):
    data = {'ports': []}
    ranges = {}
    with open(filename, 'r') as f:
        for line in f:
            if 'parameter' in line:
                line = line.replace(',','')
                _, param, _, value = line.split()
                # print(value)
                value = int(value)
                ranges[param] = value
            if 'input' in line or 'output' in line:
                parts = line.strip().split()
                port_type = parts[0]
                if parts[-2] == 'input':
                    port_range = 'None'
                else:
                    
                    port_range =  parts[-2]
                
                if(port_range != 'None' and parts[-2] !='reg'):
                    port_name = parts[-1]
                    data['ports'].append({
                        'name': port_name,
                        'type': port_type,
                        'range':'['+str((ranges[port_range[1:len(port_range)-5]])-1)+port_range[len(port_range)-3:]
                    })
                else:
                    port_name = parts[-1]
                    data['ports'].append({
                        'name': port_name,
                        'type': port_type,
                         'range':'None'
                        })   
        print(data)
                
    return ranges
###########################################
os.chdir('..')
os.chdir('library')
library_list = os.listdir()
os.chdir('..')
#print(library_list)
###########################################
i=0
for Mname in arg.module:
    module_name = listToString(Mname)
    inst_name = listToString(Mname).replace(".sv","")
    if i<no_of_name:
            name = arg.name[i]
            new_name = listToString(name)
            inst_name = new_name
            i+=1
            print('new name of module is :',inst_name)
            
    #'''
############################# Reading Base file #################################################
    #os.chdir('..')
    os.chdir(folder_name)
    with open(rf"{file_name}", 'r+') as look_file:
        look = look_file.read()
        count = look.count(inst_name)
        if count:
            inst_name = f"{inst_name}_{count+1}"
        t_inst_count = look.count("inst")
        print("instnace  : ",t_inst_count+1)
        
    ######################### file handling block ###############################################
    for look in library_list:
        if module_name in library_list:
            found_module = True
            print(f"\n{module_name} found!") 
            if found_module:
                find=True
                inp  = False
                out  = False
                os.chdir('..')
                os.chdir('library')
                with open(rf"{module_name}",'r+') as module:  # opening module(counter etc)   
                    os.chdir('..')
                    os.chdir(folder_name)
                    with open(rf"{file_name}", 'a+') as inst:     # opening file(Baseboard.sv) & writing inst            
                        file = module.read()
                        if "input" and "output" in file:
                            R_end = (inst.tell())-11
                            inst.truncate(R_end)                                #remove endmodule 
                            inst.write(f"\n{inst_name} inst\n(\n")              # calling module (name) & writing it to file
                            os.chdir('..')
                            os.chdir('library')
                            with open(f"{module_name}",'r+') as module2:           # opening module(counter etc)
                                #print(module2.read())# ------------------
                                while find:
                                    find  = module2.readline()
                                    #print(find) #->>>>>>>>>>>>>>>>>>>>>>>>.
                                    if 'input' in find:
                                        inputs = find.replace(",","").split()                #removing ',' & making list
                                        #print(inputs)#->>>>>>>>>>>>>>>>>.....
                                        #print("inputs are :",inputs[-1])
                                        inst.write((f".{inputs[-1]} \t\t\t\t\t (   ),\n")) 
                                        inp = True
                                        # input_list[f'input {no_of_inputs}'] = inputs[-1]
                                        input_list.append(f'{inputs[-1]}')
                                        #print(input_list)
                                        no_of_inputs+=1
                                        # print("no of inputs are :",no_of_inputs)
                                    elif 'output' in find:
                                        outputs = find.replace(",","").split()
                                        #print("outputs are: ",outputs[-1])
                                        inst.write((f".{outputs[-1:]} \t\t\t\t\t (   ),\n"))
                                        # output_list[f'output {no_of_outputs}'] = outputs[-1]
                                        output_list.append(f'{outputs[-1]}')
                                        out = True
                                        no_of_outputs+=1
                                       # print("no of outputs are :",no_of_outputs)
                            if inp and out:      
                                print("inputs found")
                                print("Outputs found")
                                print("instance created!\n")
                                inst.write("\n);" "\n\nendmodule\n")
                                module.close()
                                module2.close()
                                inst.close()
                                l0 = ",\n"
                                newline = f"\"{inst_name}\":" 
                                l1 = "{"
                                l2 = "}"
                                module_list = [no_of_inputs,no_of_outputs,input_list,output_list]

                                os.chdir('..')
                                os.chdir(folder_name)
                                with open("key_val_file.json","r")as f:
                                    content = f.read()
                                with open('key_val_file.json','a+') as key_val_file:
                                    if "}" in content:
                                        r_end = (key_val_file.tell())-3
                                        x = key_val_file.truncate(r_end)
                                    key_val_file.writelines([l0,newline,l1])
                                with open('key_val_file.json','a+') as key_val_file:
                                    key_val_file.write("\"inputs\":")
                                    json.dump(input_list,key_val_file)
                                    key_val_file.write(",\"outputs\":")
                                    json.dump(output_list,key_val_file)
                                    key_val_file.write("}\n}")
                                input_list.clear()
                                output_list.clear()
                                no_of_inputs = 0
                                no_of_outputs = 0
                                module_list.clear()
                                os.chdir('..')
                                
                        elif inp!=True or out!=True:
                            print("\ninputs are not found!")
                            print("outputs are not found!")
                            print("instance is not created!\n")
            break               
        else:
            print(f"module {module_name} not found!\n")
            break

    
