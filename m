From: Guozhonghua <guozhonghua@h3c.com>
Date: Tue, 11 Mar 2014 11:09:14 +0000
Subject: [Ocfs2-devel] One Patch reported, Anyone review it, thanks
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC3CCB9@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I review the code of the kernel 3.11.10.

The difference is as below:

-- ../linux-3.11.10/fs/ocfs2/dlm/dlmdomain.c       2013-11-30 02:42:37.000000000 +0800
+++ ocfs2-ko-3.11/dlm/dlmdomain.c     2014-03-11 18:57:23.323897515 +0800
@@ -1135,6 +1135,9 @@ static int dlm_query_region_handler(stru
      int status = 0;
      int locked = 0;
+    /* Wether domain locked */
+    int domain_locked = 0;
+
      qr = (struct dlm_query_region *) msg->buf;
       mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
@@ -1150,6 +1153,7 @@ static int dlm_query_region_handler(stru
      status = -EINVAL;
       spin_lock(&dlm_domain_lock);
+    domain_locked = 1;
      dlm = __dlm_lookup_domain_full(qr->qr_domain, qr->qr_namelen);
      if (!dlm) {
              mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
@@ -1181,9 +1185,12 @@ static int dlm_query_region_handler(stru
bail:
      if (locked)
              spin_unlock(&dlm->spinlock);
-       spin_unlock(&dlm_domain_lock);
-       kfree(local);
+    if (domain_locked)
+        spin_unlock(&dlm_domain_lock);
+
+    if (local)
+        kfree(local);
       return status;
}
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140311/10b2ed58/attachment.html 
