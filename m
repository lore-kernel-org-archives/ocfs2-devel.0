From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 10 May 2013 06:59:12 +0000
Subject: [Ocfs2-devel] =?gb2312?b?tPC4tDogIFBhdGNoIHJlcXVlc3QgcmV2aWV3cywg?=
 =?gb2312?b?Zm9yIG5vZGUgcmVjb25uZWN0aW5nIHdpdGggb3RoZXIgbm9kZXMgd2hvc2Ug?=
 =?gb2312?b?bm9kZSBudW1iZXIgaXMgbGl0dGxlIHRoYW4gbG9jYWwsIHRoYW5rcyBhIGxv?=
 =?gb2312?b?dC4=?=
In-Reply-To: <CAEeiSHXTeiH94R33ARx0-Lj7rBaLWUpCHscsdYH3WcOSdkubNw@mail.gmail.com>
References: <71604351584F6A4EBAE558C676F37CA417BD78AA@H3CMLB02-EX.srv.huawei-3com.com>
	<CAEeiSHXTeiH94R33ARx0-Lj7rBaLWUpCHscsdYH3WcOSdkubNw@mail.gmail.com>
Message-ID: <71604351584F6A4EBAE558C676F37CA417BD79B2@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thank you, but I have some questions about it.

The IP address of network used by o2net is different with that used by o2hb, such as the o2net use 192.168.0.7, but the storage network is 192.168.10.7.
So the tcp of o2net disconnected while the o2hb is still living writing heartbeat on the iSCSI LUNS.
Another condition may be that it is the "deadline" io scheduler used,  but the TCP message may use CFS, is it may cause o2hb is OK, but the o2net sometimes lose packets?

There is one scenario as below:
The Node  2013-SRV09(num 2) long time without messages from ZHJD-VM6 (num 6), so it disconnects the TCP with ZHJD-VM6 (num 6).
At the same time, the node ZHJD-VM6 detected TCP disconnection with 2013-SRV09, but ZHJD-VM6 does not reconnect 2013-SRV09, and so the ZHJD-VM6 is hanged.
At the same time the o2hb is still OK, they did not evict each other, and there are other six nodes in the ocfs2 cluster is still accessing the storage.
The two node is hangs up does not communicate with echo other but they can still access the storage disk, and the issue continued more than about 1 hour, we reboot all the nodes in the cluster to solve the issue.

The syslog digested of 2013-SRV09 is as below:
May  4 09:08:34 2013-SRV09 kernel: [310434.984511] o2net: No longer connected to node ZHJD-VM6 (num 6) at 185.200.1.17:7100
May  4 09:08:34 2013-SRV09 kernel: [310434.984558] (libvirtd,3314,7):dlm_send_remote_convert_request:395 ERROR: Error -112 when sending message 504 (key 0x77c0b1d1) to node 6
???????????????????????????????????????.
May  4 09:08:34 2013-SRV09 kernel: [310434.984653] (kvm,58972,29):dlm_send_remote_convert_request:395 ERROR: Error -112 when sending message 504 (key 0x77c0b1d1) to node 6
May  4 09:08:34 2013-SRV09 kernel: [310434.984663] o2dlm: Waiting on the death of node 6 in domain AE16636E1B83497A88D6A50178172ECA
???????????????????????????????????????.
May  4 09:08:39 2013-SRV09 kernel: [310440.077475] (libvirtd,3314,2):dlm_send_remote_convert_request:395 ERROR: Error -107 when sending message 504 (key 0x77c0b1d1) to node 6
???????????????????????????????????????.
May  4 10:11:05 2013-SRV09 kernel: [314178.586741] (kvm,58484,10):dlm_send_remote_convert_request:395 ERROR: Error -107 when sending message 504 (key 0x77c0b1d1) to node 6
May  4 10:11:05 2013-SRV09 kernel: [314178.586768] o2dlm: Waiting on the death of node 6 in domain AE16636E1B83497A88D6A50178172ECA
May  4 10:11:05 2013-SRV09 kernel: [314178.638607] (kvm,58972,11):dlm_send_remote_convert_request:395 ERROR: Error -107 when sending message 504 (key 0x77c0b1d1) to node 6
May  4 10:11:05 2013-SRV09 kernel: [314178.638622] o2dlm: Waiting on the death of node 6 in domain AE16636E1B83497A88D6A50178172ECA

The syslog on node ZHJD-VM6:
May  4 09:09:19 ZHJD-VM6 kernel: [348569.574247] o2net: Connection to node 2013-SRV09 (num 2) at 185.200.1.14:7100 shutdown, state 8
May  4 09:09:19 ZHJD-VM6 kernel: [348569.574317] o2net: No longer connected to node 2013-SRV09 (num 2) at 185.200.1.14:7100
May  4 09:09:19 ZHJD-VM6 kernel: [348569.574371] (dlm_thread,4818,7):dlm_send_proxy_ast_msg:484 ERROR: AE16636E1B83497A88D6A50178172ECA: res M000000000000000d4a010600000000, error -112 send AST to node 2
May  4 09:09:19 ZHJD-VM6 kernel: [348569.574388] (dlm_thread,4818,7):dlm_flush_asts:553 ERROR: status = -112
May  4 09:09:20 ZHJD-VM6 kernel: [348569.605818] (dlm_thread,4818,4):dlm_send_proxy_ast_msg:484 ERROR: AE16636E1B83497A88D6A50178172ECA: res M00000000000000246c010400000000, error -107 send AST to node 2
May  4 09:09:20 ZHJD-VM6 kernel: [348569.605839] (dlm_thread,4818,4):dlm_flush_asts:553 ERROR: status = -107
???????????????????????????????????????????.
May  4 10:12:30 ZHJD-VM6 kernel: [352357.836983] o2net: No connection established with node 2 after 30.0 seconds, giving up.
May  4 10:13:00 ZHJD-VM6 kernel: [352387.902370] o2net: No connection established with node 2 after 30.0 seconds, giving up.

If the condition satisfied, is there some ways to avoid the hangs issues?

Thanks a lot.


???: Sunil Mushran [mailto:sunil.mushran at gmail.com]
????: 2013?5?10? 1:02
???: guozhonghua 02084
??: ocfs2-devel at oss.oracle.com; ocfs2-devel-request at oss.oracle.com; changlimin 00148
??: Re: [Ocfs2-devel] Patch request reviews, for node reconnecting with other nodes whose node number is little than local, thanks a lot.

A better fix is to _not_ disconnect on o2net timeout once a connection has been
cleanly established. Only disconnect on o2hb timeout.
The reconnects are a problem as we could lose packets and not be aware of it
leading to o2dlm hangs.
IOW, this patch looks to be papering over one specific problem and does not fix the
underlying issue.


On Tue, May 7, 2013 at 7:43 PM, Guozhonghua <guozhonghua at h3c.com<mailto:guozhonghua@h3c.com>> wrote:

Hi, everyone,
I had have a test with eight nodes and find one issue.

The Linux kernel version is 3.2.40.

As I migrate processes from one node to another, those processes is open the files on the OCFS2 storage. Sometime one node shutdown TCP connection with that node whose node number is larger because long time without any message from it.
As the TCP connection shutdown, the node whose number larger did not restart connection to the node, whose number is little and shutdown the TCP connection.
So I review the code of the cluster and find it may be a bug.

I changed it and have a test.

Is there anybody having time to view and make sure that those changes is correct?
Thanks a lot.

The diff file is as below, of the file is /cluster/tcp.c:

root at gzh-dev:/home/dev/test_replace/ocfs2_ko# diff -pu ocfs2-ko-3.2-compare/cluster/tcp.c ocfs2-ko-3.2/cluster/tcp.c
--- ocfs2-ko-3.2-compare/cluster/tcp.c  2012-10-29 19:33:19.534200000 +0800
+++ ocfs2-ko-3.2/cluster/tcp.c        2013-05-08 09:33:16.386277310 +0800
@@ -1699,6 +1698,10 @@ static void o2net_start_connect(struct w
      if (ret == -EINPROGRESS)
              ret = 0;
+      /** Reset the timeout with 0 to avoid connection again */
+      if (ret == 0) {
+              atomic_set(&nn->nn_timeout, 0);
+      }
out:
      if (ret) {
              printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
@@ -1725,6 +1728,11 @@ static void o2net_connect_expired(struct
       spin_lock(&nn->nn_lock);
      if (!nn->nn_sc_valid) {
+              /** trigger reconnect with other nodes whose node number is little than local
+              *  while they are still able to access the storage
+              */
+              atomic_set(&nn->nn_timeout, 1);
+
               printk(KERN_NOTICE "o2net: No connection established with "
                     "node %u after %u.%u seconds, giving up.\n",
                   o2net_num_from_nn(nn),
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130510/84696178/attachment-0001.html 
