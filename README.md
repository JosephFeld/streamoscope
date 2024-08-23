# streamoscope
USB-3 streaming data acquisition system originally designed for low-field MRI

# HDL Setup
in Vivado tcl console:
cd into streamoscope directory

```
source hdl/Streamoscope/Streamoscope.tcl
```

The new project should open up after a bit of time configuring. When it's done it may throw this error, but it's fine
```
ERROR: [Common 17-55] 'set_property' expects at least one object.
```

Then in the tcl console, generate the modified ADC LVDS IP with the following steps:

```
cd hdl/ADC-lvds-main/ip
source adc_lvds_ip.tcl
update_ip_catalog -rebuild
```
