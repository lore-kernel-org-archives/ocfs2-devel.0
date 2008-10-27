From: tristan.ye <tristan.ye@oracle.com>
Date: Mon, 27 Oct 2008 15:22:58 +0800
Subject: [Ocfs2-devel] [PATCH 00/00] Implement quotas for OCFS2 (version
	2)
In-Reply-To: <12248859043309-git-send-email-jack@suse.cz>
References: yes  <12248859043309-git-send-email-jack@suse.cz>
Message-ID: <1225092179.6525.18.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, 2008-10-25 at 00:05 +0200, Jan Kara wrote:
> Hello,
> 
> the following patch series implements quotas for OCFS2. The patch
> series is based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git linux-next

Jan,

I was working on the latest pulled ocfs2.git you mentioned above,seems
the new patches series you've sent still can be applied correctly
there,hit following errors when applying the patches,

[root at ocfs2-test6 linux-next]# for i in $(seq 29);do echo "****Applying
patch #${i}****";patch -p1</work/quota-patches/quota-patch${i};done

****Applying patch #1****
patching file fs/dquot.c
patching file include/linux/quota.h
****Applying patch #2****
patching file fs/dquot.c
patching file fs/quota_v1.c
patching file fs/quota_v2.c
patching file include/linux/quota.h
patching file include/linux/quotaops.h
****Applying patch #3****
patching file fs/dquot.c
****Applying patch #4****
patching file fs/dquot.c
patching file include/linux/quotaops.h
****Applying patch #5****
patching file fs/dquot.c
patching file fs/quota.c
patching file include/linux/quota.h
patching file include/linux/quotaops.h
****Applying patch #6****
patching file fs/ext3/super.c
****Applying patch #7****
patching file fs/ext4/super.c
****Applying patch #8****
patching file fs/reiserfs/super.c
****Applying patch #9****
patching file include/linux/quotaops.h
****Applying patch #10****
patching file fs/dquot.c
patching file fs/quota.c
patching file include/linux/quota.h
****Applying patch #11****
patching file fs/quota_v1.c
patching file fs/quota_v2.c
patching file fs/quotaio_v1.h
patching file fs/quotaio_v2.h
patching file include/linux/quotaio_v1.h
patching file include/linux/quotaio_v2.h
****Applying patch #12****
patching file fs/Kconfig
Hunk #1 succeeded at 583 (offset -18 lines).
patching file fs/Makefile
Hunk #1 succeeded at 53 (offset -1 lines).
patching file fs/quota_tree.c
patching file fs/quota_tree.h
patching file fs/quota_v2.c
patching file fs/quotaio_v2.h
patching file include/linux/dqblk_qtree.h
patching file include/linux/dqblk_v2.h
****Applying patch #13****
patching file fs/quota_v2.c
patching file include/linux/dqblk_v1.h
patching file include/linux/dqblk_v2.h
patching file include/linux/quota.h
****Applying patch #14****
patching file fs/dquot.c
patching file include/linux/quota.h
****Applying patch #15****
patching file fs/dquot.c
patching file include/linux/quota.h
****Applying patch #16****
patching file fs/dquot.c
patching file include/linux/quotaops.h
****Applying patch #17****
patching file fs/dquot.c
patching file include/linux/quotaops.h
****Applying patch #18****
patching file mm/pdflush.c
****Applying patch #19****
patching file fs/ocfs2/file.c
Hunk #1 succeeded at 246 (offset -1 lines).
Hunk #3 succeeded at 1209 (offset 153 lines).
Hunk #4 succeeded at 1259 (offset -1 lines).
Hunk #5 succeeded at 1506 (offset 153 lines).
****Applying patch #20****
patching file fs/ocfs2/journal.c
Hunk #2 FAILED at 283.
1 out of 2 hunks FAILED -- saving rejects to file fs/ocfs2/journal.c.rej
****Applying patch #21****
patching file fs/ocfs2/namei.c
Hunk #1 succeeded at 382 (offset 4 lines).
****Applying patch #22****
patching file fs/ocfs2/namei.c
Hunk #1 succeeded at 495 (offset 4 lines).
****Applying patch #23****
patching file fs/ocfs2/inode.c
Hunk #1 succeeded at 286 (offset -6 lines).
patching file fs/ocfs2/ocfs2_fs.h
Hunk #1 FAILED at 93.
Hunk #2 succeeded at 155 (offset -4 lines).
Hunk #4 succeeded at 322 (offset -10 lines).
Hunk #6 succeeded at 355 (offset -10 lines).
1 out of 6 hunks FAILED -- saving rejects to file
fs/ocfs2/ocfs2_fs.h.rej
patching file fs/ocfs2/super.c
Hunk #1 succeeded at 213 (offset -8 lines).
Hunk #3 succeeded at 284 (offset -8 lines).
****Applying patch #24****
patching file fs/ocfs2/inode.c
Hunk #1 succeeded at 278 (offset -6 lines).
****Applying patch #25****
patching file fs/ocfs2/Makefile
Hunk #1 FAILED at 35.
1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/Makefile.rej
patching file fs/ocfs2/cluster/masklog.h
Hunk #1 FAILED at 113.
1 out of 1 hunk FAILED -- saving rejects to file
fs/ocfs2/cluster/masklog.h.rej
patching file fs/ocfs2/dir.c
Hunk #1 FAILED at 82.
1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/dir.c.rej
patching file fs/ocfs2/dlmglue.c
Hunk #9 succeeded at 3490 (offset 5 lines).
patching file fs/ocfs2/dlmglue.h
patching file fs/ocfs2/file.c
Hunk #1 succeeded at 302 (offset -1 lines).
patching file fs/ocfs2/file.h
Hunk #1 FAILED at 51.
1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/file.h.rej
patching file fs/ocfs2/inode.h
Hunk #1 succeeded at 140 (offset -2 lines).
patching file fs/ocfs2/ocfs2_fs.h
Hunk #1 succeeded at 730 with fuzz 2 (offset -148 lines).
patching file fs/ocfs2/ocfs2_lockid.h
patching file fs/ocfs2/quota.h
patching file fs/ocfs2/quota_global.c
patching file fs/ocfs2/quota_local.c
patching file fs/ocfs2/super.c
Hunk #1 FAILED at 65.
Hunk #2 succeeded at 139 (offset -1 lines).
Hunk #3 succeeded at 1040 (offset -36 lines).
Hunk #4 succeeded at 1099 (offset -1 lines).
Hunk #5 succeeded at 1180 (offset -37 lines).
Hunk #6 succeeded at 1245 (offset -1 lines).
1 out of 6 hunks FAILED -- saving rejects to file fs/ocfs2/super.c.rej
****Applying patch #26****
patching file fs/ocfs2/alloc.c
Hunk #2 succeeded at 5946 (offset -405 lines).
Hunk #3 FAILED at 6261.
Hunk #4 succeeded at 6681 (offset -5 lines).
Hunk #5 succeeded at 6301 (offset -405 lines).
Hunk #6 succeeded at 6780 (offset -6 lines).
1 out of 6 hunks FAILED -- saving rejects to file fs/ocfs2/alloc.c.rej
patching file fs/ocfs2/aops.c
Hunk #2 succeeded at 1737 (offset -14 lines).
Hunk #4 succeeded at 1763 (offset -14 lines).
patching file fs/ocfs2/dir.c
Hunk #2 succeeded at 1183 (offset -34 lines).
Hunk #3 FAILED at 1194.
Hunk #4 succeeded at 1263 (offset -3 lines).
Hunk #5 succeeded at 1360 (offset -34 lines).
Hunk #6 succeeded at 1418 (offset -3 lines).
Hunk #7 FAILED at 1428.
Hunk #8 succeeded at 1429 (offset -34 lines).
2 out of 8 hunks FAILED -- saving rejects to file fs/ocfs2/dir.c.rej
patching file fs/ocfs2/file.c
Hunk #2 FAILED at 57.
Hunk #3 FAILED at 538.
Hunk #4 succeeded at 744 (offset 156 lines).
Hunk #6 succeeded at 1057 (offset 158 lines).
Hunk #7 succeeded at 966 (offset -6 lines).
Hunk #8 succeeded at 1193 (offset 158 lines).
Hunk #9 succeeded at 1311 (offset -6 lines).
2 out of 9 hunks FAILED -- saving rejects to file fs/ocfs2/file.c.rej
patching file fs/ocfs2/inode.c
Hunk #2 succeeded at 602 (offset -18 lines).
Hunk #4 succeeded at 911 (offset -25 lines).
patching file fs/ocfs2/journal.h
Hunk #1 succeeded at 283 with fuzz 2 (offset -10 lines).
Hunk #3 succeeded at 337 (offset -10 lines).
Hunk #5 succeeded at 386 with fuzz 2 (offset -10 lines).
Hunk #6 FAILED at 427.
Hunk #7 succeeded at 474 (offset -12 lines).
1 out of 7 hunks FAILED -- saving rejects to file fs/ocfs2/journal.h.rej
patching file fs/ocfs2/namei.c
Hunk #2 succeeded at 66 (offset -1 lines).
Hunk #4 succeeded at 230 (offset -1 lines).
Hunk #6 succeeded at 305 (offset -1 lines).
Hunk #8 succeeded at 385 with fuzz 2 (offset 4 lines).
Hunk #10 succeeded at 416 (offset 4 lines).
Hunk #12 succeeded at 462 (offset 4 lines).
Hunk #14 succeeded at 519 (offset 4 lines).
Hunk #16 succeeded at 808 (offset 7 lines).
Hunk #17 succeeded at 1214 (offset 7 lines).
Hunk #18 succeeded at 1539 (offset 17 lines).
Hunk #19 succeeded at 1586 (offset 7 lines).
Hunk #20 succeeded at 1611 (offset 17 lines).
Hunk #21 FAILED at 1635.
Hunk #22 succeeded at 1687 (offset 7 lines).
Hunk #23 succeeded at 1717 (offset 20 lines).
1 out of 23 hunks FAILED -- saving rejects to file fs/ocfs2/namei.c.rej
can't find file to patch@input line 945
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
|index 802c414..d4bc0ab 100644
|--- a/fs/ocfs2/xattr.c
|+++ b/fs/ocfs2/xattr.c
--------------------------
File to patch: 
==============end=======================


So i turn to the latest 2.6.27 mainline
kernel(git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git) for another attempt,it succeeded:)

However,the testing for quota on ocfs2 still being blocked by the mkfs
tools patch,which did not work for me(missing quota.c file in patch?):(


Regards,

Tristan.



> 
> I've adressed Joel's comments, also node recovery is now fully working
> and I've fixed a few issues I found during my testing. So I'm currently
> not aware of any bugs. Please review, test, comment. Thanks.
> 
> 								Honza
