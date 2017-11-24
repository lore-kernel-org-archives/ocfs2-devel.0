From: alex chen <alex.chen@huawei.com>
Date: Fri, 24 Nov 2017 13:46:08 +0800
Subject: [Ocfs2-devel] [PATCH] Bug#841144: kernel BUG at
	/build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!
In-Reply-To: <1511298301.2735.1.camel@nixnuts.net>
References: <1511204090.3644.6.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CB51@H3CMLB14-EX.srv.huawei-3com.com>
	<1511232309.3644.14.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CDDB@H3CMLB14-EX.srv.huawei-3com.com>
	<1511298301.2735.1.camel@nixnuts.net>
Message-ID: <5A17B220.5030909@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi John,

I think a better method to solve this problem.

On 2017/11/22 5:05, John Lightsey wrote:
> On Tue, 2017-11-21 at 05:58 +0000, Changwei Ge wrote:
> 
>> Can your tell me how did you format your volume?
>> What's your _cluster size_ and _block size_?
>> Your can obtain such information via debugfs.ocfs2 <your volume> -R 
>> 'stats' | grep 'Cluster Size'
>>
>> It's better for you provide a way to reproduce this issue so that we
>> can 
>> perform some test.
>>
> 
> The issue recurred in our cluster today, so at best my patch is just
> decreasing the frequency of the crashes.

We need to check the free number of the records in each loop to mark extent written,
because the last extent block may be changed through many times marking extent written
and the num_free_extents also be changed. In the worst case, the num_free_extents may
become less than at the beginning of the loop. So we should not estimate the free
number of the records at the beginning of the loop to mark extent written.

I'd appreciate it if you could test the following patch and feedback the result.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
---
 fs/ocfs2/aops.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index d151632..80725f2 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2272,6 +2272,35 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	return ret;
 }

+static int ocfs2_dio_should_restart(struct ocfs2_extent_tree *et,
+		struct ocfs2_alloc_context *meta_ac, int max_rec_needed)
+{
+	int status = 0, free_extents;
+
+	free_extents = ocfs2_num_free_extents(et);
+	if (free_extents < 0) {
+		status = free_extents;
+		mlog_errno(status);
+		return status;
+	}
+
+	/*
+	 * there are two cases which could cause us to EAGAIN in the
+	 * we-need-more-metadata case:
+	 * 1) we haven't reserved *any*
+	 * 2) we are so fragmented, we've needed to add metadata too
+	 *    many times.
+	 */
+	if (free_extents < max_rec_needed) {
+		if (!meta_ac || (ocfs2_alloc_context_bits_left(meta_ac)
+				< ocfs2_extend_meta_needed(et->et_root_el)))
+			status = 1;
+	}
+
+	return status;
+}
+
+#define OCFS2_MAX_REC_NEED_SPLIT 2
 static int ocfs2_dio_end_io_write(struct inode *inode,
 				  struct ocfs2_dio_write_ctxt *dwc,
 				  loff_t offset,
@@ -2281,14 +2310,13 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	struct ocfs2_extent_tree et;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_unwritten_extent *ue = NULL;
+	struct ocfs2_unwritten_extent *ue = NULL, *tmp_ue;
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
-	struct ocfs2_alloc_context *data_ac = NULL;
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
-	int ret = 0, credits = 0, locked = 0;
+	int ret = 0, credits = 0, locked = 0, restart_func = 0;

 	ocfs2_init_dealloc_ctxt(&dealloc);

@@ -2330,8 +2358,9 @@ static int ocfs2_dio_end_io_write(struct inode *inode,

 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);

-	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
-				    &data_ac, &meta_ac);
+restart_all:
+	ret = ocfs2_lock_allocators(inode, &et, 0, OCFS2_MAX_REC_NEED_SPLIT,
+				    NULL, &meta_ac);
 	if (ret) {
 		mlog_errno(ret);
 		goto unlock;
@@ -2343,7 +2372,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto unlock;
+		goto free_ac;
 	}
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -2352,7 +2381,17 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 		goto commit;
 	}

-	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
+	list_for_each_entry_safe(ue, tmp_ue, &dwc->dw_zero_list, ue_node) {
+		ret = ocfs2_dio_should_restart(&et, meta_ac,
+				OCFS2_MAX_REC_NEED_SPLIT * 2);
+		if (ret < 0) {
+			mlog_errno(ret);
+			break;
+		} else if (ret == 1) {
+			restart_func = 1;
+			break;
+		}
+
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
 						ue->ue_phys,
@@ -2361,24 +2400,37 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 			mlog_errno(ret);
 			break;
 		}
+
+		dwc->dw_zero_count--;
+		list_del_init(&ue->ue_node);
+		spin_lock(&oi->ip_lock);
+		list_del_init(&ue->ue_ip_node);
+		spin_unlock(&oi->ip_lock);
+		kfree(ue);
 	}

-	if (end > i_size_read(inode)) {
+	if (!restart_func && end > i_size_read(inode)) {
 		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
 		if (ret < 0)
 			mlog_errno(ret);
 	}
+
 commit:
 	ocfs2_commit_trans(osb, handle);
+free_ac:
+	if (meta_ac) {
+		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
+	if (restart_func) {
+		restart_func = 0;
+		goto restart_all;
+	}
 unlock:
 	up_write(&oi->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	if (data_ac)
-		ocfs2_free_alloc_context(data_ac);
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
 	ocfs2_run_deallocs(osb, &dealloc);
 	if (locked)
 		inode_unlock(inode);
-- 

> 
> Our setup has 10 machines sharing two OCFS2 mountpoints over fibre
> channel.
> 
> Both OCFS2 partitions have block size bits set to 12 and cluster size
> bits set to 20.
> 
> The two partitions contain around 310 files total with 200 of those
> being qcow2 files. The only inodes getting any read and write activity
> are the qcow2 files.
> 
> The qcow2 files were created as sparse files (preallocation=metadata)
> and some are reflinked copies.
> 
> It's not clear to me exactly why it's passing through
> ocfs2_lock_allocators() without allocating meta_ac. These qcow files
> wouldn't be written concurrently by different systems in the OCFS2
> cluster.
> 
> Is it possible the 2 x multiplier in the ocfs2_lock_allocators call is
> not large enough?
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
