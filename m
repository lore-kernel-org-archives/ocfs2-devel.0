From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 8 May 2013 02:43:15 +0000
Subject: [Ocfs2-devel] Patch request reviews,
 for node reconnecting with other nodes whose node number is little
 than local, thanks a lot.
Message-ID: <71604351584F6A4EBAE558C676F37CA417BD78AA@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130508/c89d948c/attachment.html 
