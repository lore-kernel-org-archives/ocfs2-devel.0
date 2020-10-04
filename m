From: Matthew Wilcox (Oracle) <willy@infradead.org>
Date: Sun,  4 Oct 2020 19:04:25 +0100
Subject: [Ocfs2-devel] [PATCH 4/7] ocfs2: Promote to unsigned long long
	before shifting
In-Reply-To: <20201004180428.14494-1-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
Message-ID: <20201004180428.14494-5-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org

On 32-bit systems, this shift will overflow for files larger than 4GB.

Cc: stable at vger.kernel.org
Fixes: 35edec1d52c0 ("ocfs2: update truncate handling of partial clusters")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4c1b90442d6f..26eff79ecb50 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6867,7 +6867,7 @@ static void ocfs2_zero_cluster_pages(struct inode *inode, loff_t start,
 		ocfs2_map_and_dirty_page(inode, handle, from, to, page, 1,
 					 &phys);
 
-		start = (page->index + 1) << PAGE_SHIFT;
+		start = (page->index + 1ULL) << PAGE_SHIFT;
 	}
 out:
 	if (pages)
-- 
2.28.0
