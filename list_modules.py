
import os
import glob                      # lib for listing specific (.sv) files
path = r"..\LAGO"            #path to myfolder

modules = {None}                #making Set of module files
           
g = glob.glob('*.sv') #Return a list of paths matching a pathname pattern.it will not show heading files
for files in g:
    full_path = os.path.join(path,files)  # stores full path 
    new  = files.replace(".v",'sv')
    modules.add(files)
#print(modules)

'''
if new:
    modules.add()
'''
#Rough work
'''
########################
l = os.listdir(path)    #This will list all the files (include heading files) in folder 
print(l)
##########################3
# for root,dirs,files in os.walk(path):
#     #print(root) #<-----Testing whats inside files,dirs & roots 
#     for f in files:
#         print(os.path.join(root,f)) #<--- this will print full path of files
        
#'''