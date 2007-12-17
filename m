From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 17 14:10:37 2007
Subject: [Ocfs2-devel] [PATCH 3/4] Add group extend for online
	resize.take 3
In-Reply-To: <20071214075551.GA26707@tma-pc1.cn.oracle.com>
References: <20071214073744.GA26638@tma-pc1.cn.oracle.com>
	<20071214075551.GA26707@tma-pc1.cn.oracle.com>
Message-ID: <20071217220855.GD11448@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 14, 2007 at 03:55:51PM +0800, tao.ma wrote:
...

> +static int ocfs2_update_last_group_and_inode(handle_t *handle,
> +					     struct inode *bm_inode,
> +					     struct buffer_head *bm_bh,
> +					     struct buffer_head *group_bh,
> +					     u32 first_new_cluster,
> +					     int new_clusters)
> +{
> +	int ret = 0;
> +	struct ocfs2_super *osb = OCFS2_SB(bm_inode->i_sb);
> +	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bm_bh->b_data;
> +	struct ocfs2_chain_list *cl = &fe->id2.i_chain;
> +	struct ocfs2_chain_rec *cr;
> +	struct ocfs2_group_desc *group;
> +	u16 chain, num_bits, backups = 0;
> +	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
> +	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
> +
> +	mlog_entry("(new_clusters=%d, first_new_cluster = %u)\n",
> +		   new_clusters, first_new_cluster);
> +
> +	ret = ocfs2_journal_access(handle, bm_inode, group_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	group = (struct ocfs2_group_desc *) group_bh->b_data;
> +
> +	/* update the group first. */
> +	num_bits = new_clusters * cl_bpc;
> +	le16_add_cpu(&group->bg_bits, num_bits);
> +	le16_add_cpu(&group->bg_free_bits_count, num_bits);
> +
> +	/*
> +	 * check whether there are some new backup superblocks exist in
> +	 * this group and update the group bitmap accordingly.
> +	 */
> +	if (OCFS2_HAS_COMPAT_FEATURE(osb->sb,
> +				     OCFS2_FEATURE_COMPAT_BACKUP_SB)) {
> +		backups = ocfs2_calc_new_backup_super(bm_inode,
> +						     group,
> +						     new_clusters,
> +						     first_new_cluster,
> +						     cl_cpg, 1);
> +		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
> +	}
> +
> +	ret = ocfs2_journal_dirty(handle, group_bh);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_rollback;
> +	}
> +
> +	/* update the inode accordingly. */
> +	ret = ocfs2_journal_access(handle, bm_inode, bm_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_rollback;
> +	}
> +
> +	chain = le16_to_cpu(group->bg_chain);
> +	cr = (&cl->cl_recs[chain]);
> +	le32_add_cpu(&cr->c_total, num_bits);
> +	le32_add_cpu(&cr->c_free, num_bits);
> +	le32_add_cpu(&fe->id1.bitmap1.i_total, num_bits);
> +	le32_add_cpu(&fe->i_clusters, new_clusters);
> +
> +	if (backups) {
> +		le32_add_cpu(&cr->c_free, -1 * backups);
> +		le32_add_cpu(&fe->id1.bitmap1.i_used, backups);
> +	}
> +
> +	ocfs2_journal_dirty(handle, bm_bh);
> +
> +	spin_lock(&OCFS2_I(bm_inode)->ip_lock);
> +	OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> +	le64_add_cpu(&fe->i_size, new_clusters << osb->s_clustersize_bits);
> +	spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
> +	i_size_write(bm_inode, le64_to_cpu(fe->i_size));

Move the ocfs2_journal_dirty() past this block to make the disk changes easier to
track.


Ok, the rest of this looks reasonable. Where are the userspace patches by
the way? Since this is fairly tightly coupled to ocfs2-tools, I was hoping
to get a look at those before merging this into ocfs2.git.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
