From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 13 Aug 2014 11:03:39 -0700
Subject: [Ocfs2-devel] [patch 02/10] ocfs2: free inode when i_count
	becomes zero
In-Reply-To: <53e290c2.UrOYpRJudvt5Qabp%akpm@linux-foundation.org>
References: <53e290c2.UrOYpRJudvt5Qabp%akpm@linux-foundation.org>
Message-ID: <20140813180339.GU2203@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 06, 2014 at 01:32:02PM -0700, Andrew Morton wrote:
> From: Xue jiufei <xuejiufei@huawei.com>
> Subject: ocfs2: free inode when i_count becomes zero
> 
> Disk inode deletion may be heavily delayed when one node unlink a file
> after the same dentry is freed on another node(say N1) because of memory
> shrink but inode is left in memory.  This inode can only be freed while N1
> doing the orphan scan work.
> 
> However, N1 may skip orphan scan for several times because other nodes may
> do the work earlier.  In our tests, it may take 1 hour on 4 nodes cluster
> and this will cause bad user experience.  So we think the inode should be
> freed when i_count becomes zero to avoid such circumstances.

Firstly, thanks for the patch Xue.

I understand your problem and I definitely agree that it hurts the user
experience. If the inode is free to be deleted we shouldn't be taking so
long to get rid of it.

What I'm worried about is that we're always going to tell the kernel to
evict the inode now, which will always cause some sort of cluster locking.

I need to look at this more and think about it a bit. Maybe there's a better
way?
	--Mark

--
Mark Fasheh
