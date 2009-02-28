From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 27 Feb 2009 19:03:38 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to recover orphans in
	offline	slots during recovery.
In-Reply-To: <1235786526-17868-1-git-send-email-srinivas.eeda@oracle.com>
References: <1235786526-17868-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20090228030338.GN10695@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 27, 2009 at 06:02:06PM -0800, Srinivas Eeda wrote:
> In the current recovery procedure, recovering node recovers orphans from the
> slot it is holding and the slots that dead nodes were holding. Other online
> nodes recover orphans from their slots. But orphans in offline slots are left
> un-recovered.
> 
> This patch queues recovery_completion for offline slots.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>  fs/ocfs2/journal.c |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 71b2ea4..5434eb4 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1209,8 +1209,9 @@ static int __ocfs2_recovery_thread(void *arg)
>  	struct ocfs2_super *osb = arg;
>  	struct ocfs2_recovery_map *rm = osb->recovery_map;
>  	int *rm_quota = NULL;
> -	int rm_quota_used = 0, i;
> +	int rm_quota_used = 0, i, saveslots = 1;
>  	struct ocfs2_quota_recovery *qrec;
> +	int slot_arr[OCFS2_MAX_SLOTS];

	slot_arr should be rm_unused_slots, and it should follow the
same scheme as rm_quota.  Notice that rm_quota is allocated from
osb->max_slots.
	That's the big reason I don't want slot_info being mucked with.
Our old code to access the slot map was really tied to the disk
structure and to the old limits.  I want all new code to not care about
the structure or the limits.  It should simply be limited by
osb->max_slots (a runtime number) and simple accessors to slot_map.c.

> @@ -1231,6 +1233,13 @@ restart:
>  		goto bail;
>  	}
>  
> +	/* save slots status so we can recover offline slots */
> +	if (saveslots) {
> +		saveslots = 0;
> +		for (i = 0; i < osb->slot_info->si_num_slots; i++)
> +			slot_arr[i] = osb->slot_info->si_slots[i].sl_valid;
> +	}
> +

	You don't even need slot_info yere.  si_num_slots is set from
osb->max_slots, which you already have.   You can check whether a slot
is in use via ocfs2_slot_to_node_num_locked() - it will return -ENOENT
if the slot is unused.  I don't think you need to make any slot map API
at all!
	The 'saveslots' doesn't make much sense.  Why is the slot
information good the first time around, but not the second?  In fact,
wouldn't it be the reverse?  If we have to back around to 'restart',
we've dropped the super lock and re-acquired it.  This means that
someone may have mounted and their slot is no longer offline.

>  	spin_lock(&osb->osb_lock);
>  	while (rm->rm_used) {
>  		/* It's always safe to remove entry zero, as we won't
> @@ -1296,11 +1305,13 @@ skip_recovery:
>  
>  	ocfs2_super_unlock(osb, 1);
>  
> -	/* We always run recovery on our own orphan dir - the dead
> -	 * node(s) may have disallowd a previos inode delete. Re-processing
> +	/* We always run recovery on our own and offline orphan slots - the dead
> +	 * node(s) may have disallowed a previous inode delete. Re-processing
>  	 * is therefore required. */
> -	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
> -					NULL, NULL);
> +	for (i = 0; i < osb->slot_info->si_num_slots; i++)
> +		if ((!slot_arr[i]) || osb->slot_num == i)
> +			ocfs2_queue_recovery_completion(osb->journal, i,
> +							NULL, NULL, NULL);

	Again, you don't even need slot_info here.
	Here's my question: we do this outside the superblock lock, so
the slot map can be out of date, so any specific mapping of empty slots
is silly.  Why don't we just run every orphan dir, period?  We can
safely lock the orphan dirs of online nodes - we'll try their inodes and
find them in-use.  That's a case that can already happen if that node
remounts before we get to recovering their orphan dir anyway.

Joel

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
