From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 28 Oct 2016 02:19:53 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Delete redundant code and set the node
 bit into maybe_map directly.
Message-ID: <71604351584F6A4EBAE558C676F37CA4A3D490DD@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


The variables set_maybe is redundant while mle had been found in the map. So it is ok to set the node_idx into mle's maybe_map directly.
This patch is based on linux-4.9-rc2.

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>

--- ocfs2.orig/dlm/dlmmaster.c  2016-10-28 09:35:55.180696409 +0800
+++ ocfs2/dlm/dlmmaster.c       2016-10-28 09:40:19.020703391 +0800
@@ -1609,8 +1609,6 @@ way_up_top:
                __dlm_insert_mle(dlm, mle);
                response = DLM_MASTER_RESP_NO;
        } else {
-               // mlog(0, "mle was found\n");
-               set_maybe = 1;
                spin_lock(&tmpmle->spinlock);
                if (tmpmle->master == dlm->node_num) {
                        mlog(ML_ERROR, "no lockres, but an mle with this node as master!\n");
@@ -1625,8 +1623,7 @@ way_up_top:
                        response = DLM_MASTER_RESP_NO;
                } else
                        response = DLM_MASTER_RESP_MAYBE;
-               if (set_maybe)
-                       set_bit(request->node_idx, tmpmle->maybe_map);
+               set_bit(request->node_idx, tmpmle->maybe_map);
                spin_unlock(&tmpmle->spinlock);
        }
        spin_unlock(&dlm->master_lock);

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
