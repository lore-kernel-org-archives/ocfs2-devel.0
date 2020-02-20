From: Matthew Wilcox <willy@infradead.org>
Date: Thu, 20 Feb 2020 14:39:09 -0800
Subject: [Ocfs2-devel] [PATCH v7 00/23] Change readahead API
In-Reply-To: <20200220175400.GB2902@twin.jikos.cz>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200220175400.GB2902@twin.jikos.cz>
Message-ID: <20200220223909.GB24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dsterba@suse.cz, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 06:54:00PM +0100, David Sterba wrote:
> On Wed, Feb 19, 2020 at 01:00:39PM -0800, Matthew Wilcox wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > This series adds a readahead address_space operation to eventually
> > replace the readpages operation.  The key difference is that
> > pages are added to the page cache as they are allocated (and
> > then looked up by the filesystem) instead of passing them on a
> > list to the readpages operation and having the filesystem add
> > them to the page cache.  It's a net reduction in code for each
> > implementation, more efficient than walking a list, and solves
> > the direct-write vs buffered-read problem reported by yu kuai at
> > https://urldefense.com/v3/__https://lore.kernel.org/linux-fsdevel/20200116063601.39201-1-yukuai3 at huawei.com/__;!!GqivPVa7Brio!PSofOvlJ7CW1rg5JjImjIgIXeIgapJVME9s7Q5n9tSU2lQzOyy6wg4-tkac0Lhm2mHQg1Q$ 
> > 
> > The only unconverted filesystems are those which use fscache.
> > Their conversion is pending Dave Howells' rewrite which will make the
> > conversion substantially easier.
> > 
> > I want to thank the reviewers; Dave Chinner, John Hubbard and Christoph
> > Hellwig have done a marvellous job of providing constructive criticism.
> > Eric Biggers pointed out how I'd broken ext4 (which led to a substantial
> > change).  I've tried to take it all on board, but I may have missed
> > something simply because you've done such a thorough job.
> > 
> > This series can also be found at
> > https://urldefense.com/v3/__http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/tags/readahead_v7__;!!GqivPVa7Brio!PSofOvlJ7CW1rg5JjImjIgIXeIgapJVME9s7Q5n9tSU2lQzOyy6wg4-tkac0Lhk1B9Ks6g$ 
> > (I also pushed the readahead_v6 tag there in case anyone wants to diff, and
> > they're both based on 5.6-rc2 so they're easy to diff)
> > 
> > v7:
> >  - Now passes an xfstests run on ext4!
> 
> On btrfs it still chokes on the first test btrfs/001, with the following
> warning, the test is stuck there.

Thanks.  The warning actually wasn't the problem, but it did need to
be addressed.  I got a test system up & running with btrfs, and it's
currently on generic/027 with the following patch:

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 9c782c15f7f7..d23a224d2ad2 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -676,7 +676,7 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
 		struct page **array, unsigned int array_sz)
 {
 	unsigned int i = 0;
-	XA_STATE(xas, &rac->mapping->i_pages, rac->_index);
+	XA_STATE(xas, &rac->mapping->i_pages, 0);
 	struct page *page;
 
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
@@ -684,6 +684,8 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
 	rac->_index += rac->_batch_count;
 	rac->_batch_count = 0;
 
+	xas_set(&xas, rac->_index);
+	rcu_read_lock();
 	xas_for_each(&xas, page, rac->_index + rac->_nr_pages - 1) {
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageTail(page), page);
@@ -702,6 +704,7 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
 		if (i == array_sz)
 			break;
 	}
+	rcu_read_unlock();
 
 	return i;
 }
