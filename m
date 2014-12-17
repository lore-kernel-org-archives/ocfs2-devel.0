From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 17 Dec 2014 12:58:27 -0800
Subject: [Ocfs2-devel] [patch 06/15] ocfs2: reflink: fix slow unlink for
	refcounted	file
In-Reply-To: <548f65da.rrmQq58cyUfZy3uq%akpm@linux-foundation.org>
References: <548f65da.rrmQq58cyUfZy3uq%akpm@linux-foundation.org>
Message-ID: <20141217205827.GQ7238@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 15, 2014 at 02:51:06PM -0800, Andrew Morton wrote:
> From: Junxiao Bi <junxiao.bi@oracle.com>
> Subject: ocfs2: reflink: fix slow unlink for refcounted file
> 
> When running ocfs2 test suite multiple nodes reflink stress test, for a 4
> nodes cluster, every unlink() for refcounted file needs about 700s.
>
> The slow unlink is caused by the contention of refcount tree lock since
> all nodes are unlink files using the same refcount tree.  When the
> unlinking file have many extents(over 1600 in our test), most of the
> extents has refcounted flag set.  In ocfs2_commit_truncate(), it will
> execute the following call trace for every extents.  This means it needs
> get and released refcount tree lock about 1600 times.  And when several
> nodes are do this at the same time, the performance will be very low.
> 
> ocfs2_remove_btree_range()
> ----ocfs2_lock_refcount_tree()
> ------ocfs2_refcount_lock()
> --------__ocfs2_cluster_lock()
> 
> ocfs2_refcount_lock() is costly, move it to ocfs2_commit_truncate() to do
> lock/unlock once can improve a lot performance.

Looks good, thanks Junxiao!

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
