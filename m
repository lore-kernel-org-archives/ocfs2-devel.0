From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 7 Apr 2015 14:54:53 -0700
Subject: [Ocfs2-devel] ocfs2 patches for review
Message-ID: <20150407145453.db5c18c6214fbfbb24537dbd@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Nine patches for which I feel additional review/test/etc is needed,
please.

Some of these are somewhat old - if people think I should just drop
them then please say so.


ocfs2-trusted-xattr-missing-cap_sys_admin-check.patch
	- breaks userspace?

ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch

add-errors=continue.patch
acknowledge-return-value-of-ocfs2_error.patch
clear-the-rest-of-the-buffers-on-error.patch

ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch

ocfs2-use-64bit-variables-to-track-heartbeat-time.patch

ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch
	- Mark wants changes. Mark has list of notes

ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
	- Mark has issues
