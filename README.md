Upanzi Pod measurements. Version 4.3

Services
-speedtest_test.
-packets routes for between the devices (MESH)
-packets routes for Africa Sites.
-webperfomance measurements
-net usage monitaring.

Services Runtime
The Services are scheduled to run in every hour in different minutes
to allow the pod maxmun efficiency 

-@00 Minutes packets routes for Africa Sites.
-@15 Minutes web erfomance measurements
-@25 Minutes speedtest_test. <---- to be modified
-@40 Minutes packets routes for between the devices (MESH)
-@55 Minutes net usage monitaring.


Fixes
    Speedtest service now contain both iperf3 and ookla speed test 
       Although iperf3 offers a lot of flexibility when it comes to measurements
       Most of the time its public server are not available hence hindering the measuremtns 
       Unless we setup the public available server, ookla speetest as as a backup.
    
    iperf3 and ookla speedtest environmental variables
    Envirionmental variables have been introduced.
        ENV ookla_speedtest=false to enable ookla speed test
        ENV iperf3_speedtest=false to enable iperf3 speed test
        ENV iperf3_server="169.150.238.161" to set the iperf server
        ENV ookla_server="none" to specify ookla server
        All the variables can be modifed at the balena cloud.