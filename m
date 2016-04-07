From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 7 Apr 2016 09:16:18 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up an unuseful goto in
 ocfs2_put_slot function
Message-ID: <71604351584F6A4EBAE558C676F37CA48294933C@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The goto is not useful in the function ocfs2_put_slot, so delete it.

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>

--- ocfs2.org/slot_map.c        2016-03-25 15:29:22.175343770 +0800
+++ ocfs2/slot_map.c    2016-04-07 16:53:25.540793954 +0800
@@ -535,12 +535,9 @@ void ocfs2_put_slot(struct ocfs2_super *
        spin_unlock(&osb->osb_lock);

        status = ocfs2_update_disk_slot(osb, si, slot_num);
-       if (status < 0) {
+       if (status < 0)
                mlog_errno(status);
-               goto bail;
-       }
-
-bail:
+
        ocfs2_free_slot_info(osb);
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
