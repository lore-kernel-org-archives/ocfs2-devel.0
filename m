From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 13 Jul 2010 22:50:44 +0800
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: Don't duplicate page passes i_size
	during CoW.
In-Reply-To: <20100713081306.GB31479@mail.oracle.com>
References: <20100713081306.GB31479@mail.oracle.com>
Message-ID: <1279032644-8050-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Jul 13, 2010 at 11:22:32AM +0800, Tao Ma wrote:
>> +	/*
>> +	 * We only duplicate pages until we reach i_size.
>> +	 * So trim 'end' to the boundary of that page.
>> +	 */
>> +	if (end > i_size_read(context->inode))
>> +		end = ((i_size_read(context->inode) + PAGE_CACHE_SIZE - 1) >>
>> +			 PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
>
> Just use PAGE_CACHE_ALIGN().
oh, I don't know we have such a good macro. thanks.
Here is the updated one.

Regards,
Tao

From c1c2b02b2e5c30021a2265d950db6ed23c8d57d0 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 13 Jul 2010 22:13:37 +0800
Subject: [PATCH v3] ocfs2: Don't duplicate page passes i_size during CoW.

During CoW, actually all the pages after i_size contains
garbage data, so don't read and duplicate them.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 1cf9cda..efde427 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2931,6 +2931,12 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 
 	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
 	end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
+	/*
+	 * We only duplicate pages until we reach the page contains i_size - 1.
+	 * So trim 'end' to the boundary of that page.
+	 */
+	if (end > i_size_read(context->inode))
+		end = PAGE_CACHE_ALIGN(i_size_read(context->inode));
 
 	while (offset < end) {
 		page_index = offset >> PAGE_CACHE_SHIFT;
-- 
1.7.1.571.gba4d01
