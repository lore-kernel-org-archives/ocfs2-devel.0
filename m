From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 6 Aug 2014 13:30:50 -0700
Subject: [Ocfs2-devel] ocfs2 patches needing review
Message-ID: <20140806133050.5c9c8fbd0ef96c64df4e85c1@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Can we please cast an eye across this little pile?

Subject: ocfs2: do not write error flag to user structure we cannot copy from/to
Subject: ocfs2: free inode when i_count becomes zero
Subject: ocfs2: o2net: don't shutdown connection when idle timeout
Subject: ocfs2: o2net: set tcp user timeout to max value
Subject: ocfs2: quorum: add a log for node not fenced
Subject: ocfs2: call ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()
Subject: ocfs2: avoid access invalid address when read o2dlm debug messages.
Subject: ocfs2/dlm: fix race between dispatched_work and dlm_lockres_grab_inflight_worker
Subject: ocfs2: reflink: fix slow unlink for refcounted file
Subject: ocfs2: fix journal commit deadlock

patches follow...
