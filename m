From: Guozhonghua <guozhonghua@h3c.com>
Date: Tue, 13 Sep 2016 07:52:30 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2:  free the mle while the res had one,
 to avoid mle memory leak.
Message-ID: <71604351584F6A4EBAE558C676F37CA4A3D3522A@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the function dlm_migrate_request_handler, while the ret is --EEXIST, the mle should be freed, otherwise the memory will be leaked.

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>

--- ocfs2.orig/dlm/dlmmaster.c  2016-09-13 15:18:13.602684325 +0800
+++ ocfs2/dlm/dlmmaster.c       2016-09-13 15:27:05.014675736 +0800
@@ -3188,6 +3188,9 @@ int dlm_migrate_request_handler(struct o
                                    migrate->new_master,
                                    migrate->master);

+       if (ret < 0)
+               kmem_cache_free(dlm_mle_cache, mle);
+
        spin_unlock(&dlm->master_lock);
 unlock:
        spin_unlock(&dlm->spinlock);


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
