From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed, 31 Mar 2010 14:07:31 -0700
Subject: [Ocfs2-devel] o2net patch to lock socket shutdown message
Message-ID: <1270069652-9848-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch logs socket shutdown messages. Below is the snippet of how
the message looks (new message ends with "... shutdown, state #")

[root at el532p-3 ~]# mount /dev/hdb /vol1
Mar 31 11:14:18 el532p-3 kernel: connection to node el532p-2 (num 64) at 10.35.70.104:7777 shutdown, state 8
Mar 31 11:14:18 el532p-3 kernel: connection to node el532p-2 (num 64) at 10.35.70.104:7777 shutdown, state 7
Mar 31 11:14:20 el532p-3 kernel: o2net: connected to node el532p-2 (num 64) at 10.35.70.104:7777
Mar 31 11:14:20 el532p-3 kernel: connection to node el532p-1 (num 63) at 10.35.70.103:7777 shutdown, state 8
Mar 31 11:14:20 el532p-3 kernel: o2net: accepted connection from node el532p-4 (num 66) at 10.35.70.106:7777
Mar 31 11:14:22 el532p-3 kernel: o2net: connected to node el532p-1 (num 63) at 10.35.70.103:7777
Mar 31 11:14:25 el532p-3 kernel: svc: failed to register lockdv1 RPC service (errno 97).
[root at el532p-3 ~]# Mar 31 11:14:27 el532p-3 kernel: OCFS2 1.5.0
Mar 31 11:14:27 el532p-3 kernel: ocfs2_dlm: Nodes in domain ("B940154B0B044964BC649D7717B21B19"): 64 65 66 
Mar 31 11:14:27 el532p-3 kernel: ocfs2: Mounting device (3,64) on (node 65, slot 2) with ordered data mode.
Mar 31 11:14:28 el532p-3 kernel: ocfs2_dlm: Node 63 joins domain B940154B0B044964BC649D7717B21B19
Mar 31 11:14:28 el532p-3 kernel: ocfs2_dlm: Nodes in domain ("B940154B0B044964BC649D7717B21B19"): 63 64 65 66 
