From: Jan Kara <jack@suse.cz>
Date: Thu, 18 Dec 2014 16:37:14 +0100
Subject: [Ocfs2-devel] [PATCH 0/25 RFC v2] quota: Unify VFS and XFS quota
	interfaces
Message-ID: <1418917059-23870-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

  Hello,

  this is the second attempt to unify VFS and XFS quota interfaces so that XFS
quotactls work for filesystems with VFS quotas and vice versa.  This is useful
so that userspace doesn't have to care that much about which filesystem it is
using at least when using basic quota functionality. In particular we should be
able to reuse project quota tests in xfstests for ext4.

In this patch set I unify quotaon / quotaoff handling (Q_QUOTAON, Q_QUOTAOFF,
Q_XQUOTAON, Q_XQUOTAOFF calls), fix some bugs in the Q_XGETQUOTA, Q_XSETQLIM,
Q_GETQUOTA, Q_SETQUOTA calls done by Christoph some time ago, unify
Q_GETXSTATE, Q_GETXSTATV with Q_GETINFO, and also wire up Q_SETINFO to work
with XFS (and Q_XSETQLIM for id 0 to modify time limits for VFS quotas).
So after these patches xfs_quota can manipulate quotas for ext4 filesystem and
similarly quota-tools can be used to manipulate quotas for xfs filesystem.

I have also verified that xfstests pass fine both for xfs and ext4 so
hopefully I didn't introduce any regression in the current functionality (I
also did a couple of manual checks for timer setting etc).

All the comments to the first version of the series are hopefully addressed,
except for Dave's request to reduce number of copying of dquot information -
I have benchmarked that reducing number of copies from 3 to 2 brings just 2%
improvement in speed in my test setup and getting quota information isn't IMHO
so performance critical that it would be worth the complications of the code.

Patches are against Linus' tree as of today - I know XFS tree may have some
conflicting changes (I think Dave even picked up some XFS patches from the
beginning of the series) but I wanted the patch series to be self-contained.

Comments are welcome. I would like to merge the patches via my tree in the
next merge window but before I do that I'd like some review...

								Honza
