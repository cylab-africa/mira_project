Upanzi Pod measurements. Version 4.2

Services
-iperf3 client.
-iperf3 server
-packets routes for between the devices (MESH)
-packets routes for Africa Sites.
-webperfomance measurements
-net usage monitaring.

Services Runtime
The Services are scheduled to run in every hour in different minutes
to allow the pod maxmun efficiency 

-@00 Minutes packets routes for Africa Sites.
-@15 Minutes web erfomance measurements
-@25 Minutes iperf3 client  .
-@40 Minutes packets routes for between the devices (MESH)
-@55 Minutes net usage monitaring.


Fixes
    Service: packets routes for Africa sites.
        Namibia Angola Descrepancy fixed
            One webset which was labeled to be from namibia, later pointed to actually from Angola.
            old:namwater.com.na	41.78.18.49
            new:nms.com.na	196.44.136.114  
