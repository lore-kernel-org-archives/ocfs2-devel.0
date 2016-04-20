From: Shichangkuo <shi.changkuo@h3c.com>
Date: Wed, 20 Apr 2016 07:53:23 +0000
Subject: [Ocfs2-devel] [PATCH] Mounting failed will not clean up dlm and o2hb
Message-ID: <D1E4D02760513D4B90DC3B40FF32AF355EE2843E@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all
    When mounting an ocfs2 device, the dlm will join the domian firstly, in ocfs2_dlm_init function. Then the storage link changes to inactive, then ocfs2_super_lock retutn -EIO.
ocfs2_dismount_volume will be called to clean up osb, but it just return when lock failed. This will cause dlm and o2hb thread still exits.

-------------------------
Signed-off-by: shichangkuo <shi.changkuo@h3c.com>
Reviewed-by: zhangguanghui <zhang.guanghui@h3c.com>

diff -pu linux-4.6-rc4/fs/ocfs2/super.c super.c
--- linux-4.6-rc4/fs/ocfs2/super.c      2016-04-18 10:13:32.000000000 +0800
+++ super.c     2016-04-20 15:45:31.306475078 +0800
@@ -1922,21 +1922,20 @@ static void ocfs2_dismount_volume(struct
        ocfs2_purge_refcount_trees(osb);

        /* No cluster connection means we've failed during mount, so skip
-        * all the steps which depended on that to complete. */
-       if (osb->cconn) {
+        * all the steps which depended on that to complete.
+    * to fix resource leaks and avoid call sb_getblk again, mount can't return*/
+       if (!mnt_err && osb->cconn) {
                tmp = ocfs2_super_lock(osb, 1);
                if (tmp < 0) {
                        mlog_errno(tmp);
-                       return;
+               } else {
+                       if (osb->slot_num != OCFS2_INVALID_SLOT)
+                ocfs2_put_slot(osb);
+
+               ocfs2_super_unlock(osb, 1);
                }
        }

-       if (osb->slot_num != OCFS2_INVALID_SLOT)
-               ocfs2_put_slot(osb);
-
-       if (osb->cconn)
-               ocfs2_super_unlock(osb, 1);
-
        ocfs2_release_system_inodes(osb);

        /*

Best regards.

Changkuo
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
