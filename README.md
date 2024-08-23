# Streamoscope
USB-3 streaming data acquisition system originally designed for low-field MRI

# Python Setup

Streamoscope data can be read into Python, and this guide will walk through setting up the Jupyter Notebook example.

## libusb installation

First, we need to install libusb.

### MacOS

On MacOS, run these commands in the terminal: 
```
brew install libusb
sudo ln -s /opt/homebrew/lib/libusb-1.0.0.dylib /usr/local/lib/libusb.dylib
```

### Windows

On Windows, download the latest libusb Windows binaries [here](https://libusb.info/) under Downloads>Latest Windows Binaries.

Unzip the file and choose a version corresponding to your operating system. A good default is the newest Visual Studio folder VS2022. Choose the subfolder corresponding to your operating system, either 32 or 64 for 32-bit or 64-bit systems, respectively. Copy ```libusb-1.0.dll``` in the ```dll``` folder into ```C:/Windows/System32```, which will require admin approval. ```libusb-1.0.dll``` can also be placed into the same directory as the python script, ```streamoscope/software/python_reading``` for this example.

The FT601 on the Streamoscope may have the incorrect drivers. To fix this, install [Zadig](https://zadig.akeo.ie/) and run it.

* Select Options\>List All Devices
* Select FTDI SuperSpeed-FIFO Bridge (Interface 0)
* Use the arrows on the right to select libusbK as the new driver.

Here's what it should look like:
![Zadig](./docs/images/zadig.png)

* Click "Replace Driver"


## Python dependencies


Then install the Python dependencies

```
pip install libusb, pyusb, matplotlib, numpy, scipy, jupyter
```

## Jupyter Notebook Setup

In the terminal, cd into ```streamoscope/software/python_reading``` and run this command to start up the Jupyter Notebook:

```jupyter notebook .\spin_echo_reader.ipynb```




# Vivado Project Setup
The FPGA design was made in [Vivado 2023.2](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2023-2.html). It is only necessary to use this if you need to modify the HDL on the FPGA. There is a provided FPGA configuration already.

Open the Vivado GUI, go to the tcl console on the bottom, and cd into the streamoscope directory. Then run this command:

```
source hdl/Streamoscope/Streamoscope.tcl
```

Then wait for a bit while the project configures. When it's done, it may throw this error which can be safely ignored:

>ERROR: [Common 17-55] 'set_property' expects at least one object.
Resolution: If [get_<value>] was used to populate the object, check to make sure this command returns at least one valid object.

It will open up the new Streamoscope project. Then in the new project's tcl console, generate the modified ADC LVDS IP with these commands:

```
cd hdl/ADC-lvds-main/ip
source adc_lvds_ip.tcl
```

Then run this command in the Streamoscope tcl console to update the IP catalog:

```
update_ip_catalog -rebuild
```

If you generate the bitstream and it has errors, keep trying a few times and it should give new errors each time and then eventually work. 