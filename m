From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 16 Dec 2010 20:56:06 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: lock the page in
 __ocfs2_page_mkwrite() -v2
In-Reply-To: <20101214174450.GB9240@wotan.suse.de>
References: <201011181554.oAIFs5a5031128@rcsinet15.oracle.com>
	<20101214174450.GB9240@wotan.suse.de>
Message-ID: <20101216125606.GA17398@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

On 10-12-14 09:44, Mark Fasheh wrote:
> Hi Wengang,
> 
> On Thu, Nov 18, 2010 at 11:52:14PM +0800, Wengang Wang wrote:
> > Lock the page in __ocfs2_page_mkwrite(). Or we may get -EINVAL error
> > from ocfs2_grab_pages_for_write() if the page(page cache) gets truncated
> > while someone is flushing the pagecache. In the original code, we are
> > checking mapping earlier in __ocfs2_page_mkwrite() but we don't lock it.
> > so the mapping can change during flushing pagecache.
> 
<snip>
> 
> This breaks the page lock ordering in ocfs2_grab_pages_for_write() -- note
> that the call to find_or_create_page() in that function returns pages in a
> locked state. So roughly, we want to be taking them in index order.

In ocfs2_grab_pages_for_write() code, there is a comment that

1131                 if (index == target_index && mmap_page) {
1132                         /*
1133                          * ocfs2_pagemkwrite() is a little different
1134                          * and wants us to directly use the page
1135                          * passed in.
1136                          */
1137                         lock_page(mmap_page);

I guess it's commented by you? So how it "wants" us to use the page
passed in?
The main purpose of page_mkwrite() is to setup the mapping of page index to
sector(block) numbers on the device. I don't see using the page passed in is
very important. Correct me if I am wrong.
So also for (index == target_index && mmap_page) situation, we can use
find_or_create_page() just like where it's used in other situation.
find_lock_page() takes care of (page->mapping != mapping). How about it?

#patch attached

regards,
wengang.
-------------- next part --------------
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f1e962c..e9145db 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1128,36 +1128,11 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 	for(i = 0; i < wc->w_num_pages; i++) {
 		index = start + i;
 
-		if (index == target_index && mmap_page) {
-			/*
-			 * ocfs2_pagemkwrite() is a little different
-			 * and wants us to directly use the page
-			 * passed in.
-			 */
-			lock_page(mmap_page);
-
-			if (mmap_page->mapping != mapping) {
-				unlock_page(mmap_page);
-				/*
-				 * Sanity check - the locking in
-				 * ocfs2_pagemkwrite() should ensure
-				 * that this code doesn't trigger.
-				 */
-				ret = -EINVAL;
-				mlog_errno(ret);
-				goto out;
-			}
-
-			page_cache_get(mmap_page);
-			wc->w_pages[i] = mmap_page;
-		} else {
-			wc->w_pages[i] = find_or_create_page(mapping, index,
-							     GFP_NOFS);
-			if (!wc->w_pages[i]) {
-				ret = -ENOMEM;
-				mlog_errno(ret);
-				goto out;
-			}
+		wc->w_pages[i] = find_or_create_page(mapping, index, GFP_NOFS);
+		if (!wc->w_pages[i]) {
+			ret = -ENOMEM;
+			mlog_errno(ret);
+			goto out;
 		}
 
 		if (index == target_index)
