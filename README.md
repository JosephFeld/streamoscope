# streamoscope
USB-3 streaming data acquisition system originally designed for low-field MRI

# HDL Setup
Open Vivado and cd into streamoscope directory in the tcl console. Then run this command:

```
source hdl/Streamoscope/Streamoscope.tcl
```

Then wait for a bit while the project configures. When it's done, it may throw this error which can be safely ignored.

<span style="color:red">ERROR: [Common 17-55] 'set_property' expects at least one object.</span>.

Then in the tcl console, generate the modified ADC LVDS IP with the following steps:

```
cd hdl/ADC-lvds-main/ip
source adc_lvds_ip.tcl
```

Then run this command:

```
update_ip_catalog -rebuild
```
