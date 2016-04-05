From: Shichangkuo <shi.changkuo@h3c.com>
Date: Tue, 5 Apr 2016 08:36:32 +0000
Subject: [Ocfs2-devel] [Ocfs2-tools] [Ocfs2-tools-devel] [PATCH 1/1] o2hb
 doesn't not exit when fsck uncleanly device
Message-ID: <D1E4D02760513D4B90DC3B40FF32AF355EE263D6@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Srinivas,
    When I run fsck to recover an unclean device, I find that the o2hb thread doesn't exit.  The version is 1.8.4, and I also find the same issue on other versions.
    After reviewing codes, re-open device will make ost->ost_fs->fs_dlm_ctxt change to NULL after replayed journals. At the end of code, it will determines whether to exit dlm and o2hb by this pointer.
    Recording the pointer will solve the issue.

diff -up a/ocfs2-tools/libocfs2/openfs.c b/ocfs2-tools/libocfs2/openfs.c
--- a/ocfs2-tools/libocfs2/openfs.c
+++ b/ocfs2-tools/libocfs2/openfs.c
@@ -464,6 +464,8 @@
                  ptr += 2;
        }
+       if (*ret_fs && (*ret_fs)->fs_dlm_ctxt)
+                fs->fs_dlm_ctxt = (*ret_fs)->fs_dlm_ctxt;
        *ret_fs = fs;
        return 0;

BTW: why should we open the device twice in this scene?

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160405/39a37054/attachment.html 
