# streamoscope
USB-3 streaming data acquisition system originally designed for low-field MRI

# HDL Setup
Open the Vivado GUI and cd into the streamoscope directory in the tcl console. Then run this command:

```
source hdl/Streamoscope/Streamoscope.tcl
```

Then wait for a bit while the project configures. When it's done, it may throw this error which can be safely ignored:

>ERROR: [Common 17-55] 'set_property' expects at least one object.
Resolution: If [get_<value>] was used to populate the object, check to make sure this command returns at least one valid object.

It will open up the new project. Then in the new project's tcl console, generate the modified ADC LVDS IP with these commands:

```
cd hdl/ADC-lvds-main/ip
source adc_lvds_ip.tcl
```

Then run this command in the Streamoscope tcl console to update the IP catalog:

```
update_ip_catalog -rebuild
```

If you generate bitstream and it has errors, keep trying a few times and it should give new errors each time and then eventually work. 