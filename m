From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 5 Mar 2009 15:28:34 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to recover orphans in
	offline	slots during recovery and mount
In-Reply-To: <1236246813-16263-1-git-send-email-srinivas.eeda@oracle.com>
References: <1236246813-16263-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20090305232833.GA27682@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 05, 2009 at 01:53:33AM -0800, Srinivas Eeda wrote:
> During recovery, a node recovers orphans in it's slot and the dead node(s). But
> if the dead nodes were holding orphans in offline slots, they will be left
> unrecovered.
> 
> If the dead node is the last one to die and is holding orphans in other slots
> and is the first one to mount, then it only recovers it's own slot, which
> leaves orphans in offline slots.
> 
> This patch queues complete_recovery to clean orphans for all offline slots
> during mount and node recovery.

	A couple comments.

> +/*
> + * This replay_map is to track online/offline slots, so we could recover
> + * offline slots during recovery and mount
> + */
> +
> +enum ocfs2_replay_state {
> +	REPLAY_UNNEEDED,
> +	REPLAY_NEEDED,
> +	REPLAY_DONE
> +};

	Let's define the states in comments on the enum.

	/* Replay is not needed, so ignore this map */
	/* Replay is needed, queue the slots specified in rm_replay_slots */
	/* Replay was already queued */

> +void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
> +{
> +	if (!osb->replay_map)
> +		return;

	/* If we've already queued the replay, we don't have any more to do */
	if (osb->replay_map->rm_state == REPLAY_DONE)
		return;

> +	osb->replay_map->rm_state = state;
> +}
> +
> +int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
> +{
> +	struct ocfs2_replay_map *replay_map;
> +	int i, node_num;
> +
> +	replay_map = osb->replay_map;
> +
> +	if (!replay_map)
> +		replay_map = kzalloc(sizeof(struct ocfs2_replay_map) +
> +				     (osb->max_slots * sizeof(char)),
> +				     GFP_KERNEL);

	We don't want to recompute the replay map.  If osb->replay_map
is set, just return out of this function, like you did in the previous
patch.

> +
> +	if (!replay_map) {
> +		mlog_errno(-ENOMEM);
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock(&osb->osb_lock);
> +
> +	replay_map->rm_slots = osb->max_slots;
> +	replay_map->rm_state = REPLAY_UNNEEDED;
> +
> +	/* set rm_replay_slots for offline slot(s) */
> +	for (i = 0; i < replay_map->rm_slots; i++) {
> +		if (ocfs2_slot_to_node_num_locked(osb, i, &node_num) == -ENOENT)
> +			replay_map->rm_replay_slots[i] = 1;
> +	}
> +
> +	osb->replay_map = replay_map;
> +	spin_unlock(&osb->osb_lock);
> +	return 0;
> +}

	Otherwise, the rest looks good.

Joel

-- 

"What do you take me for, an idiot?"  
        - General Charles de Gaulle, when a journalist asked him
          if he was happy.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
