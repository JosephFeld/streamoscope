'''
on m2 mac I need to:

  brew install libusb
  Then do sudo ln -s /opt/homebrew/lib/libusb-1.0.0.dylib /usr/local/lib/libusb.dylib
  Would have to do that with FT601 library anyways
  or something similar in order to get it into where it needs to be.
  Not sure how to fix that otherwise.
'''
from array import array
import ctypes
import usb.core
import usb.backend.libusb1
import time
import matplotlib.pyplot as plt
import numpy as np
import itertools
import pickle
import datetime

def check_ramp(data, max_val=2**14):
     print("Checking ramp...")
     errors = []
     num_vals = max_val
     diffs = data[1::] - data[:-1:]
     mods = np.mod(diffs+num_vals,num_vals)

     checks = mods == np.ones(mods.shape)
     check = False in checks

     if not check:
        print("Found no errors!")
        return []
     
     print("Found error(s), locating...")

     for i in range(len(mods)):
          val = mods[i]
          if val != 1:
               print(f"diff {val} at index {i}, val {bin(data[i])}, l: {data[i-3:i+3]}")
               errors.append((i,data[i]))

     print("Done!")
     return errors

def read_data(sample_limit=1024**3, wait_for_data=True, quiet=True, print_listening=True, filename=None, pickle_data=False, print_pickle=True, exit_on_no_data=False, read_timeout=None):

    dev = usb.core.find(idVendor = 0x0403, idProduct=0x601f)

    if not quiet: print('dev',dev)
    if not quiet: print('dev[0].interfaces()',dev[0].interfaces())

    #write endpoint (0x01) bulk?:
    ep = dev[0].interfaces()[0].endpoints()[0]
    if not quiet: print('ep',ep)
    #read endpoint (0x82) (0x02|0x80 apparently):
    #ep = dev[0].interfaces()[1].endpoints()[1]

    i = dev[0].interfaces()[1].bInterfaceNumber
    if not quiet: print('i',i)

    dev.reset()
    config = array('B', [0x00, 0x00, 0x00, 0x00, 0x82, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00])

    BUFFER_SIZE = 900000#216500*4#1280000*2  #*8
    TRANSACTION_SIZE = sample_limit
    # TRANSACTION_SIZE = 1024**3 / 8
    TIMEOUT = 2000


    data = array('L', list(BUFFER_SIZE*[8000]))
    if not quiet: print(data.itemsize)

    # dataBuffer = bytearray(BUFFER_SIZE)
    # dataBuffer[:] = itertools.repeat(0xAA, len(dataBuffer))
    # dataBuffer = str(dataBuffer)

    r = ep.write(config)
    # print(r)
    time.sleep(0.5)

    data_chunks = []

    #continously updating version of buffer that has parsed data into 16 bits
    dt = np.dtype(np.uint16)
    dt = dt.newbyteorder('<')
    parsed_data = np.frombuffer(data, dtype=dt)

    #0x82 hopefully?
    epr = dev[0].interfaces()[1].endpoints()[1]
    #wait around for data to show up
    total = 0
    iteration = 0
    start = time.time()
    if not quiet or print_listening: print("listening...")
    while wait_for_data:
        try:
            # print("grr")
            r = epr.read(data,timeout=TIMEOUT)
            start = time.time()
            # print("hrm")
            #   print(help(epr.read))
            total = r
            iteration = 1
            if r != 0:
                if not quiet or print_listening: print("Found data!")
                data_chunks.append(parsed_data[0:r//2])
                break
        except Exception as e:
            if not quiet: print(e)


    try:
        size = TRANSACTION_SIZE*data.itemsize
        if not quiet: print(f"Size: {size}")

        while total<size:
            #   size-=r
            r = epr.read(data,timeout=TIMEOUT)
            total+=r
            iteration +=1
            # print(r)

            if exit_on_no_data and r == 0:
                break

            data_chunks.append(np.copy(parsed_data[0:r//2]))

            if read_timeout is not None:
                if time.time() - start >= read_timeout:
                    break

            #   data_chunks.append(np.array([(data[i]&0xFFFF,(data[i]&0xFFFF0000)>>16) for i in range(0,r)]))
        if not quiet: print(f"r:{r}, size: {size}")
        end = time.time()
        if not quiet: print(f"Total transferred: {total}")
        if not quiet: print(f"Total Time (s): {end-start}")
        if not quiet: print(f"Transfer rate (MB/s) {total/(end-start)/1024.0**2}")
        if not quiet: print(f"Number of Iterations: {iteration}")
    except Exception as e:
        if not quiet: print(e)

    #no data read
    if len(data_chunks) == 0:
        return (np.zeros(0),np.zeros(0))
        
    adc_data = np.concatenate(data_chunks)

    ch0_raw = adc_data[0::2]
    ch1_raw = adc_data[1::2]

    ch0_clean = np.mod(ch0_raw, 2**14)
    ch1_clean = np.mod(ch1_raw, 2**14)
    flag_0 = np.mod(np.floor_divide(ch0_raw, 2**14),2) == 1
    flag_1 = np.floor_divide(ch0_raw, 2**15)  == 1
    flag_2 = np.mod(np.floor_divide(ch1_raw, 2**14),2)  == 1
    flag_3 = np.floor_divide(ch1_raw, 2**15)  == 1

    
    #pickle it!
    if pickle_data:
        if print_pickle: print("Pickling...")
        if filename is None:
            current_time = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
            filename =  f'streamoscope_data_{current_time}.pkl'

        if not filename.endswith('.pkl'):
            filename += '.pkl'
        output = open(filename, 'wb')
        # Pickle dictionary using protocol 0.
        pickle.dump(ch0_clean, output)
        pickle.dump(ch1_clean, output)
        pickle.dump(flag_0, output)
        pickle.dump(flag_1, output)
        pickle.dump(flag_2, output)
        pickle.dump(flag_3, output)
        output.close()
        if print_pickle: print(f"Pickled into {filename}")

    return (ch0_clean, ch1_clean, flag_0, flag_1, flag_2, flag_3, filename)

if __name__ == '__main__':
    #dump garbage
    read_data(sample_limit=1024**3, wait_for_data=False)
    ch_0, ch_1, flag_0, flag_1, flag_2, flag_3, filename = read_data(sample_limit=1024**3, wait_for_data=True, pickle_data=True)

    check_ramp(ch_0[5:])

    plt.plot(ch_0)
    plt.plot(ch_1)
    plt.show()