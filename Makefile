OS:=$(shell uname -s)

CCpp=g++
CFLAGS=-c -Wall -pthread -std=c++0x -g3
LFLAGS  = -L"../iniparser" -L"${HOME}/repos/uhd/host/build/lib"
common_libs=-lm -liniparser -lrt -luhd -lfftw3
linux_libs=-lboost_thread -lboost_system -pthread -l argtable2
INCLUDES=-I"../include/" -I"include/" -I"../tsg/include" -I"../iniparser3.0b/src/" \
	 -I"${HOME}/uhd/host/include" -I"${HOME}/uhd/host/include/uhd/types" -I"${HOME}/uhd/host/include/uhd/usrp" \
	 -I"${HOME}/SuperDARN_MSI_ROS/linux/home/radar/ros.3.6/include/base" -I"${HOME}/SuperDARN_MSI_ROS/linux/home/radar/ros.3.6/include/superdarn"

CPP_SOURCES=usrp_driver.cpp dio.cpp burst_worker.cpp  recv_and_hold.cpp usrp_utils.cpp

CPP_OBJECTS=$(CPP_SOURCES:.cpp=.o)

EXECUTABLE=usrp_driver

all: $(EXECUTABLE)


$(EXECUTABLE): $(CPP_OBJECTS)
	$(CCpp) -o $@ $(CUDA_OBJECT0) $(CUDA_OBJECT1) $(CPP_OBJECTS) $(LFLAGS) $(common_libs) $(linux_libs) ${INCLUDES}

.cpp.o:
	$(CCpp) $(CFLAGS) $< -o $@ $(LFLAGS) $(INCLUDES)

clean:
	rm -rf *.o *.pyc $(EXECUTABLE)

debug:
	gdb --args $(EXECUTABLE) --host usrp1 --ant 1 --intclk

cudebug:
	 cuda-gdb --args python3 -m pycuda.debug cuda_driver.py 
