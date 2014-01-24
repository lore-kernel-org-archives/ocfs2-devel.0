From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 24 Jan 2014 12:46:51 -0800
Subject: [Ocfs2-devel] stalled ocfs2 patches
Message-ID: <20140124124651.e805a6c3435fdc6f92973c6c@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Guys, I'm developing an increasingly large backlog of ocfs2 patches
which I am unprepared to send upstream.  Some I feel need review which
is beyond my understanding and some were reviewed, with an unclear
outcome.

Can we please take another look at all of these and try to get this all
cleared away?

I'll send all the patches now.  My notes are as follows:

ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch

  Needs acks

ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch

  Needs acks

ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch

  Needs acks

ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch

  Needs acks

ocfs2-code-cleanup-remove-unused-functions.patch

  Might have been nacked?

ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen.patch

  Needs acks

ocfs2-check-existence-of-old-dentry-in-ocfs2_link.patch

  Needs acks

ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch

  Needs more review.  Sunil might have nacked this, but it was foggy.

ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch

  Sunil was worried about performance, Joel had a question, Mark
  wanted an update, Joel acked it.

ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch

  To be updated in response to comment from Jeff Liu

ocfs2-update-inode-size-after-zeronig-the-hole.patch

  Needs acks
