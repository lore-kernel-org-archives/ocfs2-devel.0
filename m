From: Jan Kara <jack@suse.cz>
Date: Tue, 7 Oct 2014 21:29:35 +0200
Subject: [Ocfs2-devel] [PATCH 03/12] xfs: Set allowed quota types
In-Reply-To: <20141006203028.GB2301@dastard>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-4-git-send-email-jack@suse.cz>
	<20141006203028.GB2301@dastard>
Message-ID: <20141007192935.GF30038@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

On Tue 07-10-14 07:30:28, Dave Chinner wrote:
> On Wed, Oct 01, 2014 at 09:31:25PM +0200, Jan Kara wrote:
> > We support user, group, and project quotas. Tell VFS about it.
> > 
> > CC: xfs at oss.sgi.com
> > CC: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_super.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index b194652033cd..b32e998e8cbc 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1419,6 +1419,8 @@ xfs_fs_fill_super(
> >  	sb->s_export_op = &xfs_export_operations;
> >  #ifdef CONFIG_XFS_QUOTA
> >  	sb->s_qcop = &xfs_quotactl_operations;
> > +	sb->s_dquot.allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA) |
> > +				    (1 << PRJQUOTA);
> 
> Would it be better to define masks for these rather than open
> coding these shifts everywhere?
  I can do that. Any suggestion for a name? I was thinking about it for a
while and couldn't come up with anything satisfactory...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
