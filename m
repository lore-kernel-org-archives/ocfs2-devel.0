From: tristan.ye <tristan.ye@oracle.com>
Date: Mon, 27 Oct 2008 17:08:54 +0800
Subject: [Ocfs2-devel] [PATCH 00/00] Implement quotas for OCFS2 (version
	2)
In-Reply-To: <12248859043309-git-send-email-jack@suse.cz>
References: yes  <12248859043309-git-send-email-jack@suse.cz>
Message-ID: <1225098534.6525.43.camel@tristan-laptop.cn.oracle.com>
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

Try with linux-next branch on mark's tree this time,still hit a failure
at patch 25

[root at ocfs2-test5 linux-next]# patch
-p1</kernel/quota-patches/quota-patch25
patching file fs/ocfs2/Makefile
Hunk #1 FAILED at 35.
1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/Makefile.rej
patching file fs/ocfs2/cluster/masklog.h
patching file fs/ocfs2/dir.c
Hunk #1 FAILED at 82.
1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/dir.c.rej
patching file fs/ocfs2/dlmglue.c
Hunk #9 succeeded at 3490 (offset 5 lines).
patching file fs/ocfs2/dlmglue.h
patching file fs/ocfs2/file.c
patching file fs/ocfs2/file.h
patching file fs/ocfs2/inode.h
Hunk #1 succeeded at 144 (offset 2 lines).
patching file fs/ocfs2/ocfs2_fs.h
patching file fs/ocfs2/ocfs2_lockid.h
patching file fs/ocfs2/quota.h
patching file fs/ocfs2/quota_global.c
patching file fs/ocfs2/quota_local.c
patching file fs/ocfs2/super.c
Hunk #3 succeeded at 1077 (offset 1 line).
Hunk #5 succeeded at 1218 (offset 1 line).

Anyway,i do succeeded to apply these patches with linus's latest
mainline 2.6.27 master branch. the tools patch for mkfs also works:),
for current testing,seems all POSIX quota tools(including
quotaon,quotaoff and setquota.) failed to be applied on ocfs2-quota?
right? the failure may due to the fact that tools can not find 2 hidden
quota files?

After mkfs with --fs-feature=usrquota,grpquota.... and also mount it
with usrquota and grpquota options explicitly specified,seems still
failed to enable the quota by quotaon even i did saw these options
showed up in /etc/mtab. the errors was somewhat like i never specified
the options when mounting,
[root@ocfs2-test6 quota_examples-0.0.21]# quotaon -vugf /quota/
quotaon: Mountpoint (or device) /quota not found.

When i check this quota-supported ocfs2 volume by debufs.ocfs2,do find
the 2 quota files under system folder.so,ocfs2 defaultly generate the
quota files without a quotacheck like extN did? so how can I
refresh/check the files by force?should wait the fsck.ocfs2 to have it
come true?

Thus,for current testing, i should expect the quoctl POSXI api to do all
things for me? since we can not do any test manually without the help of
quota tools. am I understanding the things in a right way?

Regards,

Tristan.

> 
> I've adressed Joel's comments, also node recovery is now fully working
> and I've fixed a few issues I found during my testing. So I'm currently
> not aware of any bugs. Please review, test, comment. Thanks.
> 
> 								Honza
