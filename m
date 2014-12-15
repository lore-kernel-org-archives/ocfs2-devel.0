From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 15 Dec 2014 14:49:45 -0800
Subject: [Ocfs2-devel] ocfs patches for review
Message-ID: <20141215144945.268d08467edc223e7ef12281@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Another round of jolly patch reviewing, please.  A number of these
patches have been stalled for quite a long time.

I have the following notes:

o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch:
   - Joseph Qi had issues

ocfs2-free-inode-when-i_count-becomes-zero.patch:
   - Mark is finding a better way of doing this

ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch:
   - Mark requested changes
