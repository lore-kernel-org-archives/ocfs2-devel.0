From: Guozhonghua <guozhonghua@h3c.com>
Date: Mon, 25 May 2015 12:34:28 +0000
Subject: [Ocfs2-devel] For reviews, thanks
Message-ID: <71604351584F6A4EBAE558C676F37CA4696D3E1B@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As dlm lock LVB different, the dlm lock migration may be failed without the dlm lock.
So the new owner will not have the dlm lock with the node, such as cookie 10:2696 as below.

diff -cp dlmrecovery_org.c dlmrecovery.c
*** dlmrecovery_org.c  2015-05-25 09:53:05.530826236 +0800
--- dlmrecovery.c    2015-05-25 10:01:12.242839116 +0800
*************** static void dlm_prepare_lvb_for_migratio
*** 1194,1199 ****
--- 1194,1203 ----
      if (!lock->lksb)
             return;

+     if (dlm_lvb_is_empty(lock->lksb->lvb)) {
+             return;
+     }
+
      /* Ignore lvb in all locks in the blocked list */
      if (queue == DLM_BLOCKED_LIST)
              return;

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150525/e5003bbe/attachment-0001.html 
