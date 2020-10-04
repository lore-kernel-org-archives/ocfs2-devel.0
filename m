From: Matthew Wilcox (Oracle) <willy@infradead.org>
Date: Sun,  4 Oct 2020 19:04:23 +0100
Subject: [Ocfs2-devel] [PATCH 2/7] buffer: Promote to unsigned long long
	before shifting
In-Reply-To: <20201004180428.14494-1-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
Message-ID: <20201004180428.14494-3-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org

On 32-bit systems, this shift will overflow for files larger than 4GB.

Cc: stable at vger.kernel.org
Fixes: 5417169026c3 ("[FS] Implement block_page_mkwrite.")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 50bbc99e3d96..66f4765e60ee 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2515,7 +2515,7 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	}
 
 	/* page is wholly or partially inside EOF */
-	if (((page->index + 1) << PAGE_SHIFT) > size)
+	if (((page->index + 1ULL) << PAGE_SHIFT) > size)
 		end = size & ~PAGE_MASK;
 	else
 		end = PAGE_SIZE;
-- 
2.28.0
