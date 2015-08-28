From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 28 Aug 2015 16:14:23 -0700
Subject: [Ocfs2-devel] [patch 03/28] ocfs2: flush inode data to disk and
 free inode when i_count becomes zero
In-Reply-To: <55de398e.qJZDB8tZ/RYyOgvJ%akpm@linux-foundation.org>
References: <55de398e.qJZDB8tZ/RYyOgvJ%akpm@linux-foundation.org>
Message-ID: <20150828231423.GI1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:26PM -0700, Andrew Morton wrote:
> From: Xue jiufei <xuejiufei@huawei.com>
> Subject: ocfs2: flush inode data to disk and free inode when i_count becomes zero
> 
> Disk inode deletion may be heavily delayed when one node unlink a file
> after the same dentry is freed on another node(say N1) because of memory
> shrink but inode is left in memory.  This inode can only be freed while N1
> doing the orphan scan work.
> 
> However, N1 may skip orphan scan for several times because other nodes may
> do the work earlier.  In our tests, it may take 1 hour on 4 nodes cluster
> and it hurts the user experience.  So we think the inode should be freed
> after the data flushed to disk when i_count becomes zero to avoid such
> circumstances.

So we'll always filter through ->delete_inode() now? A followup to add a
comment in ocfs2_drop_inode() to that effect would be nice.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
