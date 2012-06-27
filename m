From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 27 Jun 2012 17:09:53 +0800
Subject: [Ocfs2-devel] [V4]fix ocfs2 aio/dio writing process hang
Message-ID: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org
Cc: mfasheh@suse.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, joe.jin@oracle.com


V4 changes:
add Acked-by: Joel Becker <jlbec@evilplan.org>

V3 changes:
- add Cc: stable at vger.kernel.org in the patch header to align with stable rules
- add Acked-by: Jeff Moyer <jmoyer@redhat.com>

V2 changes:
- update the patch header of the first patch to make it more clear.


This patch list fixes an issue about ocfs2 aio/dio write process hang.
The call trace is like this:
@  cat /proc/15913/stack
@ [<ffffffffa06e1085>] ocfs2_aiodio_wait+0x85/0xc0 [ocfs2]
@ [<ffffffffa06e3e39>] ocfs2_file_aio_write+0x99/0xa0 [ocfs2]
@ [<ffffffff811ace97>] aio_rw_vect_retry+0x87/0x150
@ [<ffffffff811aebd1>] aio_run_iocb+0x71/0x170
@ [<ffffffff811af59b>] io_submit_one+0x1ab/0x280
@ [<ffffffff811af77c>] do_io_submit+0x10c/0x1c0
@ [<ffffffff811af840>] sys_io_submit+0x10/0x20
@ [<ffffffff81509b42>] system_call_fastpath+0x16/0x1b
@ [<ffffffffffffffff>] 0xffffffffffffffff
