From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Nov 2008 15:53:15 +0100
Subject: [Ocfs2-devel] [PATCH 25/29] ocfs2: Implementation of local and
	global quota	file handling
In-Reply-To: <20081105224920.GW15154@wotan.suse.de>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861041077-git-send-email-jack@suse.cz>
	<20081105224920.GW15154@wotan.suse.de>
Message-ID: <20081120145315.GC20118@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi Mark!

  Thanks for the review. Your comments which aren't deleted has been just
silently implemented :).

> > +static void ocfs2_global_mem2diskdqb(void *dp, struct dquot *dquot)
> > +{
> > +	struct ocfs2_global_disk_dqblk *d = dp;
> > +	struct mem_dqblk *m = &dquot->dq_dqb;
> > +
> > +	d->dqb_id = cpu_to_le32(dquot->dq_id);
> > +	d->dqb_use_count = cpu_to_le32(OCFS2_DQUOT(dquot)->dq_use_count);
> > +	d->dqb_ihardlimit = cpu_to_le64(m->dqb_ihardlimit);
> > +	d->dqb_isoftlimit = cpu_to_le64(m->dqb_isoftlimit);
> > +	d->dqb_curinodes = cpu_to_le64(m->dqb_curinodes);
> > +	d->dqb_bhardlimit = cpu_to_le64(m->dqb_bhardlimit);
> > +	d->dqb_bsoftlimit = cpu_to_le64(m->dqb_bsoftlimit);
> > +	d->dqb_curspace = cpu_to_le64(m->dqb_curspace);
> > +	d->dqb_btime = cpu_to_le64(m->dqb_btime);
> > +	d->dqb_itime = cpu_to_le64(m->dqb_itime);
> > +	d->dqb_pad1 = d->dqb_pad2 = 0;
> 
> Just to be clear - do we definitely want to reset dqb_pad1 and dqb_pad2
> every time the header is written? This means that a future version of the
> quota code can't put values there without having them overwritten by nodes
> which don't understand the new fields...
  OK, done. Since the block is zeroed-out before it's reused, it's fine to
not zero padding fields. OTOH I suspect that we'll have to require all
nodes to understand new meaning of these fields when we start using them
anyway. The only advantage is we will not have to change disk layout.

> > +/* Write to quotafile (we know the transaction is already started and has
> > + * enough credits) */
> > +ssize_t ocfs2_quota_write(struct super_block *sb, int type,
> > +			  const char *data, size_t len, loff_t off)
> > +{
> > +	struct mem_dqinfo *info = sb_dqinfo(sb, type);
> > +	struct ocfs2_mem_dqinfo *oinfo = info->dqi_priv;
> > +	struct inode *gqinode = oinfo->dqi_gqinode;
> > +	int offset = off & (sb->s_blocksize - 1);
> > +	sector_t blk = off >> sb->s_blocksize_bits;
> > +	int err = 0;
> > +	struct buffer_head *bh;
> > +	handle_t *handle = journal_current_handle();
> > +	size_t tocopy, towrite = len;
> > +
> > +	if (!handle) {
> > +		mlog(ML_ERROR, "Quota write (off=%llu, len=%llu) cancelled "
> > +		     "because transaction was not started.\n",
> > +		     (unsigned long long)off, (unsigned long long)len);
> > +		return -EIO;
> > +	}
> > +	mutex_lock_nested(&gqinode->i_mutex, I_MUTEX_QUOTA);
> > +	if (gqinode->i_size < off + len) {
> > +		down_write(&OCFS2_I(gqinode)->ip_alloc_sem);
> > +		err = ocfs2_extend_no_holes(gqinode, off + len, off);
> > +		up_write(&OCFS2_I(gqinode)->ip_alloc_sem);
> > +		if (err < 0)
> > +			goto out;
> > +		err = ocfs2_simple_size_update(gqinode,
> > +					       oinfo->dqi_gqi_bh,
> > +					       off + len);
> > +		if (err < 0)
> > +			goto out;
> 
> Is it safe if we crash / error here, after the size has been extended but
> before we've written into the newly allocated blocks? In particular, could
> we wind up reading those blocks later and wrongly interpreting whatever data
> happens to be there? Hmm ok, I guess ocfs2_zero_extend() from
> ocfs2_extend_no_holes() fixes that for you, but it's using the page cache.
> Does that interact reasonably with what we're doing below?
  It should work fine. I actually don't use ocfs2_zero_extend() (note that
I pass 'off' to ocfs2_extend_no_holes() as the third parameter). But when
generic quota code decides to extend the file, it checks whether the write
succeeded and if not, it just internally does not increase it's notion of
quotafile size.

> > +	}
> > +	WARN_ON(off >> sb->s_blocksize_bits != \
> > +		(off + len) >> sb->s_blocksize_bits);
> > +	WARN_ON(((off + len) & ((1 << sb->s_blocksize_bits) - 1)) >
> > +		sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE);
> > +	for (towrite = len; towrite > 0; towrite -= tocopy) {
> > +		tocopy = min(towrite, (size_t)(sb->s_blocksize - offset));
> > +		bh = ocfs2_read_quota_block(gqinode, blk, &err);
> > +		if (!bh) {
> > +			mlog_errno(err);
> > +			return err;
> > +		}
> > +		err = ocfs2_journal_access(handle, gqinode, bh,
> > +						OCFS2_JOURNAL_ACCESS_WRITE);
> > +		if (err < 0) {
> > +			brelse(bh);
> > +			goto out;
> > +		}
> 
> We can optimize away the disk read if the block is newly allocated. There's
> no need to read it off disk, so we can just sb_getblk() it. Likewise, you'd
> want to use OCFS2_JOURNAL_ACCESS_CREATE for those. How often does the quota
> file get extended though? If it's sufficiently rare, we could save this for
> later. Otherwise, it's probably worth the effort imho.
  Actually, extending quota file is really rare operation - happens only
once per 20 new users of the cluster :). But your comment got me an idea,
that we can save read in most rewrite cases because upper level quota code
provides us with a complete content of the block. So I've rewritten the
function to optimize this case. But please check whether the function is
right when I submit next version of patches.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
