From: Jan Kara <jack@suse.cz>
Date: Mon, 27 Oct 2008 12:23:51 +0100
Subject: [Ocfs2-devel] [PATCH 00/00] Implement quotas for OCFS2 (version
	2)
In-Reply-To: <20081027112312.GA18903@duck.suse.cz>
References: <12248859043309-git-send-email-jack@suse.cz>
	<1225098534.6525.43.camel@tristan-laptop.cn.oracle.com>
	<20081027112312.GA18903@duck.suse.cz>
Message-ID: <20081027112351.GB18903@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Sorry, forgot to attach patches...

							Honza

On Mon 27-10-08 12:23:12, Jan Kara wrote:
> On Mon 27-10-08 17:08:54, tristan.ye wrote:
> > On Sat, 2008-10-25 at 00:05 +0200, Jan Kara wrote:
> > > Hello,
> > > 
> > > the following patch series implements quotas for OCFS2. The patch
> > > series is based on:
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git linux-next
> > 
> > Jan,
> > 
> > Try with linux-next branch on mark's tree this time,still hit a failure
> > at patch 25
> > 
> > [root at ocfs2-test5 linux-next]# patch
> > -p1</kernel/quota-patches/quota-patch25
> > patching file fs/ocfs2/Makefile
> > Hunk #1 FAILED at 35.
> > 1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/Makefile.rej
> > patching file fs/ocfs2/cluster/masklog.h
> > patching file fs/ocfs2/dir.c
> > Hunk #1 FAILED at 82.
> > 1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/dir.c.rej
> > patching file fs/ocfs2/dlmglue.c
> > Hunk #9 succeeded at 3490 (offset 5 lines).
> > patching file fs/ocfs2/dlmglue.h
> > patching file fs/ocfs2/file.c
> > patching file fs/ocfs2/file.h
> > patching file fs/ocfs2/inode.h
> > Hunk #1 succeeded at 144 (offset 2 lines).
> > patching file fs/ocfs2/ocfs2_fs.h
> > patching file fs/ocfs2/ocfs2_lockid.h
> > patching file fs/ocfs2/quota.h
> > patching file fs/ocfs2/quota_global.c
> > patching file fs/ocfs2/quota_local.c
> > patching file fs/ocfs2/super.c
> > Hunk #3 succeeded at 1077 (offset 1 line).
> > Hunk #5 succeeded at 1218 (offset 1 line).
> > 
> > Anyway,i do succeeded to apply these patches with linus's latest
> > mainline 2.6.27 master branch. the tools patch for mkfs also works:),
>   Hmm, that's a bit strange. I've just rebased my set of patches on top of
> linux-next branch in Mark's tree and I got two rejects but in a different
> patch... Also my latest patch set probably wouldn't work against 2.6.27
> because it's already based on xattr and acl changes which aren't in 2.6.27.
> I'm attaching tarball of the patches just for reference.
> 
> > for current testing,seems all POSIX quota tools(including
> > quotaon,quotaoff and setquota.) failed to be applied on ocfs2-quota?
> > right? the failure may due to the fact that tools can not find 2 hidden
> > quota files?
>   Yes, tools should print some message that filesystem does not support
> quotas or something like that.
>  
> > After mkfs with --fs-feature=usrquota,grpquota.... and also mount it
> > with usrquota and grpquota options explicitly specified,seems still
> > failed to enable the quota by quotaon even i did saw these options
> > showed up in /etc/mtab. the errors was somewhat like i never specified
> > the options when mounting,
> > [root at ocfs2-test6 quota_examples-0.0.21]# quotaon -vugf /quota/
> > quotaon: Mountpoint (or device) /quota not found.
>   Well, the -f option is definitely wrong (that means turn quotas off).
> Something like: quotaon -avug
>   should do the work for you - it will find the filesystem in the /etc/mtab
> automatically.
> 
> > When i check this quota-supported ocfs2 volume by debufs.ocfs2,do find
> > the 2 quota files under system folder.so,ocfs2 defaultly generate the
> > quota files without a quotacheck like extN did? so how can I
> > refresh/check the files by force?should wait the fsck.ocfs2 to have it
> > come true?
>   Mkfs creates these two system files (and also node local system files
> called aquota0001.user etc). For checking / fixing these files, you have
> to wait for fsck.ocfs2 support. But I think you can test quite a lot even
> without it - most of the bugs would not probably result in the corruption
> of quota file anyway.
> 
> > Thus,for current testing, i should expect the quoctl POSXI api to do all
> > things for me? since we can not do any test manually without the help of
> > quota tools. am I understanding the things in a right way?
>   Yes, quotactl() is the only interface you can use (it is used by quota-tools
> as well).
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-patches.tar.gz
Type: application/x-compressed-tar
Size: 67500 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081027/4c9f59cc/attachment-0001.bin 
