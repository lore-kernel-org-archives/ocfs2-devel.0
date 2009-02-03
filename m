From: Jan Kara <jack@suse.cz>
Date: Tue, 3 Feb 2009 16:34:16 +0100
Subject: [Ocfs2-devel] Problem with ordered mode handling on truncate
Message-ID: <20090203153415.GC24630@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  I've looked at how OCFS2 call jbd2_journal_begin_ordered_truncate()
(because I've been adding some comments about how is should be used) and
noticed that OCFS2 has a potential race in truncate vs transaction commit
leading to stale data in file. In particular: There is a race if someone
writes new data and we start committing the transaction after
jbd2_journal_begin_ordered_truncate() is called but before transaction
adding inode to orphan list is started. Because then data written by the new
write are discarded in the truncate but if we crash before the truncate
itself is committed, we see old data instead of newly written one.
Maybe more understandable as a diagram:
	   CPU 1:					CPU 2:
jbd2_journal_begin_ordered_truncate(inode, 0)
							write(trans, inode, ...)
discard data of "inode"
							commit "trans"
---- CRASH

  The correct fix to this problem is to call
jbd2_journal_begin_ordered_truncate() after inode has been added to orphan
list (new i_size written respectively). That function is called from two
places:
1) ocfs2_truncate_for_delete() - easy to fix, just move the call just after
   the write of the inode.
2) ocfs2_setattr() - we can move the call into ocfs2_truncate_file() but
   that would mean calling jbd2_journal_begin_ordered_truncate()
   and consequently ocfs2_write_page() under ip_alloc_sem - not too nice.
   Furthermore ocfs2_orphan_for_truncate() zeros the last cluster
   beyond i_size and we cannot do that before writing out previous
   content... Not sure how to solve that yet.

  Any ideas welcome.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
