From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 21 Aug 2015 14:39:55 -0700
Subject: [Ocfs2-devel] ocfs2 pending patch review
Message-ID: <20150821143955.8de8dd80c5e85dc450db121c@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Guys, we're really getting behind with this and I'm sitting on a large
number of rather old patches.

So can we please get down, review this code and make a decision one way
or the other?

Here's the list of 24 patches I shall send out, along with a few notes:


ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch

ocfs2-trusted-xattr-missing-cap_sys_admin-check.patch
	- breaks existing userspace?

ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
add-errors=continue.patch
acknowledge-return-value-of-ocfs2_error.patch
clear-the-rest-of-the-buffers-on-error.patch

ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch

ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes.patch

ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

ocfs2-optimize-error-handling-in-dlm_request_join.patch

resubmit-bug_onlockres-l_level-=-dlm_lock_ex-checkpointed-tripped-in-ocfs2_ci_checkpointed.patch
	- Joseph Qi had a suggestion
resubmit-ocfs2_iop_set-get_acl-called-from-the-vfs-so-take-inode-lock-v2second-version.patch

ocfs2-fix-race-between-crashed-dio-and-rm.patch

ocfs2-use-64bit-variables-to-track-heartbeat-time.patch

ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch
	- Zhangguanghui <zhang.guanghui@h3c.com> raised an issue

ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
	- Mark has issues

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch

ocfs2-export-ocfs2_kset-for-online-file-check.patch
ocfs2-sysfile-interfaces-for-online-file-check.patch
ocfs2-create-remove-sysfile-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check.patch
ocfs2-add-feature-document-for-online-file-check.patch

Thanks.
