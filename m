From: Tao Ma <tm@tao.ma>
Date: Tue, 08 Mar 2011 15:47:52 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Add ocfs2_trim_fs for SSD trim
 support.
In-Reply-To: <4D75D281.5000003@oracle.com>
References: <4D74AD52.4030502@tao.ma>
	<1299492356-7329-1-git-send-email-tm@tao.ma>
	<4D75B6DF.3030508@oracle.com> <4D75C468.8050707@tao.ma>
	<4D75CB69.5080908@oracle.com> <4D75CFCB.6000501@tao.ma>
	<4D75D281.5000003@oracle.com>
Message-ID: <4D75DF28.6010401@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/08/2011 02:53 PM, Tristan Ye wrote:
> Tao Ma wrote:
>> On 03/08/2011 02:23 PM, Tristan Ye wrote:
>>> Tao Ma wrote:
>>>> On 03/08/2011 12:55 PM, Tristan Ye wrote:
>>>>> Hi Tao,
>>>>>
>>>>>    Most of codes looks pretty neat to me, few comments inlined below:
>>>> Thanks for the review.
>>>>> Tao Ma wrote:
>>>>>> From: Tao Ma <boyu.mt@taobao.com>
>>>>>>
>>>>>> Add ocfs2_trim_fs to support trimming freed clusters in the
>>>>>> volume. A range will be given and all the freed clusters greater
>>>>>> than minlen will be discarded to the block layer.
>>>>>>
>>>>>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>>>>>> ---
>>>>>>  fs/ocfs2/alloc.c |  154
>>>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>  fs/ocfs2/alloc.h |    1 +
>>>>>>  2 files changed, 155 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>>>>>> index b27a0d8..6e1b3b5 100644
>>>>>> --- a/fs/ocfs2/alloc.c
>>>>>> +++ b/fs/ocfs2/alloc.c
>>>>>> @@ -29,6 +29,7 @@
>>>>>>  #include <linux/highmem.h>
>>>>>>  #include <linux/swap.h>
>>>>>>  #include <linux/quotaops.h>
>>>>>> +#include <linux/blkdev.h>
>>>>>>  
>>>>>>  #include <cluster/masklog.h>
>>>>>>  
>>>>>> @@ -7184,3 +7185,156 @@ out_commit:
>>>>>>  out:
>>>>>>      return ret;
>>>>>>  }
>>>>>> +
>>>>>> +static int ocfs2_trim_extent(struct super_block *sb,
>>>>>> +                 struct ocfs2_group_desc *gd,
>>>>>> +                 int start, int count)
>>>>>> +{
>>>>>> +    u64 discard;
>>>>>> +
>>>>>> +    count = ocfs2_clusters_to_blocks(sb, count);
>>>>>> +    discard = le64_to_cpu(gd->bg_blkno) +
>>>>>> +            ocfs2_clusters_to_blocks(sb, start);
>>>>>> +
>>>>>> +    return sb_issue_discard(sb, discard, count, GFP_NOFS, 0);
>>>>>> +}
>>>>>> +
>>>>>> +static int ocfs2_trim_group(struct super_block *sb,
>>>>>> +                struct ocfs2_group_desc *gd,
>>>>>> +                int start, int max, int minbits)
>>>>>> +{
>>>>>> +    int ret = 0, count = 0, next;
>>>>>> +    void *bitmap = gd->bg_bitmap;
>>>>>> +
>>>>>> +    while (start < max) {
>>>>>> +        start = ocfs2_find_next_zero_bit(bitmap, max, start);
>>>>>> +        if (start >= max)
>>>>>> +            break;
>>>>>    /* What if the 'start' stands within a hole */
>>>>>
>>>>>    if (ocfs2_test_bit(...)) {
>>>>>       start = ocfs2_find_next_zero_bit(...);
>>>>>       if ((start == -1) || (start >= max))
>>>>>          break;
>>>>>    }
>>>>>
>>>>>> +        next = ocfs2_find_next_bit(bitmap, max, start);
>>>>>      next = ocfs2_find_next_bit(...);
>>>>>    if (next == -1)
>>>>>       break;
>>>> next will be set to "-1"? sorry, but where do you get it?
>>>>>    if (next > max)
>>>>>       next = max;
>>>> again, ocfs2_find_next_bit will return a value larger than 'max'? I am
>>>> afraid not. Otherwise, it will be nonsense to pass a 'max' to it.
>>>
>>> Say we're handling the last group, and the 'start + len' was within a
>>> hole, then the 'max'
>>> is 'first_bit + len', while the next none-zero bit we found may be
>>> larger than 'max', isn't
>>> that possible?
>> ocfs2_find_next_bit(and ext2_find_next_bit) won't parse, check and
>> return 'bit' after 'max'. otherwise there should be a problem of memory
>> overflow(you read and check some memory which isn't owned and handled by
>> you). So the same goes here. If it can return a value larger than 'max',
>> every caller will have to check the overflow. That would be too painful.
> 
>  Oh, you may misunderstood my words, the 'max' you passed to
> ocfs2_find_next_bit()
> may not be the ending-edge of the cluster group(bitmap), it may be the
> end of what user specified
> for TRIMing, therefore the 'next'(ending-edge for a wanted hole) bit you
> found from ocfs2_find_next_bit()
> might be larger than 'max', is that possible?
Please note that ocfs2_find_next_bit knows nothing about what 'max'
means. So no matter it will be the end of the cluster group or just the
middle of a bitmap, it would return values after 'max' I think.
> 
>>>>>> +int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range
>>>>>> *range)
>>>>>> +{
>>>>>> +    struct ocfs2_super *osb = OCFS2_SB(sb);
>>>>>> +    u64 start, len, minlen, trimmed, first_group, last_group, group;
>>>>>    why not using u32 start, len, minlen, trimmed;
>>>> we may use 64 bit clusters later I guess. And what's more, they will be
>>>> set by the user later. and it may overflow. Say the user pass a u64
>>>> range->len, it will overflow with range->len >>
>>>> osb->s_clustersize_bits.
>>> I just found we were using u32 for counting clusters all around ocfs2
>>> codes, e.g truncate/punching_hole
>>> codes, also passing an u64 byte_offset from userspace, so my original
>>> intention is to keep an unification;-)
>>>
>>> Overflow can theoretically happen anyway, however, it's not very likely
>>> to pass a 16TB+ byte_offset from userspace.
>> I am afraid it is very likely. So say you want to trim all the clusters
>> within the volume, how could you set 'range->len'? Will you first fdisk
>> to get the volume size and then set it accordingly?
>> Most guys will set it to ULLONG_MAX and let the file system handles it.
>> This is not my personal view, please check this article:
>> http://lwn.net/Articles/417809/
>> Jonathan also suggests to set len to ULLONG_MAX so that you can trim the
>> whole volume.
> 
>    Nice self-defense;-), how about the overflow risk in
> truncate/punching-hole
> codes, where u32 were being used for cluster counting.
yeah, you can try and fix it.

Regards,
Tao
