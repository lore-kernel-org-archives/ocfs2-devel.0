From: tristan <tristan.ye@oracle.com>
Date: Thu, 28 Jan 2010 09:28:44 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Change
 ocfs2_prepare_refcount_change_for_del() a bit to defer blocks reservation.
In-Reply-To: <4B60BB4A.3030008@oracle.com>
References: <1264591326-24591-1-git-send-email-tristan.ye@oracle.com>
	<1264591326-24591-2-git-send-email-tristan.ye@oracle.com>
	<4B60BB4A.3030008@oracle.com>
Message-ID: <4B60E84C.6060800@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

TaoMa wrote:
> Hi Tristan,
>    you'd better integrate this patch with patch 3/3. otherwise we 
> can't build successfully if we apply this one and don't apply the next 
> one(in some git bisect case).

Yes I see, here I just split the patches as small as possible to be 
logically separate,  for the convenience of your reviewing:)

I'll merge 2 and 3 definitely in final series, thanks for the reminding.


>
> Regards,
> Tao
> Tristan Ye wrote:
>> As ocfs2_prepare_refcount_change_for_del() only called from 
>> ocfs2_commit_truncate for
>> now(punching holes are going to use that soon I guess), we're safe to 
>> defer metadata
>> blocks reservation unitl ocfs2_remove_btree_range(), who is also 
>> reserving blocks for
>> extent btree adjusting, so it will be nice to do these in one go.
>>
>> Instead, it will return the blocks calculated to caller, to let him 
>> know how many extra
>> blocks for refcount tree should be reserved next.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>> ---
>>  fs/ocfs2/refcounttree.c |   21 +++++++--------------
>>  fs/ocfs2/refcounttree.h |    2 +-
>>  2 files changed, 8 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>> index 60287fc..42a8446 100644
>> --- a/fs/ocfs2/refcounttree.c
>> +++ b/fs/ocfs2/refcounttree.c
>> @@ -2432,8 +2432,8 @@ out:
>>   *
>>   * Normally the refcount blocks store these refcount should be
>>   * continguous also, so that we can get the number easily.
>> - * As for meta_ac, we will at most add split 2 refcount record and
>> - * 2 more refcount block, so just check it in a rough way.
>> + * We will at most add split 2 refcount records and 2 more
>> + * refcount block, so just check it in a rough way.
>>   *
>>   * Caller must hold refcount tree lock.
>>   */
>> @@ -2442,9 +2442,9 @@ int 
>> ocfs2_prepare_refcount_change_for_del(struct inode *inode,
>>                        u64 phys_blkno,
>>                        u32 clusters,
>>                        int *credits,
>> -                      struct ocfs2_alloc_context **meta_ac)
>> +                      int *ref_blocks)
>>  {
>> -    int ret, ref_blocks = 0;
>> +    int ret;
>>      struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>>      struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>      struct buffer_head *ref_root_bh = NULL;
>> @@ -2480,21 +2480,14 @@ int 
>> ocfs2_prepare_refcount_change_for_del(struct inode *inode,
>>                             &tree->rf_ci,
>>                             ref_root_bh,
>>                             start_cpos, clusters,
>> -                           &ref_blocks, credits);
>> +                           ref_blocks, credits);
>>      if (ret) {
>>          mlog_errno(ret);
>>          goto out;
>>      }
>>  
>> -    mlog(0, "reserve new metadata %d, credits = %d\n",
>> -         ref_blocks, *credits);
>> -
>> -    if (ref_blocks) {
>> -        ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
>> -                            ref_blocks, meta_ac);
>> -        if (ret)
>> -            mlog_errno(ret);
>> -    }
>> +    mlog(0, "reserve new metadata %d blocks, credits = %d\n",
>> +         *ref_blocks, *credits);
>>  
>>  out:
>>      brelse(ref_root_bh);
>> diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
>> index c1d19b1..f4bf110 100644
>> --- a/fs/ocfs2/refcounttree.h
>> +++ b/fs/ocfs2/refcounttree.h
>> @@ -51,7 +51,7 @@ int ocfs2_prepare_refcount_change_for_del(struct 
>> inode *inode,
>>                        u64 phys_blkno,
>>                        u32 clusters,
>>                        int *credits,
>> -                      struct ocfs2_alloc_context **meta_ac);
>> +                      int *ref_blocks);
>>  int ocfs2_refcount_cow(struct inode *inode, struct buffer_head *di_bh,
>>                 u32 cpos, u32 write_len, u32 max_cpos);
>>  
>>   
>
