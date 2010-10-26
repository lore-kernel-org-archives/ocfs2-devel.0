From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 26 Oct 2010 16:54:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Try to free truncate log when
 meeting ENOSPC in write.
In-Reply-To: <4CC69133.40809@oracle.com>
References: <1288078148-6343-1-git-send-email-tao.ma@oracle.com>
	<4CC69133.40809@oracle.com>
Message-ID: <4CC6973E.2070805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 10/26/2010 04:28 PM, tristan wrote:
> Hi Tao,
>
> Just some tiny comments;)
>
> Tao Ma wrote:
>> Recently, one of our colleagues meet with a problem that if we
>> write/delete a 32mb files repeatly, we will get an ENOSPC in
>> the end. And the corresponding bug is 1288.
>> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1288
>>
>> The real problem is that although we have freed the clusters,
>> they are in truncate log and they will be summed up so that
>> we can free them once in a whole.
>>
>> So this patch just try to resolve it. In case we see -ENOSPC
>> in ocfs2_write_begin_no_lock, we will check whether the truncate
>> log has enough clusters for our need, if yes, we will try to
>> flush the truncate log at that point and try again. This method
>> is inspired by Mark Fasheh <mfasheh@suse.com>. Thanks.
>>
>> Cc: Mark Fasheh <mfasheh@suse.com>
>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>> ---
>> fs/ocfs2/alloc.c | 3 ++
>> fs/ocfs2/aops.c | 59
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>> fs/ocfs2/ocfs2.h | 2 +
>> 3 files changed, 63 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 592fae5..8ec418d 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -5858,6 +5858,7 @@ int ocfs2_truncate_log_append(struct ocfs2_super
>> *osb,
>>
>> ocfs2_journal_dirty(handle, tl_bh);
>>
>> + osb->truncated_clusters += num_clusters;
>> bail:
>> mlog_exit(status);
>> return status;
>> @@ -5929,6 +5930,8 @@ static int ocfs2_replay_truncate_records(struct
>> ocfs2_super *osb,
>> i--;
>> }
>>
>> + osb->truncated_clusters = 0;
>> +
>> bail:
>> mlog_exit(status);
>> return status;
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 5cfeee1..79adc67 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -1642,6 +1642,43 @@ static int ocfs2_zero_tail(struct inode *inode,
>> struct buffer_head *di_bh,
>> return ret;
>> }
>>
>> +/*
>> + * Try to flush truncate log if we can free enough clusters from it.
>> + * As for return value, "< 0" means error, "0" no space and "1" means
>> + * we have freed enough spaces and let the caller try to allocate again.
>> + */
>> +static int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
>> + unsigned int needed)
> why not use 'unsigned int *needed, and return the actual cluster being
> freed.
I don't think we need to return 'freed clusters' here(which indicates we 
will flush the truncate log no matter 'needed' is). what I want is that 
if we can free 'needed', just do it. If not, go 'exit' because even if 
we free some clusters, it can't fit our need and the allocation would 
still fail. 'Free some clusters' here means that we have to flush the 
truncate log and wait for the journal commit. It is a bit 
time-consuming, so why let the user wait for some time(for freeing some 
clusters in truncate log) while eventually he will get an ENOSPC?
>> +{
>> + tid_t target;
>> + int ret = 0;
>> + unsigned int truncated_clusters;
>> +
>> + mutex_lock(&osb->osb_tl_inode->i_mutex);
>> + truncated_clusters = osb->truncated_clusters;
>> + mutex_unlock(&osb->osb_tl_inode->i_mutex);
>> +
>> + /*
>> + * Check whether we can succeed in allocating if we free
>> + * the truncate log.
>> + */
>> + if (truncated_clusters < needed)
>> + goto out;
>> +
>> + ret = ocfs2_flush_truncate_log(osb);
>> + if (ret) {
>> + mlog_errno(ret);
>> + goto out;
>> + }
>> +
>> + if (jbd2_journal_start_commit(osb->journal->j_journal, &target)) {
>> + jbd2_log_wait_commit(osb->journal->j_journal, target);
>> + ret = 1;
>> + }
>> +out:
>> + return ret;
>> +}
>> +
>> int ocfs2_write_begin_nolock(struct file *filp,
>> struct address_space *mapping,
>> loff_t pos, unsigned len, unsigned flags,
>> @@ -1649,7 +1686,7 @@ int ocfs2_write_begin_nolock(struct file *filp,
>> struct buffer_head *di_bh, struct page *mmap_page)
>> {
>> int ret, cluster_of_pages, credits = OCFS2_INODE_UPDATE_CREDITS;
>> - unsigned int clusters_to_alloc, extents_to_split;
>> + unsigned int clusters_to_alloc, extents_to_split, clusters_need = 0;
>> struct ocfs2_write_ctxt *wc;
>> struct inode *inode = mapping->host;
>> struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> @@ -1658,7 +1695,9 @@ int ocfs2_write_begin_nolock(struct file *filp,
>> struct ocfs2_alloc_context *meta_ac = NULL;
>> handle_t *handle;
>> struct ocfs2_extent_tree et;
>> + int try_free = 0, ret1;
>>
>> +try_again:
>> ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, di_bh);
>> if (ret) {
>> mlog_errno(ret);
>> @@ -1693,6 +1732,7 @@ int ocfs2_write_begin_nolock(struct file *filp,
>> mlog_errno(ret);
>> goto out;
>> } else if (ret == 1) {
>> + clusters_need = wc->w_clen;
>> ret = ocfs2_refcount_cow(inode, filp, di_bh,
>> wc->w_cpos, wc->w_clen, UINT_MAX);
>> if (ret) {
>> @@ -1707,6 +1747,7 @@ int ocfs2_write_begin_nolock(struct file *filp,
>> mlog_errno(ret);
>> goto out;
>> }
>> + clusters_need += clusters_to_alloc;
>>
>> di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
>>
>> @@ -1829,6 +1870,22 @@ out:
>> ocfs2_free_alloc_context(data_ac);
>> if (meta_ac)
>> ocfs2_free_alloc_context(meta_ac);
>> +
>> + if (ret == -ENOSPC && !try_free) {
> Literally, if (ret == -ENOSPC && try_free) make more sense here for a
> better readability;-)
>
> You can set the try_free with a fixed value at the very beginning, which
> in other words, means set the
> retry times we're allowing to perform after the allocation failure.
Is it really needed for the user to try several times? I am not sure. 
Yes, we can try several times, but if the first try doesn't work, do you 
think we can have another chance that some other process just happen to 
truncate and fill in the truncate log for us between 2 tries?

If yes, it is hard for us to tell how many times is appropriate to try. 
If the system is in this stage(nearly full and needs a truncate log 
flush to allocate clusters), I guess the right step is let the user know 
-ENOSPC does happen(if flush truncate log doesn't help either) and do 
something instead.

Regards,
Tao
