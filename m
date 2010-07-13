From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 13 Jul 2010 11:22:32 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Don't duplicate page passes i_size
	during CoW.
In-Reply-To: <20100712091412.GA19583@mail.oracle.com>
References: <20100712091412.GA19583@mail.oracle.com>
Message-ID: <1278991352-5540-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
>> @@ -2932,12 +2932,20 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>>   	offset = ((loff_t)cpos)<<  OCFS2_SB(sb)->s_clustersize_bits;
>>   	end = offset + (new_len<<  OCFS2_SB(sb)->s_clustersize_bits);
>>
>> +	last_page = i_size_read(context->inode)>>  PAGE_CACHE_SHIFT;
>>   	while (offset<  end) {
> 
> 	Why trigger on both index and byte offset?  Why not just adjust
> end?
OK, here is the udpated one.

Regards,
Tao

From b30377da2dff2b5823c6a4a66153aa035334a632 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 13 Jul 2010 09:53:28 +0800
Subject: [PATCH v2] ocfs2: Don't duplicate page passes i_size during CoW.

During CoW, actually all the pages after i_size contains
garbage data, so don't read and duplicate them.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 1cf9cda..e4e85e6 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2931,6 +2931,13 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 
 	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
 	end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
+	/*
+	 * We only duplicate pages until we reach i_size.
+	 * So trim 'end' to the boundary of that page.
+	 */
+	if (end > i_size_read(context->inode))
+		end = ((i_size_read(context->inode) + PAGE_CACHE_SIZE - 1) >>
+			 PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
 
 	while (offset < end) {
 		page_index = offset >> PAGE_CACHE_SHIFT;
-- 
1.7.1.571.gba4d01
