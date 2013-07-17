From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 17 Jul 2013 15:55:52 +0800
Subject: [Ocfs2-devel] Is it an issue and whether the code changed
 correct? Thanks a lot
In-Reply-To: <71604351584F6A4EBAE558C676F37CA417BD8D31@H3CMLB02-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA417BD8D31@H3CMLB02-EX.srv.huawei-3com.com>
Message-ID: <51E64E08.3090003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

[Add Srinivas/Xiaofei to CC list as they are investigating OCFS2 net related issues]

Hi Guo,

Thanks for your reports and analysis!

On 07/16/2013 05:06 PM, Guozhonghua wrote:

> Hi, everyone, is that an issue?
> 

That is an issue because we should keep attempting to reconnect
back until the connection is established or captured a disk
heartbeat down event.

This strategy has been described at upstream commit:
	5cc3bf2786f63cceb191c3c02ddd83c6f38a7d64
    		ocfs2:  Reconnect after idle time out.


> The Server version is Linux 3.2.0-23, Ubuntu 1204.

Generally speaking, we dig into potential problems against the
mainline updated source tree, linux-next is fine for OCFS2.
One important reason is that the facing issue on an old release
might be fixed recently. 

> There are 4 nodes in the OCFS2 Cluster, using three iSCSI LUNS, and
> every LUN is one OCFS2 domain mounted by thread node.
> 
>  
> 
> As the network used buy node has one down/up, the tcp connection between
> node shutdown and reconnected with each other.


> But there is one scenario that the node whose node number is little,
> shut down the tcp with node whose number is large, the node with large
> node number will not reconnect the node with little node number.
> 
> The otherwise is that if the node with large node number shut down the
> tcp with node with little number, the node with large node number will
> reconnect the node with little node number OK.

Could you please clarify your test scenario in a bit more detail?

Anyway, re-initialize the timeout to trigger reconnection looks fair to me,
but I'd like to see some comments from Srinivas and Xiaofei.

Btw, that's better if you would make patch via git and setup your email box by
following up the instructions at Documentation/email-clients.txt, please feel free
to drop me an offline email if you have any question regarding this. 


Thanks,
-Jeff

> 
>  
> 
> Such as below:
> 
> The server1 syslog is as below:
> 
> Jul  9 17:46:10 server1 kernel: [5199872.576027] o2net: Connection to
> node server2 (num 2) at 192.168.70.20:7100 shutdown, state 8
> 
> Jul  9 17:46:10 server1 kernel: [5199872.576111] o2net: No longer
> connected to node server2 (num 2) at 192.168.70.20:7100
> 
> Jul  9 17:46:10 server1 kernel: [5199872.576149]
> (ocfs2dc,14358,1):dlm_send_remote_convert_request:395 ERROR: Error -107
> when sending message 504 (key 0x3671059b) to node 2
> 
> Jul  9 17:46:10 server1 kernel: [5199872.576162] o2dlm: Waiting on the
> death of node 2 in domain 3656D53908DC4149983BDB1DBBDF1291
> 
> Jul  9 17:46:10 server1 kernel: [5199872.576428] o2net: Accepted
> connection from node server2 (num 2) at 192.168.70.20:7100
> 
> Jul  9 17:46:11 server1 kernel: [5199872.995898] o2net: Connection to
> node server3 (num 3) at 192.168.70.30:7100 has been idle for 30.100
> secs, shutting it down.
> 
> Jul  9 17:46:11 server1 kernel: [5199872.995987] o2net: No longer
> connected to node server3 (num 3) at 192.168.70.30:7100
> 
> Jul  9 17:46:11 server1 kernel: [5199873.069666] o2net: Connection to
> node server4 (num 4) at 192.168.70.40:7100 shutdown, state 8
> 
> Jul  9 17:46:11 server1 kernel: [5199873.069700] o2net: No longer
> connected to node server4 (num 4) at 192.168.70.40:7100
> 
> Jul  9 17:46:11 server1 kernel: [5199873.070385] o2net: Accepted
> connection from node server4 (num 4) at 192.168.70.40:7100
> 
>  
> 
> The server1 shutdown the tcp connection with server3, but server3 never
> reconnect with server1.
> 
>  
> 
> The server3 syslog is as below:
> 
> Jul  9 17:44:12 server3 kernel: [3971907.332698] o2net: Connection to
> node server1 (num 1) at 192.168.70.10:7100 shutdown, state 8
> 
> Jul  9 17:44:12 server3 kernel: [3971907.332748] o2net: No longer
> connected to node server1 (num 1) at 192.168.70.10:7100
> 
> Jul  9 17:44:42 server3 kernel: [3971937.355419] o2net: No connection
> established with node 1 after 30.0 seconds, giving up.
> 
> Jul  9 17:45:01 server3 CRON[52349]: (root) CMD (command -v debian-sa1 >
> /dev/null && debian-sa1 1 1)
> 
> Jul  9 17:45:12 server3 kernel: [3971967.421656] o2net: No connection
> established with node 1 after 30.0 seconds, giving up.
> 
> Jul  9 17:45:42 server3 kernel: [3971997.487949] o2net: No connection
> established with node 1 after 30.0 seconds, giving up.
> 
> Jul  9 17:46:12 server3 kernel: [3972027.554258] o2net: No connection
> established with node 1 after 30.0 seconds, giving up.
> 
> Jul  9 17:46:42 server3 kernel: [3972057.620496] o2net: No connection
> established with node 1 after 30.0 seconds, giving up.
> 
>  
> 
> The node of server2 and server4 shut down the connection with server1,
> and reconnect them ok.
> 
>  
> 
> I review the code of the ocfs2 kernel and found this may be an issue or bug.
> 
>  
> 
> As node of server1 did not receive msg from server3, he shut the
> connection with server3 and set the timeout with 1.
> 
> The server1?s node number is little than server3, so he wait the connect
> request from server3.
> 
> static void o2net_idle_timer(unsigned long data)
> 
> {
> 
>     ? ?
> 
>         printk(KERN_NOTICE "o2net: Connection to " SC_NODEF_FMT " has been "
> 
>                "idle for %lu.%lu secs, shutting it down.\n",
> SC_NODEF_ARGS(sc),
> 
>                msecs / 1000, msecs % 1000);
> 
>     ?.. ?
> 
>         atomic_set(&nn->nn_timeout, 1);
> 
>         o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
> 
> }
> 
>  
> 
> But the server3 monitoring the TCP connection state changed and shutdown
> connect again and it will never reconnect with server1 because the
> nn->nn_timeout is 0.
> 
>  
> 
> static void o2net_state_change(struct sock *sk)
> 
> {
> 
> ??
> 
>         switch(sk->sk_state) {
> 
>         ??
> 
>                 default:
> 
>                         printk(KERN_INFO "AAAAA o2net: Connection to "
> SC_NODEF_FMT
> 
>                               " shutdown, state %d\n",
> 
>                               SC_NODEF_ARGS(sc), sk->sk_state);
> 
>                         o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
> 
>                         break;
> 
>         }
> 
> ? ?
> 
> }
> 
>  
> 
> I had test the TCP connect without any shutdown between nodes, but send
> message will failed because the connection state is error.
> 
>  
> 
>  
> 
> I change the code for the connect triggers in function
> o2net_set_nn_state and o2net_start_connect, and the reconnect rebuild up OK.
> 
> Is anyone review the code correct? Thanks a lots.
> 
>  
> 
> root at gzh-dev:~/ocfs2# diff -p -C 10 ./ocfs2_org/cluster/tcp.c
> ocfs2_rep/cluster/tcp.c 
> 
> *** ./ocfs2_org/cluster/tcp.c 2012-10-29 19:33:19.534200000 +0800
> 
> --- ocfs2_rep/cluster/tcp.c      2013-07-16 16:58:31.380452531 +0800
> 
> *************** static void o2net_set_nn_state(struct o2
> 
> *** 567,586 ****
> 
> --- 567,590 ----
> 
>       if (!valid && o2net_wq) {
> 
>               unsigned long delay;
> 
>               /* delay if we're within a RECONNECT_DELAY of the
> 
>                * last attempt */
> 
>               delay = (nn->nn_last_connect_attempt +
> 
>                        msecs_to_jiffies(o2net_reconnect_delay()))
> 
>                       - jiffies;
> 
>               if (delay > msecs_to_jiffies(o2net_reconnect_delay()))
> 
>                       delay = 0;
> 
>               mlog(ML_CONN, "queueing conn attempt in %lu jiffies\n",
> delay);
> 
> +         
> 
> +             /** Trigger the reconnection */
> 
> +             atomic_set(&nn->nn_timeout, 1); 
> 
> +
> 
>               queue_delayed_work(o2net_wq, &nn->nn_connect_work, delay);
> 
>  
> 
>               /*
> 
>                * Delay the expired work after idle timeout.
> 
>                *
> 
>                * We might have lots of failed connection attempts that run
> 
>                * through here but we only cancel the connect_expired
> work when
> 
>                * a connection attempt succeeds.  So only the first
> enqueue of
> 
>                * the connect_expired work will do anything.  The rest
> will see
> 
>                * that it's already queued and do nothing.
> 
> *************** static void o2net_start_connect(struct w
> 
> *** 1691,1710 ****
> 
> --- 1695,1719 ----
> 
>       remoteaddr.sin_family = AF_INET;
> 
>       remoteaddr.sin_addr.s_addr = node->nd_ipv4_address;
> 
>       remoteaddr.sin_port = node->nd_ipv4_port;
> 
>  
> 
>       ret = sc->sc_sock->ops->connect(sc->sc_sock,
> 
>                                       (struct sockaddr *)&remoteaddr,
> 
>                                       sizeof(remoteaddr),
> 
>                                       O_NONBLOCK);
> 
>       if (ret == -EINPROGRESS)
> 
>               ret = 0;
> 
> +        
> 
> +     /** Reset the timeout with 0 to avoid connection again, Just for
> test the tcp connection */
> 
> +         if (ret == 0) {
> 
> +                 atomic_set(&nn->nn_timeout, 0);       
> 
> +         }
> 
>  
> 
>   out:
> 
>       if (ret) {
> 
>               printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
> 
>                      " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
> 
>               /* 0 err so that another will be queued and attempted
> 
>                * from set_nn_state */
> 
>               if (sc)
> 
>                       o2net_ensure_shutdown(nn, sc, 0);
> 
>       }
> 
