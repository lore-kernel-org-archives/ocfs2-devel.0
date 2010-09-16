From: Joel Becker <Joel.Becker@ORACLE.COM>
Date: Wed, 15 Sep 2010 23:41:34 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Resolve the problem of
	truncate log flush.
In-Reply-To: <4C91B707.8030502@oracle.com>
References: <4C91B707.8030502@oracle.com>
Message-ID: <20100916064134.GC12578@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 16, 2010 at 02:19:51PM +0800, Tao Ma wrote:
> 0002-0003 are a little complicate here.
> So in general, even we have freed the clusters to the global
> bitmap(by the above flush), we can't use them because they haven't
> been committed to the disk(check the comments above
> ocfs2_test_bg_bit_allocatable for details). So we have to tell jbd2
> to flush immediately.

Mark,
	Didn't we do something to allow our allocation to re-use these
clusters?  Or was that for "thought to be allocated but never actually
used" clusters?

> 0002 reverts some change in commit c271c5c so that now even in local
> mode we can force jbd2 to flush immediately.
> 0003 add the 'checkpoint' to ocfs2_truncate_log_needs_flush, so that
> the callers know that we need to checkpoint after the flush.
> 
> Actually 0003 can work without 0002 since in cluster env,
> ocfs2_start_checkpoint will work and 0002 is just used for a local
> mode. So feel free to drop 0002 if we decide to still keep ocfs2cmt
> out of local mode.

	Assuming we want to force jbd2 out, which is heavy as you point
out, can't we just sync the filesystem?  Wouldn't that work without
adding ocfs2cmt?

Joel

-- 

"I am working for the time when unqualified blacks, browns, and
 women join the unqualified men in running our government."
	- Sissy Farenthold

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
