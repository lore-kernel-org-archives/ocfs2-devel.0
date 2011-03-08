From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 08 Mar 2011 14:23:37 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Add ocfs2_trim_fs for SSD trim
 support.
In-Reply-To: <4D75C468.8050707@tao.ma>
References: <4D74AD52.4030502@tao.ma>
	<1299492356-7329-1-git-send-email-tm@tao.ma>
	<4D75B6DF.3030508@oracle.com> <4D75C468.8050707@tao.ma>
Message-ID: <4D75CB69.5080908@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> On 03/08/2011 12:55 PM, Tristan Ye wrote:
>> Hi Tao,
>>
>>    Most of codes looks pretty neat to me, few comments inlined below:
> Thanks for the review.
>> Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> Add ocfs2_trim_fs to support trimming freed clusters in the
>>> volume. A range will be given and all the freed clusters greater
>>> than minlen will be discarded to the block layer.
>>>
>>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>>> ---
>>>  fs/ocfs2/alloc.c |  154
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  fs/ocfs2/alloc.h |    1 +
>>>  2 files changed, 155 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>>> index b27a0d8..6e1b3b5 100644
>>> --- a/fs/ocfs2/alloc.c
>>> +++ b/fs/ocfs2/alloc.c
>>> @@ -29,6 +29,7 @@
>>>  #include <linux/highmem.h>
>>>  #include <linux/swap.h>
>>>  #include <linux/quotaops.h>
>>> +#include <linux/blkdev.h>
>>>  
>>>  #include <cluster/masklog.h>
>>>  
>>> @@ -7184,3 +7185,156 @@ out_commit:
>>>  out:
>>>      return ret;
>>>  }
>>> +
>>> +static int ocfs2_trim_extent(struct super_block *sb,
>>> +                 struct ocfs2_group_desc *gd,
>>> +                 int start, int count)
>>> +{
>>> +    u64 discard;
>>> +
>>> +    count = ocfs2_clusters_to_blocks(sb, count);
>>> +    discard = le64_to_cpu(gd->bg_blkno) +
>>> +            ocfs2_clusters_to_blocks(sb, start);
>>> +
>>> +    return sb_issue_discard(sb, discard, count, GFP_NOFS, 0);
>>> +}
>>> +
>>> +static int ocfs2_trim_group(struct super_block *sb,
>>> +                struct ocfs2_group_desc *gd,
>>> +                int start, int max, int minbits)
>>> +{
>>> +    int ret = 0, count = 0, next;
>>> +    void *bitmap = gd->bg_bitmap;
>>> +
>>> +    while (start < max) {
>>> +        start = ocfs2_find_next_zero_bit(bitmap, max, start);
>>> +        if (start >= max)
>>> +            break;
>>    /* What if the 'start' stands within a hole */
>>
>>    if (ocfs2_test_bit(...)) {
>>       start = ocfs2_find_next_zero_bit(...);
>>       if ((start == -1) || (start >= max))
>>          break;
>>    }
>>
>>> +        next = ocfs2_find_next_bit(bitmap, max, start);
>>      next = ocfs2_find_next_bit(...);
>>    if (next == -1)
>>       break;
> next will be set to "-1"? sorry, but where do you get it?
>>    if (next > max)
>>       next = max;
> again, ocfs2_find_next_bit will return a value larger than 'max'? I am
> afraid not. Otherwise, it will be nonsense to pass a 'max' to it.


Say we're handling the last group, and the 'start + len' was within a 
hole, then the 'max'
is 'first_bit + len', while the next none-zero bit we found may be 
larger than 'max', isn't
that possible?



>>  
>>> +
>>> +        if ((next - start) >= minbits) {
>>> +            ret = ocfs2_trim_extent(sb, gd,
>>> +                        start, next - start);
>>> +            if (ret < 0) {
>>> +                mlog_errno(ret);
>>> +                break;
>>> +            }
>>> +            count += next - start;
>>> +        }
>>> +        start = next + 1;
>>> +
>>> +        if (fatal_signal_pending(current)) {
>>> +            count = -ERESTARTSYS;
>>> +            break;
>>> +        }
>>> +
>>> +        if ((le16_to_cpu(gd->bg_free_bits_count) - count) < minbits)
>>> +            break;
>>> +    }
>>> +
>>> +    if (ret < 0)
>>> +        count = ret;
>>> +
>>> +    return count;
>>> +}
>>> +
>>> +int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
>>> +{
>>> +    struct ocfs2_super *osb = OCFS2_SB(sb);
>>> +    u64 start, len, minlen, trimmed, first_group, last_group, group;
>>    why not using u32 start, len, minlen, trimmed;
> we may use 64 bit clusters later I guess. And what's more, they will be
> set by the user later. and it may overflow. Say the user pass a u64
> range->len, it will overflow with range->len >> osb->s_clustersize_bits.

I just found we were using u32 for counting clusters all around ocfs2 
codes, e.g truncate/punching_hole
codes, also passing an u64 byte_offset from userspace, so my original 
intention is to keep an unification;-)

Overflow can theoretically happen anyway, however, it's not very likely 
to pass a 16TB+ byte_offset from userspace.

>>> +    int ret, cnt, first_bit, last_bit;
>>> +    struct buffer_head *main_bm_bh = NULL;
>>> +    struct inode *main_bm_inode = NULL;
>>> +    struct buffer_head *gd_bh = NULL;
>>> +    struct ocfs2_dinode *main_bm;
>>> +    struct ocfs2_group_desc *gd = NULL;
>>> +
>>> +    if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
>>> +        return -EROFS;
>>> +
>>> +    start = range->start >> osb->s_clustersize_bits;
>>> +    len = range->len >> osb->s_clustersize_bits;
>>> +    minlen = range->minlen >> osb->s_clustersize_bits;
>>    I guess you may want to count two corner clusters which cover the
>> 'start' and 'end' bytes,
>> so the appropriate way might be:
>>
>>    start = range->start >> osb->s_clustersize_bits;
>>    len = ocfs2_clusters_for_bytes(osb->sb, range->start  + range->len);
>>    len -= start;
> No, I don't want that.. Just want to make it the same as what ext4 did.
> See ext4_trim_fs for more details.

    All right;-)

>>  
>>> +    trimmed = 0;
>>> +
>>> +    if (!len || !minlen || minlen >= osb->bitmap_cpg)
>>    'minlen == 0' looks acceptable, which means we allowing discarding
>> for all size of extents.
>> and what's more, 'len == 0' may not be harmful enough to issue a
>> 'EINVAL', returning a legal '0'
>> to userspace immediately is fine.
> Fair enough. I will change it. Thanks.
>>
>>> +        return -EINVAL;
>>> +
>>> +    main_bm_inode = ocfs2_get_system_file_inode(osb,
>>> +                            GLOBAL_BITMAP_SYSTEM_INODE,
>>> +                            OCFS2_INVALID_SLOT);
>>> +    if (!main_bm_inode) {
>>> +        ret = -EIO;
>>> +        mlog_errno(ret);
>>> +        goto out;
>>> +    }
>>> +
>>> +    mutex_lock(&main_bm_inode->i_mutex);
>>> +
>>> +    ret = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 0);
>>> +    if (ret < 0) {
>>> +        mlog_errno(ret);
>>> +        goto out_mutex;
>>> +    }
>>> +    main_bm = (struct ocfs2_dinode *)main_bm_bh->b_data;
>>> +
>>> +    if (start >= le32_to_cpu(main_bm->i_clusters)) {
>>> +        ret = -EINVAL;
>>> +        mlog_errno(ret);
>>> +        goto out_unlock;
>>> +    }
>>> +
>>> +    if (start + len > le32_to_cpu(main_bm->i_clusters))
>>> +        len = le32_to_cpu(main_bm->i_clusters) - start;
>>> +
>>> +    /* Determine first and last group to examine based on start and
>>> len */
>>> +    first_group = ocfs2_which_cluster_group(main_bm_inode, start);
>>> +    if (first_group == osb->first_cluster_group_blkno)
>>> +        first_bit = start;
>>> +    else
>>> +        first_bit = start - ocfs2_blocks_to_clusters(sb, first_group);
>>> +    last_group = ocfs2_which_cluster_group(main_bm_inode, start + len
>>> - 1);
>>> +    last_bit = osb->bitmap_cpg;
>>> +
>>> +    for (group = first_group; group <= last_group;) {
>>> +        if (first_bit + len >= osb->bitmap_cpg)
>>> +            last_bit = osb->bitmap_cpg - first_bit;
>>    is 'first_bit' and 'last_bit' both represent a local offset within a
>> cluster group?
>> just wondering why last_bit wasn't equal to 'osb->bitmap_cpg' in above
>> case(I meant the case
>> of 'first_bit + len >= osb->bitmap_cpg'
>>
>>> +        else
>>> +            last_bit = start + len;
>>    why above case is not 'last_bit = first_bit + len';
> you are right.  Thanks.
>
> Regards,
> Tao
