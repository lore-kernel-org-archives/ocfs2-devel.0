From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:10:05 -0700
Subject: [Ocfs2-devel] ocfs2 patch queue
Message-ID: <20160323131005.e4765b3a420c4380ebd50625@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


As usual I'm a bit late sending this out, sorry.

Here's what I have:

  ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write.patch
  ocfs2-use-c_new-to-indicate-newly-allocated-extents.patch
  ocfs2-test-target-page-before-change-it.patch
  ocfs2-do-not-change-i_size-in-write_end-for-direct-io.patch
  ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
  ocfs2-record-unwritten-extents-when-populate-write-desc.patch
  #ocfs2-fix-sparse-file-data-ordering-issue-in-direct-io.patch: Joseph Qi has questions
  ocfs2-fix-sparse-file-data-ordering-issue-in-direct-io.patch
  ocfs2-code-clean-up-for-direct-io.patch
  #
  ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch
  ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write.patch
  ocfs2-fix-disk-file-size-and-memory-file-size-mismatch.patch
  ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch
  #
  #ocfs2-dlm-fix-race-between-convert-and-recovery.patch: review discussion
  ocfs2-dlm-fix-race-between-convert-and-recovery.patch
  ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch
  
All the above have been reviewed by Junxiao Bi and I think I'll send
them in to Linus this week.

  ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
  extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

The first patch was commented on by Mark, no conclusion.  The second
has his reviewed-by.

  ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local.patch

Reviewed by Joseph - I'll send it to Linus this week.

  ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch

Reviewed by Joseph - I'll send it to Linus this week.

  ocfs2-o2hb-add-negotiate-timer.patch
  ocfs2-o2hb-add-nego_timeout-message.patch
  ocfs2-o2hb-add-negotiate_approve-message.patch
  ocfs2-o2hb-add-some-user-debug-log.patch
  ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
  ocfs2-o2hb-fix-hb-hung-time.patch

Reviewed by Ryan.  Are we all OK with this patchset?

  ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch

It's a bugfix but I have no record of it being reviewed.


I'll send all these patches out for people to take another look at.
