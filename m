From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 19 Mar 2014 16:00:39 -0700
Subject: [Ocfs2-devel] ocfs2 patches pending review/ack
In-Reply-To: <20140319140907.e46f32085a2a499f23048ccd@linux-foundation.org>
References: <20140319140907.e46f32085a2a499f23048ccd@linux-foundation.org>
Message-ID: <20140319230039.GB5716@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 19, 2014 at 02:09:07PM -0700, Andrew Morton wrote:
> 
> I'm sitting on six patches which I'm reluctant to merge under my own
> steam.  Some of these I have probably send out before.
> 
> ocfs2-alloc_dinode-counts-and-group-bitmap-should-be-update-simultaneously.patch
> ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
> ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen.patch
> ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode.patch
> ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
> ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch

I can the review above patches tommorrow for us.


> And these two have been hanging around for a long time:
> 
> ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
> ("Sunil nack, Mark confused")

Go ahead and drop this one please. I never figured out exactly what the
actual problem was - I'd be happy to come back to it later once we know
more.


> ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
> ("Sunil worried about performance, Joel had Q, Mark wanted update, Joel
> acked, worried about perf")

The performance testing didn't really happen in a way that was useful. I
wanted to find time to do it on my own but never did. Since this fixes a bug
for a known user I would say to go for it.
	--Mark

--
Mark Fasheh
