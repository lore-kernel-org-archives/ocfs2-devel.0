From: Matthew Wilcox (Oracle) <willy@infradead.org>
Date: Sun,  4 Oct 2020 19:04:22 +0100
Subject: [Ocfs2-devel] [PATCH 1/7] 9P: Cast to loff_t before multiplying
In-Reply-To: <20201004180428.14494-1-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
Message-ID: <20201004180428.14494-2-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org

On 32-bit systems, this multiplication will overflow for files larger
than 4GB.

Cc: stable at vger.kernel.org
Fixes: fb89b45cdfdc ("9P: introduction of a new cache=mmap model.")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/9p/vfs_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 3576123d8299..6d97b6b4d34b 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -612,9 +612,9 @@ static void v9fs_mmap_vm_close(struct vm_area_struct *vma)
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
 		.sync_mode = WB_SYNC_ALL,
-		.range_start = vma->vm_pgoff * PAGE_SIZE,
+		.range_start = (loff_t)vma->vm_pgoff * PAGE_SIZE,
 		 /* absolute end, byte at end included */
-		.range_end = vma->vm_pgoff * PAGE_SIZE +
+		.range_end = (loff_t)vma->vm_pgoff * PAGE_SIZE +
 			(vma->vm_end - vma->vm_start - 1),
 	};
 
-- 
2.28.0
