From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 9 Jun 2014 13:03:52 -0700
Subject: [Ocfs2-devel] ocfs2 patches for review
Message-ID: <20140609130352.fc94f7d6ceaff24750eabccb@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


I'm stuck with the usual handful of patches.  My notes:


ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename.patch: needs acks

deadlock-when-two-nodes-are-converting-same-lock-from-pr-to-ex-and-idletimeout-closes-conn.patch: needs acks

ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch: needs acks

ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch: needs acks

refcount-take-inode_lock-until-write-io-issued.patch: needs acks

ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch: needs acks. Mark confused, worried about log flooding

ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch: needs acks

ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch: needs acks, Mark dislikes it.



I'll send them out for re-review now.
