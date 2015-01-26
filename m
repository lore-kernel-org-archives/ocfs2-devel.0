From: Jan Kara <jack@suse.cz>
Date: Mon, 26 Jan 2015 15:34:17 +0100
Subject: [Ocfs2-devel] [PATCH 00/16 v4] quota: Unify VFS and XFS quota
	interfaces
Message-ID: <1422282873-3381-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

  Hello,

  this is another iteration of patches to unify VFS and XFS quota interfaces so
that XFS quotactls work for filesystems with VFS quotas and vice versa.  This
is useful so that userspace doesn't have to care that much about which
filesystem it is using at least when using basic quota functionality. In
particular we should be able to reuse project quota tests in xfstests for ext4.

The patches are based on top of 'for_next' branch of my tree [1] which already
contains quota cleanup series [2] and XFS cleanup series [3] I've sent
previously. The patch series can also be pulled from 'quota_interface' branch
of my tree.

Since the previous version I have addressed all Christoph's comments (dropped
patch for Q_XQUOTASYNC quotactl, moved some code around) and also put the fix
for Q_GETQUOTA vs Q_XGETQUOTA breakage at the beginning of the series and
added CC to stable for it since some users have hit the problem in practice.

The patch series got already reviewed by Christoph (thanks!) upto unification
of Q_GETXSTAT[EV] with Q_GETINFO so if noone objects in a few days, I'll push
the reviewed part of the series to my tree in the second half of this week (so
that it gets some exposure in linux-next before the merge window).

Review of the remaining parts is welcome!

								Honza

[1] git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git
[2] http://www.spinics.net/lists/linux-fsdevel/msg81903.html
[3] http://www.spinics.net/lists/xfs/msg31389.html
