Upanzi Pod measurements. Version 4.2

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
    Replacement of iperf3 service to ookla speedtest
       Although iperf3 offers a lot of flexibility when it comes to measurements
       Most of the time its public server are not available hence hindering the measuremtns 
       Unless we setup the public available server, we will be moving to ooklaspeed test.
