From: Dave Chinner <david@fromorbit.com>
Date: Thu, 22 Jan 2015 10:10:30 +1100
Subject: [Ocfs2-devel] [PATCH 0/17 v3] quota: Unify VFS and XFS quota
	interfaces
In-Reply-To: <20150121222320.GA30154@quack.suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<20150121213826.GL16510@dastard>
	<20150121222320.GA30154@quack.suse.cz>
Message-ID: <20150121231030.GK16552@dastard>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Wed, Jan 21, 2015 at 11:23:20PM +0100, Jan Kara wrote:
> On Thu 22-01-15 08:38:26, Dave Chinner wrote:
> > On Fri, Jan 16, 2015 at 01:47:34PM +0100, Jan Kara wrote:
> > >   Hello,
> > > 
> > >   this is another iteration of patches to unify VFS and XFS quota interfaces so
> > > that XFS quotactls work for filesystems with VFS quotas and vice versa.  This
> > > is useful so that userspace doesn't have to care that much about which
> > > filesystem it is using at least when using basic quota functionality. In
> > > particular we should be able to reuse project quota tests in xfstests for ext4.
> > > 
> > > The patches are based on quota cleanup series [1] and XFS cleanup series [2]
> > > I've sent previously and based on 3.19-rc4 + for-next branch of XFS tree.  I
> > > could further split this series into per-quotactl series but frankly I don't
> > > think it will help reviewers in any way (the patches in the current series are
> > > already ordered by quotactl).
> > 
> > Hi Jan,
> > 
> > Do you have a this series in a git tree somewhere so it's easy to
> > merge and test?
>   I've pushed out the series to:
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git quota_interface
> 
>   BTW, I've already implemented suggestions by Christoph so it's not
> exactly what was sent to the list (but very close). I'd also welcome your
> opinion on usage of BBTOB() and BTOBB() macros in fs/quota/quota.c - to be
> able to use them I have to move them out of fs/xfs/libxfs/xfs_fs.h to
> somewhere in include/. Christoph doesn't like it much and would prefer
> quota code just opencoded these macros. I don't really care but you two
> should agree :)

fs/xfs/libxfs/xfs_fs.h is the XFS userspace API definition file and
is shared with userspace (via xfsprogs, ends up at
/usr/include/xfs/xfs_fs.h), and BBTOB() and BTOBB() are part of that
API, hence they need to stay there.

ISTR that you only need them in one place in the quota translation
layer, so Christoph is right - it's probably best to simply open
code them with an appropriate comment somewhere in the file to
explain why....

Cheers,

Dave.

-- 
Dave Chinner
david at fromorbit.com
