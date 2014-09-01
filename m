From: Guozhonghua <guozhonghua@h3c.com>
Date: Mon, 1 Sep 2014 07:14:09 +0000
Subject: [Ocfs2-devel] Bug report and patch request reviews, thanks
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC66392@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi? we test one file which is larger than 2T, then we get the information wrong.

Without patch, the result is as below, OCFS2, and you can see that size of the file and the blocks is not well:
    # ls -al /vms/ocfs2lv/test_base_0
    -rw------- 1 root root 2618930032640 Aug 29 19:00 /vms/ocfs2lv/test_base_0

    # stat --format="%b %B" /vms/ocfs2lv/test_base_0
    820127744 512

    # ls -alsi /vms/ocfs2lv/test_base_0
    2100482 410063872 -rw------- 1 root root 2618930032640 Aug 29 19:00 /vms/ocfs2lv/test_base_0

    # ls -al /vms/ocfs2lv/test_base_0
    -rw------- 1 root root 2618930032640 Aug 29 19:00 /vms/ocfs2lv/test_base_0

With patch, the information of the file is correct, and the file may be have some parse space in it, so the diff of the space can be ingnored:
        # stat --format "%b %B" /vms/ocfs2lv/test_base_0
    5115095040 512

    # ls -alsi /vms/ocfs2lv/test_base_0
    2100482 2557547520 -rw------- 1 root root 2618930032640 Aug 29 19:00 /vms/ocfs2lv/test_base_0

The patch is as below, we known that the blocks count is not correct, but we are not sure the patch has any side-effect with other part of OCFS2, so requesting reviews.
Would some OCFS2 experts have time to review it and merged it into main line? Thanks

---  inode.h    2014-08-09 14:23:42.609594669 +0800
+++ inode.h     2014-09-01 14:30:37.224294249 +0800

@@ -157,7 +155,7 @@ static inline blkcnt_t ocfs2_inode_sector_count(struct inode *inode)
{
      int c_to_s_bits = OCFS2_SB(inode->i_sb)->s_clustersize_bits - 9;
-       return (blkcnt_t)(OCFS2_I(inode)->ip_clusters << c_to_s_bits);
+      return (blkcnt_t)((unsigned long)OCFS2_I(inode)->ip_clusters << c_to_s_bits);
}


-------------------------------------------------------------------------------------------------------------------------------------
??????????????????????????,?????????????
?????????????????????(??????????????????
???)?????????????????,??????????????????
??!
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140901/3760a7c1/attachment.html 
