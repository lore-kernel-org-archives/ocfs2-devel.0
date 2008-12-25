From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Dec 2008 16:29:23 -0800
Subject: [Ocfs2-devel] [PATCH 23/56] ocfs2: Implementation of local and
	global quota file handling
In-Reply-To: <20081222161138.779cbffa.akpm@linux-foundation.org>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
	<1229982517-3455-24-git-send-email-mfasheh@suse.com>
	<20081222161138.779cbffa.akpm@linux-foundation.org>
Message-ID: <20081225002923.GA17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, joel.becker@oracle.com, jack@suse.cz

On Mon, Dec 22, 2008 at 04:11:38PM -0800, Andrew Morton wrote:
> > +	mlog_entry_void();
> > +
> > +	lvb = (struct ocfs2_qinfo_lvb *)ocfs2_dlm_lvb(&lockres->l_lksb);
> 
> Unneeded cast.

Yeah, there's quite a few of those in dlmglue.c actually. I'll add a patch
to fix them up.


> > +	if (lvb->lvb_version == OCFS2_QINFO_LVB_VERSION) {
> > +		info->dqi_bgrace = be32_to_cpu(lvb->lvb_bgrace);
> > +		info->dqi_igrace = be32_to_cpu(lvb->lvb_igrace);
> > +		oinfo->dqi_syncms = be32_to_cpu(lvb->lvb_syncms);
> > +		oinfo->dqi_gi.dqi_blocks = be32_to_cpu(lvb->lvb_blocks);
> > +		oinfo->dqi_gi.dqi_free_blk = be32_to_cpu(lvb->lvb_free_blk);
> > +		oinfo->dqi_gi.dqi_free_entry =
> > +					be32_to_cpu(lvb->lvb_free_entry);
> > +	} else {
> > +		bh = ocfs2_read_quota_block(oinfo->dqi_gqinode, 0, &status);
> > +		if (!bh) {
> > +			mlog_errno(status);
> > +			goto bail;
> > +		}
> > +		gdinfo = (struct ocfs2_global_disk_dqinfo *)
> > +					(bh->b_data + OCFS2_GLOBAL_INFO_OFF);
> > +		info->dqi_bgrace = le32_to_cpu(gdinfo->dqi_bgrace);
> > +		info->dqi_igrace = le32_to_cpu(gdinfo->dqi_igrace);
> > +		oinfo->dqi_syncms = le32_to_cpu(gdinfo->dqi_syncms);
> > +		oinfo->dqi_gi.dqi_blocks = le32_to_cpu(gdinfo->dqi_blocks);
> > +		oinfo->dqi_gi.dqi_free_blk = le32_to_cpu(gdinfo->dqi_free_blk);
> > +		oinfo->dqi_gi.dqi_free_entry =
> > +					le32_to_cpu(gdinfo->dqi_free_entry);
> > +		brelse(bh);
> 
> put_bh() is more efficient and modern, in the case where bh is known to
> not be NULL.

How about __brelse()? Won't we lose the ref counting check if we go straight
to put_bh()?


> > +/* Lock quota info, this function expects at least shared lock on the quota file
> > + * so that we can safely refresh quota info from disk. */
> > +int ocfs2_qinfo_lock(struct ocfs2_mem_dqinfo *oinfo, int ex)
> > +{
> > +	struct ocfs2_lock_res *lockres = &oinfo->dqi_gqlock;
> > +	struct ocfs2_super *osb = OCFS2_SB(oinfo->dqi_gi.dqi_sb);
> > +	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
> > +	int status = 0;
> > +
> > +	mlog_entry_void();
> > +
> > +	/* On RO devices, locking really isn't needed... */
> > +	if (ocfs2_is_hard_readonly(osb)) {
> > +		if (ex)
> > +			status = -EROFS;
> > +		goto bail;
> > +	}
> > +	if (ocfs2_mount_local(osb))
> > +		goto bail;
> 
> This is not an error case?

Nope, that's a short-circuit for the case where the file system is marked as
'local only' - this no cluster locking is ever needed.

> > +
> > +	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
> > +	if (status < 0) {
> > +		mlog_errno(status);
> > +		goto bail;
> > +	}
> > +	if (!ocfs2_should_refresh_lock_res(lockres))
> > +		goto bail;
> 
> ditto?

Another shortcut - the data which some locks protect wants to be
'refreshed', typically from lvb or disk. The lower level locking logic (heh,
try saying that 10 times fast ;) knows when this is required, and will mark
the lock appropriately. This is detected later with the above test and the
lock-specific data is refreshed.

I think eventually, we'll move some more of this stuff to the lower level,
probably using callbacks in the case of lock refresh.


> > +ssize_t ocfs2_quota_read(struct super_block *sb, int type, char *data,
> > +			 size_t len, loff_t off)
> > +{
> > +	struct ocfs2_mem_dqinfo *oinfo = sb_dqinfo(sb, type)->dqi_priv;
> > +	struct inode *gqinode = oinfo->dqi_gqinode;
> > +	loff_t i_size = i_size_read(gqinode);
> > +	int offset = off & (sb->s_blocksize - 1);
> > +	sector_t blk = off >> sb->s_blocksize_bits;
> > +	int err = 0;
> > +	struct buffer_head *bh;
> > +	size_t toread, tocopy;
> > +
> > +	if (off > i_size)
> > +		return 0;
> > +	if (off + len > i_size)
> > +		len = i_size - off;
> > +	toread = len;
> > +	while (toread > 0) {
> > +		tocopy = min((size_t)(sb->s_blocksize - offset), toread);
> 
> min_t is preferred.

Right, I'll fix that one up too.


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
> 
> does ocfs2 attempt to support CONFIG_LBD=n?

It should... What's the problem here?
	--Mark

--
Mark Fasheh
