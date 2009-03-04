From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 4 Mar 2009 11:49:26 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to recover orphans in
	offline	slots during recovery and mount
In-Reply-To: <1236154247-31126-1-git-send-email-srinivas.eeda@oracle.com>
References: <1236154247-31126-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20090304194857.GC27565@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 04, 2009 at 12:10:47AM -0800, Srinivas Eeda wrote:
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
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>

This looks good.

Mark and I discussed your proposal to only ocfs2_queue_replay_slots() if
we actually did a recovery, and we think it would work.  However, that
means you have to get the information from ocfs2_replay_journal() back
up through ocfs2_recover_node() to __ocfs2_recovery_thread().

Add a field to ocfs2_replay_map called 'enum ocfs2_replay_state
rm_state'.  The enum has three states: REPLAY_UNNEEDED, REPLAY_NEEDED,
REPLAY_DONE.  In ocfs2_compute_replay_map() you will set it to UNNEEDED.

Create a function ocfs2_replay_map_set_state().  In
ocfs2_complete_mount_recovery() you will call
ocfs2_replay_map_set_state(osb->replay_map, REPLAY_NEEDED) before
calling queue_replay_slots().  In ocfs2_replay_journal(), you'll
set_state(NEEDED) right after the check of OCFS2_JOURNAL_DIRTY_FL.  That
is, right after we find a dirty journal, you set it NEEDED.

In ocfs2_queue_replay_map(), you will only do the queue if
REPLAY_NEEDED is set.  After you've done the queue, call
set_state(DONE).  This ensures that repeated calls to queue_replay_map()
don't do it again.

Move the kfree() of the replay map to a function
ocfs2_free_replay_map().

In __ocfs2_recovery_thread(), leave the queue of our own slot at the top
like it is in your patch.  However, move the ocfs2_queue_replay_map()
call down after the ocfs2_super_unlock() - basically, where the old
queue used to be.  So the first pass through __ocfs2_recovery_thread(),
it will compute the map, try to do recovery, and then queue the map only
if a journal got replayed.

Obviously at the bottom of the function you free the map.  And you free
it after using it in complete_mount_recovery().

What do you think?

Joel

-- 

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
