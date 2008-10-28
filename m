From: tristan.ye <tristan.ye@oracle.com>
Date: Tue, 28 Oct 2008 19:23:07 +0800
Subject: [Ocfs2-devel] [PATCH 00/00] Implement quotas for OCFS2 (version
	2)
In-Reply-To: <1225159789.6555.24.camel@tristan-laptop.cn.oracle.com>
References: <12248859043309-git-send-email-jack@suse.cz>
	<1225098534.6525.43.camel@tristan-laptop.cn.oracle.com>
	<20081027112312.GA18903@duck.suse.cz>
	<1225159789.6555.24.camel@tristan-laptop.cn.oracle.com>
Message-ID: <1225192987.17596.20.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 2008-10-28 at 10:09 +0800, tristan.ye wrote:
> On Mon, 2008-10-27 at 12:23 +0100, Jan Kara wrote:
> > On Mon 27-10-08 17:08:54, tristan.ye wrote:
> > > On Sat, 2008-10-25 at 00:05 +0200, Jan Kara wrote:
> > > > Hello,
> > > > 
> > > > the following patch series implements quotas for OCFS2. The patch
> > > > series is based on:
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git linux-next
> > > 
> > > Jan,
> > > 
> > > Try with linux-next branch on mark's tree this time,still hit a failure
> > > at patch 25
> > > 
> > > [root at ocfs2-test5 linux-next]# patch
> > > -p1</kernel/quota-patches/quota-patch25
> > > patching file fs/ocfs2/Makefile
> > > Hunk #1 FAILED at 35.
> > > 1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/Makefile.rej
> > > patching file fs/ocfs2/cluster/masklog.h
> > > patching file fs/ocfs2/dir.c
> > > Hunk #1 FAILED at 82.
> > > 1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/dir.c.rej
> > > patching file fs/ocfs2/dlmglue.c
> > > Hunk #9 succeeded at 3490 (offset 5 lines).
> > > patching file fs/ocfs2/dlmglue.h
> > > patching file fs/ocfs2/file.c
> > > patching file fs/ocfs2/file.h
> > > patching file fs/ocfs2/inode.h
> > > Hunk #1 succeeded at 144 (offset 2 lines).
> > > patching file fs/ocfs2/ocfs2_fs.h
> > > patching file fs/ocfs2/ocfs2_lockid.h
> > > patching file fs/ocfs2/quota.h
> > > patching file fs/ocfs2/quota_global.c
> > > patching file fs/ocfs2/quota_local.c
> > > patching file fs/ocfs2/super.c
> > > Hunk #3 succeeded at 1077 (offset 1 line).
> > > Hunk #5 succeeded at 1218 (offset 1 line).
> > > 
> > > Anyway,i do succeeded to apply these patches with linus's latest
> > > mainline 2.6.27 master branch. the tools patch for mkfs also works:),
> >   Hmm, that's a bit strange. I've just rebased my set of patches on top of
> > linux-next branch in Mark's tree and I got two rejects but in a different
> > patch... Also my latest patch set probably wouldn't work against 2.6.27
> > because it's already based on xattr and acl changes which aren't in 2.6.27.
> > I'm attaching tarball of the patches just for reference.
> 
> I'm also hitting rejects by using the newly attached patch set on
> linux-next branch of mark's tree,
> 3 patches hit the reject failure,they were patch #5,#22 #23,following
> output will tell the detail,
> 
> ============message output when applying the patches==============
> patch
> -p1<../ocfs2-patches/0005-quota-Allow-to-separately-enable-quota-accounting-a.patch 
> patching file fs/dquot.c
> Hunk #1 succeeded at 489 (offset 2 lines).
> Hunk #3 succeeded at 594 (offset 2 lines).
> Hunk #5 succeeded at 1041 (offset 4 lines).
> Hunk #7 succeeded at 1116 (offset 4 lines).
> Hunk #9 succeeded at 1552 (offset 4 lines).
> Hunk #11 succeeded at 1584 (offset 4 lines).
> Hunk #13 succeeded at 1644 (offset 4 lines).
> Hunk #15 succeeded at 1670 (offset 4 lines).
> Hunk #17 succeeded at 1720 (offset 4 lines).
> Hunk #19 succeeded at 1785 (offset 4 lines).
> Hunk #20 FAILED at 1817.
> Hunk #22 succeeded at 1905 (offset 4 lines).
> Hunk #24 succeeded at 2061 (offset 4 lines).
> Hunk #26 succeeded at 2099 (offset 4 lines).
> 1 out of 27 hunks FAILED -- saving rejects to file fs/dquot.c.rej
> 
> 
> patch
> -p1<../ocfs2-patches/0022-ocfs2-Implementation-of-local-and-global-quota-file.patch 
> patching file fs/ocfs2/Makefile
> Hunk #1 FAILED at 35.
> 1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/Makefile.rej
> patching file fs/ocfs2/cluster/masklog.h
> patching file fs/ocfs2/dir.c
> Hunk #1 FAILED at 82.
> 1 out of 1 hunk FAILED -- saving rejects to file fs/ocfs2/dir.c.rej
> patching file fs/ocfs2/dlmglue.c
> Hunk #9 succeeded at 3490 (offset 5 lines).
> patching file fs/ocfs2/dlmglue.h
> patching file fs/ocfs2/file.c
> patching file fs/ocfs2/file.h
> patching file fs/ocfs2/inode.h
> Hunk #1 succeeded at 144 (offset 2 lines).
> patching file fs/ocfs2/ocfs2_fs.h
> Hunk #1 succeeded at 878 (offset -1 lines).
> patching file fs/ocfs2/ocfs2_lockid.h
> patching file fs/ocfs2/quota.h
> patching file fs/ocfs2/quota_global.c
> patching file fs/ocfs2/quota_local.c
> patching file fs/ocfs2/super.c
> Hunk #3 succeeded at 1077 (offset 1 line).
> Hunk #5 succeeded at 1218 (offset 1 line).
> 
> patch
> -p1<../ocfs2-patches/0023-ocfs2-Add-quota-calls-for-allocation-and-freeing-of.patch 
> patching file fs/ocfs2/alloc.c
> Hunk #2 succeeded at 6377 (offset 26 lines).
> Hunk #4 succeeded at 6712 (offset 26 lines).
> Hunk #6 succeeded at 6812 (offset 26 lines).
> patching file fs/ocfs2/aops.c
> Hunk #2 succeeded at 1756 (offset 5 lines).
> Hunk #4 succeeded at 1782 (offset 5 lines).
> patching file fs/ocfs2/dir.c
> Hunk #2 succeeded at 1183 (offset -34 lines).
> Hunk #4 succeeded at 1232 (offset -34 lines).
> Hunk #6 succeeded at 1387 (offset -34 lines).
> Hunk #8 succeeded at 1429 (offset -34 lines).
> patching file fs/ocfs2/file.c
> Hunk #4 succeeded at 589 (offset 1 line).
> Hunk #6 succeeded at 902 (offset 3 lines).
> Hunk #8 succeeded at 1038 (offset 3 lines).
> Hunk #9 FAILED at 1320.
> 1 out of 9 hunks FAILED -- saving rejects to file fs/ocfs2/file.c.rej
> patching file fs/ocfs2/inode.c
> Hunk #2 succeeded at 617 (offset -3 lines).
> Hunk #4 succeeded at 933 (offset -3 lines).
> patching file fs/ocfs2/journal.h
> patching file fs/ocfs2/namei.c
> Hunk #8 succeeded at 386 with fuzz 2 (offset 5 lines).
> Hunk #10 succeeded at 417 (offset 5 lines).
> Hunk #11 FAILED at 431.
> Hunk #13 succeeded at 482 (offset 5 lines).
> Hunk #14 FAILED at 520.
> Hunk #15 succeeded at 612 (offset -2 lines).
> Hunk #16 succeeded at 809 (offset 8 lines).
> Hunk #17 succeeded at 1212 (offset 5 lines).
> Hunk #18 succeeded at 1540 (offset 18 lines).
> Hunk #19 succeeded at 1584 (offset 5 lines).
> Hunk #20 succeeded at 1612 (offset 18 lines).
> Hunk #21 succeeded at 1623 (offset 5 lines).
> Hunk #22 succeeded at 1698 (offset 18 lines).
> Hunk #23 succeeded at 1705 (offset 8 lines).
> 2 out of 23 hunks FAILED -- saving rejects to file fs/ocfs2/namei.c.rej
> patching file fs/ocfs2/xattr.c
> Hunk #1 succeeded at 358 (offset 9 lines).
> Hunk #2 FAILED at 4267.
> 1 out of 2 hunks FAILED -- saving rejects to file fs/ocfs2/xattr.c.rej
> ==========3 patches(#5,#22,#23) hit reject failure=======
> 
> Due to above failure, i definitely hit a compiling error when building
> the krenel for testing.
> fs/dquot.c: In function ?vfs_quota_on_path?:
> fs/dquot.c:1894: error: implicit declaration of function
> ?vfs_quota_on_inode?
> make[1]: *** [fs/dquot.o] Error 1
> make: *** [fs] Error 2
> 
> Will you check on your environment? or you will tell me the exact env
> you use to make things comfortably successful?
Jan,

Sorry for making the noise again:)

I'm just curious about one thing, as you said we choose quotaon to
enforce the quota limitation on ocfs2 to keep the consistency with other
fs, and the quotaon finally call the quoctl with the cmd word
'Q_QUOTAON', here i found the quoctl() need a agrumnet to point to  the
path name of file containing the quotas for the filesystem,but
unfortunately these files were hidden from userspace on ocfs2. so this
quotactl call for turning on the quota will definitely fail, is that the
case?

Since the existing POSIX quota tools did not work  under ocfs2
currently, i've written a simple version of the quota tools(just
including getquota,setquotas and quotactl) by the help of quotactl()
API.  All of its binaries and src attached.

As what i said above, my version of quotaon(invoked by 'quotactl -o')
also did not work here ,and fortunately, we really do succeed to set/get
the quota for usr/group.
you can have a check in your env if you wish.

Thanks and regards,

Tristan.

> 
> Yesterday,i really succeeded with your first patch set(0-29 patches
> totally) on linus's mainline kernel 2.6.27, will it be OK for testing?
> 
> 
> 
> Thanks and regards,
> 
> Tristan.
> 
> 
> > 
> > > for current testing,seems all POSIX quota tools(including
> > > quotaon,quotaoff and setquota.) failed to be applied on ocfs2-quota?
> > > right? the failure may due to the fact that tools can not find 2 hidden
> > > quota files?
> >   Yes, tools should print some message that filesystem does not support
> > quotas or something like that.
> >  
> > > After mkfs with --fs-feature=usrquota,grpquota.... and also mount it
> > > with usrquota and grpquota options explicitly specified,seems still
> > > failed to enable the quota by quotaon even i did saw these options
> > > showed up in /etc/mtab. the errors was somewhat like i never specified
> > > the options when mounting,
> > > [root at ocfs2-test6 quota_examples-0.0.21]# quotaon -vugf /quota/
> > > quotaon: Mountpoint (or device) /quota not found.
> >   Well, the -f option is definitely wrong (that means turn quotas off).
> > Something like: quotaon -avug
> >   should do the work for you - it will find the filesystem in the /etc/mtab
> > automatically.
> > 
> > > When i check this quota-supported ocfs2 volume by debufs.ocfs2,do find
> > > the 2 quota files under system folder.so,ocfs2 defaultly generate the
> > > quota files without a quotacheck like extN did? so how can I
> > > refresh/check the files by force?should wait the fsck.ocfs2 to have it
> > > come true?
> >   Mkfs creates these two system files (and also node local system files
> > called aquota0001.user etc). For checking / fixing these files, you have
> > to wait for fsck.ocfs2 support. But I think you can test quite a lot even
> > without it - most of the bugs would not probably result in the corruption
> > of quota file anyway.
> > 
> > > Thus,for current testing, i should expect the quoctl POSXI api to do all
> > > things for me? since we can not do any test manually without the help of
> > > quota tools. am I understanding the things in a right way?
> >   Yes, quotactl() is the only interface you can use (it is used by quota-tools
> > as well).
> > 								Honza
-------------- next part --------------
A non-text attachment was scrubbed...
Name: myquota_tools.tgz
Type: application/x-compressed-tar
Size: 14427 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081028/1c6a6dcb/attachment-0001.bin 
