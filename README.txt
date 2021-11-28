Current Module State:
    Service file is not currently working on the Linux side of things for reasons unknown to me at this point.
    Puppet module is fully working apart from the service aspect. Runs and installs the application fine.
    Can use localhost or the VMs IP for the web server just have to change nhttpd.conf accordingly.

Information:
    The binary has to be ran as sudo and the user configured to use the service has to 
    have permissions to atleast the log files.

    The files are split into to two directories:
        1 - /home/nostromousr/nostromo-1.9.6/*
        and
        2 - /var/nostromo/*
    Anything config related is in 2, but the actual binary is in 1.

    To start Nostromo run:
        From within /home/nostromousr/nostromo-1.9.6/src/nhttpd/
            - sudo ./nhttpd
        Or use the litral path:
            - sudo /home/nostromousr/nostromo-1.9.6/src/nhttpd/nhttpd

    Web server root is at:
        - /var/nostromo/htdocs
    Could add a randomly generated site etc.

    Flag file is made in:
        - /home/nostromousr/Documents/flag.txt
    But can be changed as needed.

Exploit Information:
    Usage
        - sudo python2.7 exploit.py <IP Address> <Port Number> <Command>

    The user lands in /bin. 
    The user would need to find their way to /home/nostromo/Documents/flag
    or just simply to /root/.