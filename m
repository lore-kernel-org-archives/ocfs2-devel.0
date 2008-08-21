From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 21 Aug 2008 16:25:40 -0700
Subject: [Ocfs2-devel] [PATCH 09/10] ocfs2: Add an insertion check
	to	ocfs2_extent_tree_operations.
In-Reply-To: <20080821225238.GS4563@wotan.suse.de>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-10-git-send-email-joel.becker@oracle.com>
	<20080821225238.GS4563@wotan.suse.de>
Message-ID: <20080821232540.GK14096@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 03:52:39PM -0700, Mark Fasheh wrote:
> On Wed, Aug 20, 2008 at 07:48:24PM -0700, Joel Becker wrote:
> > The op eo_sanity_check() was really a check on remove_right_path().
> > Let's call it eo_remove_check().  Let's add an eo_insert_check() that
> > can be called from ocfs2_insert_extent().
> > 
> > Let's have the wrapper calls ocfs2_et_insert_check() and
> > ocfs2_et_remove_check() ignore NULL ops.  That way we don't have to
> > provide useless operations for xattr types.

<snip>

> > @@ -4406,26 +4430,22 @@ static int ocfs2_insert_extent(struct ocfs2_super *osb,
> >  	int uninitialized_var(free_records);
> >  	struct buffer_head *last_eb_bh = NULL;
> >  	struct ocfs2_insert_type insert = {0, };
> > -	struct ocfs2_extent_rec rec;
> > -
> > -	BUG_ON(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
> > +	struct ocfs2_extent_rec rec = {
> > +		.e_cpos = cpu_to_le32(cpos),
> > +		.e_blkno = cpu_to_le64(start_blk),
> > +	};
> >  
> >  	mlog(0, "add %u clusters at position %u to inode %llu\n",
> >  	     new_clusters, cpos, (unsigned long long)OCFS2_I(inode)->ip_blkno);
> >  
> > -	mlog_bug_on_msg(!ocfs2_sparse_alloc(osb) &&
> > -			(OCFS2_I(inode)->ip_clusters != cpos),
> > -			"Device %s, asking for sparse allocation: inode %llu, "
> > -			"cpos %u, clusters %u\n",
> > -			osb->dev_str,
> > -			(unsigned long long)OCFS2_I(inode)->ip_blkno, cpos,
> > -			OCFS2_I(inode)->ip_clusters);
> > -
> > -	memset(&rec, 0, sizeof(rec));
> > -	rec.e_cpos = cpu_to_le32(cpos);
> > -	rec.e_blkno = cpu_to_le64(start_blk);
> > +	/* gcc doesn't understand anonymous unions in the initializer */
> >  	rec.e_leaf_clusters = cpu_to_le16(new_clusters);
> >  	rec.e_flags = flags;
> 
> Is there a reason why you changed the way we initialize "rec" for this
> patch? I guess the end result is the same - specifically, I want to be 100%
> certain that rec.e_reserved1 gets zero'd. Still though, I think the flow we
> had before was better.

	Well, the naked memset() is ugly (IMHO) when the initializer
works (an initializer ensures that all non-initialized fields are zero).
However, it didn't work quite like I expected, since gcc couldn't handle
the anonymous union in the initializer.  I'll revert it back to the old
way.

Joel

-- 

Life's Little Instruction Book #109

	"Know how to drive a stick shift."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
