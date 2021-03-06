
import imc_termite
import json

# declare and initialize instance of "imctermite" by passing a raw-file
try :
    imcraw = imc_termite.imctermite(b"samples/sampleA.raw")
except RuntimeError as e :
    print("failed to load/parse raw-file: " + str(e))

# obtain list of channels as list of dictionaries (without data)
channels = imcraw.get_channels(False)
print(json.dumps(channels,indent=4, sort_keys=False))

# obtain data of first channel (with data)
channelsdata = imcraw.get_channels(True)
if len(channelsdata) > 0 :
    chnydata = channelsdata[0]['ydata']
    chnxdata = channelsdata[0]['xdata']

print(len(chnydata))
print(len(chnxdata))

# print the channels into a specific directory
imcraw.print_channels(b"./")
