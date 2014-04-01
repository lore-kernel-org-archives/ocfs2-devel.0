From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 1 Apr 2014 16:26:25 -0700
Subject: [Ocfs2-devel] +
	pass-new-parameter-to-ocfs2_init_xattr_bucket.patch added
	to	-mm tree
In-Reply-To: <5335e056./bmn0Gvv2b5bhbdp%akpm@linux-foundation.org>
References: <5335e056./bmn0Gvv2b5bhbdp%akpm@linux-foundation.org>
Message-ID: <20140401232625.GM4488@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 28, 2014 at 01:49:26PM -0700, Andrew Morton wrote:
<snip> 
> It hit the BUG_ON() in ocfs2_set_new_buffer_uptodate().
> 
> 527 void ocfs2_set_new_buffer_uptodate(struct ocfs2_caching_info *ci,
> 528                                    struct buffer_head *bh)
> 529 {
> 530         /* This should definitely *not* exist in our cache */
> 531         if (ocfs2_buffer_cached(ci, bh))
> 532                 printk(KERN_ERR "bh->b_blocknr: %lu @ %p\n", bh->b_blocknr, bh);
> 533         BUG_ON(ocfs2_buffer_cached(ci, bh));
> 534
> 535         set_buffer_uptodate(bh);
> 536
> 537         ocfs2_metadata_cache_io_lock(ci);
> 538         ocfs2_set_buffer_uptodate(ci, bh);
> 539         ocfs2_metadata_cache_io_unlock(ci);
> 540 }
> 
> The problem here is:
> 
> We cached a block, but the buffer_head got reused.  When we are to pick up
> this block again, a new buffer_head created with UPTODATE flag cleared. 
> ocfs2_buffer_uptodate() returned false since no UPTODATE is set on the
> buffer_head.  so we set this block to cache as a NEW block, then it failed
> at asserting block is not in cache.
> 
> The fix is to add a new parameter indicating the bucket is a new allocated
> or not to ocfs2_init_xattr_bucket().  ocfs2_init_xattr_bucket() assert
> block not cached accordingly.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Good catch - the patch looks good too. Thanks Wengang!

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
