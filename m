From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 19 Jun 2013 16:17:35 +0800
Subject: [Ocfs2-devel] ocfs2: Should move ocfs2_start_trans out of lock_page
Message-ID: <51C1691F.8060504@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently ocfs2_start_trans/ocfs2_commit_trans are in
lock_page/unlock_page. This may cause dead lock.

Here is the situation:
write -> lock_page -> ocfs2_start_trans -> ocfs2_commit_trans -> unlock_page
ocfs2_start_trans/ocfs2_commit_trans calls
jbd2_journal_start/jbd2_journal_stop which may also call lock_page. So
if the page operated is unfortunately the same with the page to be
committed, dead lock happens.

In ext4, lock_page/unlock_page are in
ext4_journal_start/ext4_journal_stop, this can avoid such kind of dead
lock. So I think we should move ocfs2_start_trans/ocfs2_commit_trans out
of lock_page/unlock_page.

Totally there are 5 related functions:
ocfs2_write_begin_nolock
ocfs2_write_begin_inline
ocfs2_write_end_nolock
ocfs2_write_zero_page
ocfs2_convert_inline_data_to_extents
