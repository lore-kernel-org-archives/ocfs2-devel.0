From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:04:17 -0700
Subject: [Ocfs2-devel] ocfs2 patch queue
Message-ID: <20130827140417.20aeaea9cf261b226029c5ed@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Guys, I'm sitting on a large number of OCFS2 patches and the review and
ack rate seems to be slowing down.  I'll send all of them to this list
now so can we please schedule a bit of time to go through them?

Several of these patches were added to the -mm tree before the 3.10
release, but I did not send them to Linus for 3.11-rc1 because their
review/ack status was unclear.  So can we please make a final decision
regarding those?

In particular:

ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch:
needs more review, Sunil might have nacked it.

ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch:
Sunil was worried about performance, Joel had a question, Mark wanted
an update, Joel acked it.  Help!

ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch:
could do with some more acks.  Jeff requested an update.

ocfs2-update-inode-size-after-zeronig-the-hole.patch: needs more review.

ocfs2-dlm-force-clean-refmap-when-doing-local-cleanup.patch: needs more
review.


Thanks.
