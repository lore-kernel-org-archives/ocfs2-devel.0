From: tristan <tristan.ye@oracle.com>
Date: Tue, 02 Feb 2010 09:32:26 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Optimize truncting codes for
 ocfs2 to use ocfs2_remove_btree_range instead.
In-Reply-To: <4B67539E.5060201@oracle.com>
References: <1265020173-14623-1-git-send-email-tristan.ye@oracle.com>
	<4B67539E.5060201@oracle.com>
Message-ID: <4B6780AA.2070701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

TaoMa wrote:
> Hi Tristan,
> Tristan Ye wrote:
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>> ---
>>  fs/ocfs2/alloc.c        |  695 
>> +++++++++++------------------------------------
>>  fs/ocfs2/alloc.h        |    6 +-
>>  fs/ocfs2/dir.c          |    2 +-
>>  fs/ocfs2/file.c         |   11 +-
>>  fs/ocfs2/inode.c        |    9 +-
>>  fs/ocfs2/refcounttree.c |   29 +--
>>  fs/ocfs2/refcounttree.h |    4 +-
>>  7 files changed, 177 insertions(+), 579 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 38a42f5..bad3feb 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -5670,19 +5670,97 @@ out:
>>      return ret;
>>  }
>>  
>>   
> <snip>
>> +static int ocfs2_reserve_blocks_for_rec_trunc(struct inode *inode,
>> +                          struct ocfs2_extent_tree *et,
>> +                          u32 extents_to_split,
>> +                          struct ocfs2_alloc_context **ac,
>> +                          int extra_blocks)
>> +{
>> +    int ret = 0, num_free_extents, blocks = extra_blocks;
>> +    unsigned int max_recs_needed = 2 * extents_to_split;
>> +    struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +
>> +    *ac = NULL;
>> +
>> +    num_free_extents = ocfs2_num_free_extents(osb, et);
>> +    if (num_free_extents < 0) {
>> +        ret = num_free_extents;
>> +        mlog_errno(ret);
>> +        goto out;
>> +    }
>> +
>> +    if (!num_free_extents ||
>> +        (ocfs2_sparse_alloc(osb) && num_free_extents < 
>> max_recs_needed))
>> +        blocks += ocfs2_extend_meta_needed(et->et_root_el);
>> +
>> +    if (!blocks) {
>> +        ret = ocfs2_reserve_new_metadata_blocks(osb, blocks, ac);
>>   
> Oh, this is a bug. I just wonder why I didn't find it earlier. Sorry.
> the check condition should be
>    if (blocks) {

Exactly, that's my fault.  a stupid bug...



>
> So do please run some stress test on these 2 patches.

 You're right, testcases against these 2 patches were not comprehensive 
enough to expose some stupid bug like above, I'll try some tests with 
heavier workload.

Thanks, tao

>
> Regards,
> Tao
