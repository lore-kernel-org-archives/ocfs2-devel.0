From: Jan Kara <jack@suse.cz>
Date: Tue, 20 Jan 2015 18:33:07 +0100
Subject: [Ocfs2-devel] [PATCH 12/17] xfs: Convert to using ->get_state
	callback
In-Reply-To: <20150119093810.GA16484@infradead.org>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-13-git-send-email-jack@suse.cz>
	<20150119093810.GA16484@infradead.org>
Message-ID: <20150120173307.GH3648@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Mon 19-01-15 01:38:10, Christoph Hellwig wrote:
> > +static void xfs_qm_fill_state(struct qc_type_state *tstate,
> 
> Normal xfs style would be to keep the "static void " on a separate line,
> as well as the arguments, e.g.
  OK, will change it to conform to the XFS coding style.

> static void
> xfs_qm_fill_state(
> 	struct qc_type_state	*tstate,
> 
> >
> > +			      struct xfs_mount *mp,
> > +			      struct xfs_inode *ip,
> > +			      xfs_ino_t ino)
> 
> No need to pass mp, as it can be derived as ip->i_mount.
  Good point.

> Btw, I think this code should move into xfs_quotaops.c now
> that it ties into the Linux quota interface, and xfs_qm_scall_getstate
> should be folded into xfs_fs_get_quota_state.
  OK, will do.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
