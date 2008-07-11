From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 10 Jul 2008 17:36:42 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix race between mount
	and	recovery
In-Reply-To: <1215731871-17351-3-git-send-email-sunil.mushran@oracle.com>
References: <1215731871-17351-1-git-send-email-sunil.mushran@oracle.com>
	<1215731871-17351-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080711003642.GH11809@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 10, 2008 at 04:17:51PM -0700, Sunil Mushran wrote:
> As the fs recovery is asynchronous, there is a small chance that another
> node count mount (and thus recover) the slot before the recovery thread

  node can mount 

> -int ocfs2_journal_load(struct ocfs2_journal *journal, int local)
> +int ocfs2_journal_load(struct ocfs2_journal *journal, int local, int replay)

	I'd call it 'replayed' here, just like in mark_dirty, because
it's a status (I already replayed it).

> +static int ocfs2_read_journal_recogen(struct ocfs2_super *osb,
> +				      int slot_num,
> +				      u32 *slot_reco_gen,
> +				      struct inode **ret_in)

	I don't like this name.  I keep wanting:

  static int ocfs2_read_journal_inode(*osb, slot_num, **ret_in, *reco_gen);

Which could also be used in check_journal_nolocks() in place of the
get_system_file_inode() call.  Heck, you could use it as the common call
for loading the journal inode, passing NULL for the reco_gen when
unwarranted.
	Basically, you are creating two ways to load the journal inode
here, and I wonder if we could just make it a new single method.

>  /* Does the actual journal replay and marks the journal inode as
>   * clean. Will only replay if the journal inode is marked dirty. */
>  static int ocfs2_replay_journal(struct ocfs2_super *osb,
>  				int node_num,
> -				int slot_num)
> +				int slot_num,
> +				int *busy)

	I think we want to use -EBUSY instead of *busy - it's in line
with the rest of the code, and it's perfectly logical.

Joel
>  {
>  	int status;
>  	int got_lock = 0;
> @@ -963,22 +1012,33 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
>  	struct ocfs2_dinode *fe;
>  	journal_t *journal = NULL;
>  	struct buffer_head *bh = NULL;
> +	u32 recogen;
>  
> -	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
> -					    slot_num);
> -	if (inode == NULL) {
> -		status = -EACCES;
> +	*busy = 0;
> +
> +	status = ocfs2_read_journal_recogen(osb, slot_num, &recogen, &inode);
> +	if (status) {
>  		mlog_errno(status);
>  		goto done;
>  	}
> -	if (is_bad_inode(inode)) {
> -		status = -EACCES;
> -		iput(inode);
> -		inode = NULL;
> -		mlog_errno(status);
> +
> +	/*
> +	 * As the fs recovery is asynchronous, there is a small chance that another
> +	 * node mounted (and recovered) the slot before the recovery thread could
> +	 * get the lock. To handle that, we dirty read the journal inode for that
> +	 * slot to get the recovery generation. If it is different than what we
> +	 * expected, the slot has been recovered. If not, it needs recovery.
> +	 */
> +	if (osb->slot_reco_generation[slot_num] != recogen) {
> +		mlog(0, "Slot %u already recovered (old/new=%u/%u)\n", slot_num,
> +		     osb->slot_reco_generation[slot_num], recogen);
> +		osb->slot_reco_generation[slot_num] = recogen;
> +		*busy = 1;
> +		status = 0;
>  		goto done;
>  	}
> -	SET_INODE_JOURNAL(inode);
> +
> +	/* Continue with recovery as the journal has not yet been recovered */
>  
>  	status = ocfs2_inode_lock_full(inode, &bh, 1, OCFS2_META_LOCK_RECOVERY);
>  	if (status < 0) {
> @@ -992,9 +1052,12 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
>  	fe = (struct ocfs2_dinode *) bh->b_data;
>  
>  	flags = le32_to_cpu(fe->id1.journal1.ij_flags);
> +	recogen = le32_to_cpu(fe->id1.journal1.ij_reco_generation);
>  
>  	if (!(flags & OCFS2_JOURNAL_DIRTY_FL)) {
>  		mlog(0, "No recovery required for node %d\n", node_num);
> +		/* Refresh recovery generation for the slot */
> +		osb->slot_reco_generation[slot_num] = recogen;
>  		goto done;
>  	}
>  
> @@ -1042,6 +1105,11 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
>  	flags &= ~OCFS2_JOURNAL_DIRTY_FL;
>  	fe->id1.journal1.ij_flags = cpu_to_le32(flags);
>  
> +	/* Increment recovery generation to indicate successful recovery */
> +	le32_add_cpu(&(fe->id1.journal1.ij_reco_generation), 1);
> +	osb->slot_reco_generation[slot_num] =
> +		le32_to_cpu(fe->id1.journal1.ij_reco_generation);
> +
>  	status = ocfs2_write_block(osb, bh, inode);
>  	if (status < 0)
>  		mlog_errno(status);
> @@ -1066,6 +1134,30 @@ done:
>  	return status;
>  }
>  
> +/* Refresh recovery generations of all slots */
> +static int ocfs2_refresh_all_journal_recogens(struct ocfs2_super *osb)
> +{
> +	int i;
> +	int status = 0;
> +
> +	for (i = 0; i < osb->max_slots; ++i) {
> +		if (i == osb->slot_num)
> +			continue;
> +		status = ocfs2_read_journal_recogen(osb, i,
> +						&(osb->slot_reco_generation[i]),
> +						NULL);
> +		if (status) {
> +			mlog_errno(status);
> +			goto bail;
> +		}
> +		mlog(0, "Slot %u recovery generation is %u\n", i,
> +		     osb->slot_reco_generation[i]);
> +	}
> +
> +bail:
> +	return status;
> +}
> +
>  /*
>   * Do the most important parts of node recovery:
>   *  - Replay it's journal
> @@ -1081,7 +1173,7 @@ done:
>  static int ocfs2_recover_node(struct ocfs2_super *osb,
>  			      int node_num)
>  {
> -	int status = 0;
> +	int status = 0, busy = 0;
>  	int slot_num;
>  	struct ocfs2_slot_info *si = osb->slot_info;
>  	struct ocfs2_dinode *la_copy = NULL;
> @@ -1098,19 +1190,28 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
>  
>  	slot_num = ocfs2_node_num_to_slot(si, node_num);
>  	if (slot_num == OCFS2_INVALID_SLOT) {

	What version is this patch against?  This should read -ENOENT,
not INVALID_SLOT.
	Regarding reading the journals twice - who cares?  This is
recovery - known to be slow.  It's only a few extra reads, part of an
operation that already reads and possibly writes.

Joel

-- 

"Win95 file and print sharing are for relatively friendly nets."
	- Paul Leach, Microsoft

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
