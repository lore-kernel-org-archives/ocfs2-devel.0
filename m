From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 4 Feb 2015 16:00:24 -0800
Subject: [Ocfs2-devel] ocfs2 patch review for 3.19
Message-ID: <20150204160024.3bfdfa2ecc067c1760f5fdd2@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Thsi time I have only four patches which I consider need expert review,
please.

ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory.patch

o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
(Joseph Qi had issues)

ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch
(Mark has list of things which need doing)

ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
(Mark has issues with it)
