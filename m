From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 16 Sep 2010 14:19:51 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Resolve the problem of truncate
	log flush.
Message-ID: <4C91B707.8030502@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	Recently, one of our colleagues meet with a problem that if we 
write/delete a 32mb files repeatly, we will get a ENOSPC in the end. And 
the corresponding bug is 1288.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1288

So this patch set just tries to resolve it. It includes 3 patches:
0001 is a separate one. It just adds a new watermark for truncate log, 
FLUSH_TRUNCATE_LOG_RATIO. So if the truncate log has collected too much 
clusters, ocfs2_truncate_log_needs_flush will tell the caller to flush 
immediately.

0002-0003 are a little complicate here.
So in general, even we have freed the clusters to the global bitmap(by 
the above flush), we can't use them because they haven't been committed 
to the disk(check the comments above ocfs2_test_bg_bit_allocatable for 
details). So we have to tell jbd2 to flush immediately.
0002 reverts some change in commit c271c5c so that now even in local 
mode we can force jbd2 to flush immediately.
0003 add the 'checkpoint' to ocfs2_truncate_log_needs_flush, so that the 
callers know that we need to checkpoint after the flush.

Actually 0003 can work without 0002 since in cluster env, 
ocfs2_start_checkpoint will work and 0002 is just used for a local mode. 
So feel free to drop 0002 if we decide to still keep ocfs2cmt out of 
local mode.

Regards,
Tao
