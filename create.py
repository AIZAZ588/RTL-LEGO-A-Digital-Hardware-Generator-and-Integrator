################################ Global ######################
import os,list_modules 
import argparse
folder_name = 'Baseboard'
file_name = "Baseboard.sv"
input = ''
output = ''
create = False
child_path = os.path.join(list_modules.path,folder_name)

######################### setting name of instance & body  ############################

def set_instance_name(f_name,input,output):
    m_name = f_name.replace(".sv","")  
    
    if input or output:
        Body = f"module {m_name} (\ninput\t\t\t\tclk,\ninput\t\t\t\treset,"
        if input:
            for inp in input:
                #print("\ninput found! : ",inp)
                i = " " 
                inpo = f"\ninput\t\t\t{(i.join(inp))},"
                Body = Body+inpo
                
        if output:
            for out in output:
                o = " "
                #print("\noutput found! : ",out)
                outu = f"\noutput\t\t\t{o.join(out)},"
                Body = Body+outu
        Body = Body.removesuffix(",")
        end = "\n\n);\nendmodule"
        Body = Body+end
        print(Body)
    else:
        Body = f'''module {m_name} (\ninput\t\t\tclk,\ninput\t\t\treset,\n\n);\nendmodule'''
        print(Body)
    return Body
######################### parser block  ########################################
def parser():
    global input,output,create
    parser = argparse.ArgumentParser(
    description= "Create a base file using -n or --name: default<Baseboard>"
    )
    parser.add_argument('create',help='usege: create')
    parser.add_argument('-n','--name',help="usage: use -n or --name for New name")
    parser.add_argument('-i','--input',action='append',nargs='+',type=str,help="usage: use -i or --input")
    parser.add_argument('-o','--output',action='append',nargs='+',type=str,help="usage: use -o or --output")
    arg = parser.parse_args()
    input = arg.input
    output = arg.output
    create = arg.create
    if arg.name:
        global file_name
        file_name = arg.name 
    return file_name,input,output

##########################  default  fn  ########################################
def default():
    global input,output
    if not os.path.exists(child_path):
        os.makedirs(folder_name)
        os.chdir(folder_name)
        with open (file_name,'w+') as file:
            file.write(set_instance_name(file_name,input,output))
            print(f"{file_name} created ")
    elif os.path.exists(child_path):
        #print(f"{folder_name} already exists in {list_modules.path}!")
        os.chdir(folder_name)
        with open (file_name,'w+') as file:
            file.write(set_instance_name(file_name,input,output))
            print(f"{file_name} created ")
        
        
############################ New name fn #############################################
def name():
    global input,output
    if not os.path.exists(folder_name):
        os.makedirs(folder_name)
        os.chdir(folder_name)
        with open (file_name,'w+') as file:
            file.write(set_instance_name(file_name,input,output))
            print(f"{file_name} created ")
    elif os.path.exists(folder_name):
        #print(f"{folder_name} already exists in {list_modules.path}!")
        os.chdir(folder_name)
        with open (file_name,'w+') as file:
            file.write(set_instance_name(file_name,input,output))
            print(f"{file_name} created ")

###########################  Calling fns  #################################################
def main():
    parser()
    if create:
        if file_name: 
            name()
        else:
            default()
            os.chdir(child_path)
        with open("key_val.py",'a+') as key_file:
            key_file.write(f"file_name = '{file_name}'\nfolder_name = '{folder_name}'\nchild_path = '{child_path}'")
            key_file.close()
    else:
        print("error :enter create first!")
if __name__ == '__main__':
    main()