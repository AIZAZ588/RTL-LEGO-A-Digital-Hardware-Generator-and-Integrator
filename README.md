
# Digital Hardware Generator and Integrator

The aim of this project is to create a framework that can be used to generate and intergrate RTL components. User should be able to connect components from a library of generic RTL components and existing IP blocks to create Digital Hardware.

Here is brief discription of files that how to proceed them

## [create.py](https://github.com/3820bilal/FYP/blob/main/create.py)

This file will create project when run without any argument with the name of 
**Baseboard.sv** (default).

If you are using VS code you can only run file using run button simply or 


To run this project in terminal

```bash
  python .\create.py
```

If you are using ubuntu terminal use
```bash
python3 create.py
```
you can give file the name of your own choice by

```bash
python .\create.py -f filename
```
the above project will add only two inputs **clk** and **reset** in created file.
If you want to add more inputs and outputs in the file use following commands

```bash
python .\create.py -f filename -i enable -o clear -ir None -or [3:0]
```

None is range for input **enable** and **[3:0]** is range for output **clear**

## [plug.py](https://github.com/3820bilal/FYP/blob/main/plug.py)

This file will create the instance of file that is given in argument. (**the file should be available in library**).

To run this file use following commands

argument after **-i** is for instance name 

argument after **-f** is for file name
```bash
python .\plug.py -i instance_name -f filename 
```
If you are using ubuntu terminal then use **python3** instead of **python**

## [connect.py](https://github.com/3820bilal/FYP/blob/main/connect.py)

This file will connect the ports of one instance with the ports of another instance.

To run this file use following commands

argument after **-i** is for input instance

argument after **-o** is for output instance 

argument after **-ip** is for ports of input instance

argument after **-op** is for ports of output instance 
```bash
python .\connect.py -i input instance_name -o output instance name -ip input port -op output port
```
you can give **list** of input ports and output ports to connect.

If you are using ubuntu terminal then use **python3** instead of **python**
