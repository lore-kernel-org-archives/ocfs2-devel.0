From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 11 Jul 2008 16:52:00 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix race between mount
	and	recovery
In-Reply-To: <1215818841-4097-3-git-send-email-sunil.mushran@oracle.com>
References: <1215818841-4097-1-git-send-email-sunil.mushran@oracle.com>
	<1215818841-4097-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080711235200.GE22577@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 11, 2008 at 04:27:21PM -0700, Sunil Mushran wrote:
> +	if (replayed)
> +		le32_add_cpu(&(fe->id1.journal1.ij_recovery_generation), 1);

	You're doing this a lot, and it's a bunch to read.  Can we have:

static void ocfs2_bump_recovery_generation(struct ocfs2_dinode *di)
{
	le32_add_cpu(&(di->id1.journal1.ij_recovery_generation), 1);
}

static u32 ocfs2_get_recovery_generation(struct ocfs2_dinode *di)
{
	return le32_to_cpu(di->id1.journal1.ij_recovery_generation);
}

I just think it'll read better.

> +static int ocfs2_read_journal_inode(struct ocfs2_super *osb,
> +				    int slot_num,
> +				    struct buffer_head **bh,
> +				    struct inode **ret_inode)

	Perhaps you want to make ret_inode optional?  It seems to be
there are a couple paths that are just iput()ing it.  So, you'd do:

> +{
> +	int status = -EACCES;
> +	struct inode *inode = NULL;
> +
> +	BUG_ON(slot_num >= osb->max_slots);
> +
- +	*ret_inode = NULL;
- +
> +	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
> +					    slot_num);
> +	if (!inode || is_bad_inode(inode)) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +	SET_INODE_JOURNAL(inode);
> +
> +	status = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, bh, 0, inode);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	status = 0;
> +
> +bail:
> +	if (inode) {
- +		if (status)
+ +		if (status || !ret_inode)
> +			iput(inode);
> +		else
> +			*ret_inode = inode;
> +	}
> +	return status;
> +}

<snip>

>  	flags = le32_to_cpu(fe->id1.journal1.ij_flags);
> +	slot_reco_gen = le32_to_cpu(fe->id1.journal1.ij_recovery_generation);

Wouldn't this be so much nicer?

+	slot_reco_gen = ocfs2_get_recovery_generation(fe);

> @@ -1190,14 +1263,35 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
>  {
>  	int status, i, node_num;
>  	struct ocfs2_slot_info *si = osb->slot_info;
> +	struct buffer_head *bh = NULL;
> +	struct ocfs2_dinode *fe;

	If you are adding new dinodes, can we call them 'di' instead of
'fe'?

>  	spin_lock(&si->si_lock);
>  	for(i = 0; i < si->si_num_slots; i++) {
> +		/* Read journal inode to get the recovery generation */
> +		status = ocfs2_read_journal_inode(osb, i, &bh, &inode);
> +		if (status) {
> +			mlog_errno(status);
> +			goto bail;
> +		}
> +		fe = (struct ocfs2_dinode *)bh->b_data;
> +		osb->slot_recovery_generation[i] =
> +			le32_to_cpu(fe->id1.journal1.ij_recovery_generation);
> +		brelse(bh);
> +		iput(inode);

	Here's a place you'd want to pass NULL instead of &inode to
ocfs2_read_journal_inode();

Joel

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
