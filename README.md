# streamoscope
USB-3 streaming data acquisition system originally designed for low-field MRI

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