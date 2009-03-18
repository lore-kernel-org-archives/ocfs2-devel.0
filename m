From: David Winter <david.winter@zeec.biz>
Date: Wed, 18 Mar 2009 12:17:36 +0100
Subject: [Ocfs2-devel] shutdown by o2net_idle_timer causes Xen to hang
Message-ID: <8C38B97A-7440-4F01-ADFE-FCF3777D6486@zeec.biz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

we've had some serious trouble with a two-node Xen-based OCFS2  
cluster. In brief: we had two incidents where one node detects an idle  
timeout and shuts the other node down which causes the other node and  
the Dom0 to hang. Both times this could only be resolved by rebooting  
the whole machine using the built-in IPMI card.

All machines (including the other DomUs) run Centos 5.2 and the OCFS2  
nodes use ocfs2-tools-1.4.1-1.el5 and  
ocfs2-2.6.18-92.1.13.el5xen-1.4.1-1.el5.

Unfortunately there wasn't logged much of relevance, except for the / 
var/log/messages of the node that issued the shutdown (see below) and  
the nearly five hour gap in the logs of the other node.

Mar 15 14:39:47 ugc-1 kernel: o2net: connection to node cod-2 (num 3)  
at 10.0.0.42:7777 has been idle for 30.0 seconds, shutting it down.
Mar 15 14:39:47 ugc-1 kernel: (0,0):o2net_idle_timer:1476 here are  
some times that might help debug the situation: (tmr 1237124357.624587  
now 1237124387.624394 dr 1237124357.624578 adv  
1237124357.624588:1237124357.624589 func (be795f6d:507)  
1237124191.594238:1237124191.594242)
Mar 15 14:39:47 ugc-1 kernel: o2net: no longer connected to node cod-2  
(num 3) at 10.0.0.42:7777
Mar 15 14:39:47 ugc-1 kernel: (24452,0):dlm_do_master_request:1335  
ERROR: link to 3 went down!
Mar 15 14:39:47 ugc-1 kernel: (24452,0):dlm_get_lock_resource:912  
ERROR: status = -112
Mar 15 14:40:17 ugc-1 kernel: (1743,0):o2net_connect_expired:1637  
ERROR: no connection established with node 3 after 30.0 seconds,  
giving up and returning errors.
Mar 15 14:44:29 ugc-1 kernel: (16225,0):dlm_do_master_request:1335  
ERROR: link to 3 went down!
Mar 15 14:44:29 ugc-1 kernel: (16225,0):dlm_get_lock_resource:912  
ERROR: status = -107
Mar 15 14:44:47 ugc-1 kernel: (1743,0):o2net_connect_expired:1637  
ERROR: no connection established with node 3 after 30.0 seconds,  
giving up and returning errors.
Mar 15 14:46:59 ugc-1 kernel: (24456,0):dlm_do_master_request:1335  
ERROR: link to 3 went down!
Mar 15 14:46:59 ugc-1 kernel: (24456,0):dlm_get_lock_resource:912  
ERROR: status = -107
Mar 15 14:46:59 ugc-1 kernel: (27195,0):dlm_do_master_request:1335  
ERROR: link to 3 went down!
Mar 15 14:46:59 ugc-1 kernel: (27195,0):dlm_get_lock_resource:912  
ERROR: status = -107

Is this already a known issue and if so, is there a workaround or fix?

Thanks in advance.


Regards, David
