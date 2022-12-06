from Baseboard.key_val import file_name,folder_name
import fileinput
import os
import argparse
parser = argparse.ArgumentParser()
find = True
ii = False #--> input instance 
oi = False #--> output instance
ip = False #--> input port
op = False #--> output port
instance_found= False
port_found = False
input_found = False
i=0
no_of_inputs = 0
no_of_outputs = 0
input_instance = False
output_instance = False
###########################################
def listToString(s):
   
    # initialize an empty string
    str1 = " "
    
    # return string 
    return (str1.join(s))
###########################################

##################################################################################
parser = argparse.ArgumentParser(
    description= "usage: -ip or --inputport,-i or --inputinstace,-o or --outputinstance ,-op or --outputport, "
)
parser.add_argument(
    '-ip','--inputport',action='append',nargs='+' ,help="usage : -ip or --port",type=str
)
parser.add_argument(
    '-i','--inputinstace',action='append',nargs='+' ,help="usage : -i or --inputinstace",type=str
)
parser.add_argument(
    '-op','--outputport',action='append',nargs='+' ,help="usage : -op or --input",type=str
)
parser.add_argument(
    '-o','--outputinstance',action='append',nargs='+' ,help="usage : -o or --outputinstance",type=str
)
arg = parser.parse_args()
if arg.inputinstace:
    input_instance = arg.inputinstace
else:
    print('Enter input instance name -i,--inputinstace')
    exit()
if arg.inputport:
    no_of_inputs = len(arg.inputport)
else:
    print("Enter at least one input port")
    exit()
if arg.outputinstance:
    output_instance = arg.outputinstance
else:
    print("Enter output instance name")
    exit()
if arg.outputport:
    no_of_outputs = len(arg.outputport)
else:
    print("Enter at least one output port")
    exit()
if no_of_inputs < no_of_outputs or no_of_inputs > no_of_outputs:
    print("no of input ports and output ports are unqual!")
    exit()
input_port = arg.inputport 
output_port = arg.outputport  

###########################################################################################
for No_inputs in input_port:
    for input_p in input_port:
        input_p  = listToString(No_inputs).replace(' ','')
    for output_p in output_port[i]:
        output_p = listToString(output_p).replace(' ','')
    for  input_inst in  input_instance:
        input_inst = listToString(input_inst)
    for output_inst in output_instance:
        output_inst = listToString(output_inst)
    print(end='\n')
    print('input instance :',input_inst,'--> port : ',input_p,end='\n')
    print('output instance :',output_inst,'--> port :',output_p,end='\n\n')

    os.chdir(folder_name)
    with open("key_val.py",'r+') as file:
        while find:
            find =  file.readline()     
            if input_inst in find:
                input_ist_list = find
                ii = True
                #print(input_ist_list) #--> input instance list of ports
                if input_ist_list.__contains__(input_p): 
                    ip = True 
            if output_inst in find:
                output_inst_list = find
                oi = True
                #print(output_inst_list) #--> output instance list of ports
                if output_inst_list.__contains__(output_p): 
                    op = True 
                    connected_ports = f"\n{input_inst} = {{'{input_p}':'{output_p}'}}"
                    with open('key_val.py','r+') as file:
                        find = file.read()
                        # if connected_ports in find:
                        #     connected_ports = f"\n{input_inst}['{input_p}]'='{output_p}']"
                        #     file.write(connected_ports)
                        # else:
                        file.write(connected_ports)
                    for line in fileinput.FileInput(file_name,inplace=1):
                        line = line.replace('\n','')
                        if input_inst in line:
                            input_found = True
                        if  input_found and f'.{input_p}' in line:
                            line = line.replace(line,f'.{input_p}\t\t\t\t\t({output_p}),')
                            input_found = False
                        print(line)
                    print('connected')
                    oi = True
                    os.chdir('..')
                    i+=1
                    break
                    
    if ii == False:
        print('input instance not found!')
    if oi == False:
        print('output instance not found!')
    if ip == False:
        print('input ports not found!')
    if op == False:
        print('output ports not found!')