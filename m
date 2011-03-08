From: Tao Ma <tm@tao.ma>
Date: Tue, 08 Mar 2011 15:53:36 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Add ocfs2_trim_fs for SSD trim
 support.
In-Reply-To: <4D75B6DF.3030508@oracle.com>
References: <4D74AD52.4030502@tao.ma>
	<1299492356-7329-1-git-send-email-tm@tao.ma>
	<4D75B6DF.3030508@oracle.com>
Message-ID: <4D75E080.4060502@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/08/2011 12:55 PM, Tristan Ye wrote:
> Hi Tao,
> 
>    Most of codes looks pretty neat to me, few comments inlined below:
> 
> Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Add ocfs2_trim_fs to support trimming freed clusters in the
>> volume. A range will be given and all the freed clusters greater
>> than minlen will be discarded to the block layer.
>>
>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>> ---
>>  fs/ocfs2/alloc.c |  154
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/ocfs2/alloc.h |    1 +
>>  2 files changed, 155 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index b27a0d8..6e1b3b5 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
<snip>
>> +static int ocfs2_trim_group(struct super_block *sb,
>> +                struct ocfs2_group_desc *gd,
>> +                int start, int max, int minbits)
>> +{
>> +    int ret = 0, count = 0, next;
>> +    void *bitmap = gd->bg_bitmap;
>> +
>> +    while (start < max) {
>> +        start = ocfs2_find_next_zero_bit(bitmap, max, start);
>> +        if (start >= max)
>> +            break;
> 
>    /* What if the 'start' stands within a hole */
> 
>    if (ocfs2_test_bit(...)) {
>       start = ocfs2_find_next_zero_bit(...);
>       if ((start == -1) || (start >= max))
>          break;
>    }
I just noticed that I forget to response to this. what do you define a
hole? It is within the global bitmap, so it is either freed or
allocated. I don't get your meaning of 'hole'. ocfs2_find_next_zero_bit
will do as we expected.

Regards,
Tao
