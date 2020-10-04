From: Matthew Wilcox (Oracle) <willy@infradead.org>
Date: Sun,  4 Oct 2020 19:04:26 +0100
Subject: [Ocfs2-devel] [PATCH 5/7] btrfs: Promote to unsigned long long
	before shifting
In-Reply-To: <20201004180428.14494-1-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
Message-ID: <20201004180428.14494-6-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org

On 32-bit systems, this shift will overflow for files larger than 4GB.

Cc: stable at vger.kernel.org
Fixes: df480633b891 ("btrfs: extent-tree: Switch to new delalloc space reserve and release")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ac45f022b495..4d3b7e4ae53a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1277,7 +1277,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
 	ret = btrfs_delalloc_reserve_space(BTRFS_I(inode), &data_reserved,
-			start_index << PAGE_SHIFT,
+			(loff_t)start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT);
 	if (ret)
 		return ret;
@@ -1367,7 +1367,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), 1);
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
-				start_index << PAGE_SHIFT,
+				(loff_t)start_index << PAGE_SHIFT,
 				(page_cnt - i_done) << PAGE_SHIFT, true);
 	}
 
@@ -1395,7 +1395,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		put_page(pages[i]);
 	}
 	btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
-			start_index << PAGE_SHIFT,
+			(loff_t)start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, true);
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
-- 
2.28.0
