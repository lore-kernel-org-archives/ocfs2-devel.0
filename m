From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 19 Mar 2014 14:09:07 -0700
Subject: [Ocfs2-devel] ocfs2 patches pending review/ack
Message-ID: <20140319140907.e46f32085a2a499f23048ccd@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


I'm sitting on six patches which I'm reluctant to merge under my own
steam.  Some of these I have probably send out before.

ocfs2-alloc_dinode-counts-and-group-bitmap-should-be-update-simultaneously.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen.patch
ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch

And these two have been hanging around for a long time:

ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
("Sunil nack, Mark confused")

ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
("Sunil worried about performance, Joel had Q, Mark wanted update, Joel
acked, worried about perf")


Telling me to drop patches is acceptable ;)

I'll send them all out now.
