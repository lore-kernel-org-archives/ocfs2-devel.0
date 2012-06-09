From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat,  9 Jun 2012 09:50:35 +0900
Subject: [Ocfs2-devel] [PATCH v3 6/9] ocfs2: use memweight()
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <1339203038-13069-6-git-send-email-akinobu.mita@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Use memweight to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
No changes from v1

 fs/ocfs2/localalloc.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 210c352..a9f78c7 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -784,14 +784,10 @@ bail:
 
 static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
 {
-	int i;
-	u8 *buffer;
-	u32 count = 0;
+	u32 count;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	buffer = la->la_bitmap;
-	for (i = 0; i < le16_to_cpu(la->la_size); i++)
-		count += hweight8(buffer[i]);
+	count = memweight(la->la_bitmap, le16_to_cpu(la->la_size));
 
 	trace_ocfs2_local_alloc_count_bits(count);
 	return count;
-- 
1.7.7.6
