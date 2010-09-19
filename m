From: Tao Ma <tao.ma@oracle.com>
Date: Sun, 19 Sep 2010 15:19:53 +0800
Subject: [Ocfs2-devel] [PATCH 0/2 V2] ocfs2: Resolve the problem of truncate
	log flush.
Message-ID: <4C95B999.1080307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

change log form v1 to v2:
0001: no change.
0002 is removed and now we use jbd2_journal_start_commit in local mode 
as suggested by Joel.

     Recently, one of our colleagues meet with a problem that if we 
write/delete a 32mb files repeatly, we will get a ENOSPC in the end. And 
the corresponding bug is 1288.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1288

So this patch set just tries to resolve it. It includes 2 patches:
0001 adds a new watermark for truncate log, FLUSH_TRUNCATE_LOG_RATIO. So 
if the truncate log has collected too much clusters, 
ocfs2_truncate_log_needs_flush will tell the caller to flush immediately.

0002 try to add journal checkpoint support if we finds the need for 
checkpointing what truncate log has freed. for cluster mount, it is 
simple and we just need to wake up the ocfs2cmt and let it work for us.
For local mode, we will call jbd2_journal_start_commit directly which 
will start the checkpoint.

Regards,
Tao
