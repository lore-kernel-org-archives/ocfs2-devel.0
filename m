From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 14 Apr 2010 14:08:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered
In-Reply-To: <201004141347.15600.lidongyang@novell.com>
References: <4BC0B776020000460001DCCA@novprvlin0050.provo.novell.com>
	<4BC2BC9B.30804@oracle.com> <4BC52C08.4080001@oracle.com>
	<201004141347.15600.lidongyang@novell.com>
Message-ID: <4BC55BED.3060809@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Dongyang,

Li Dongyang wrote:
> Hi, Tao
> On Wednesday 14 April 2010 10:44:24 Tao Ma wrote:
>> Hi Dongyang,
>>
>> Tao Ma wrote:
>>> Li Dongyang wrote:
>>>> Hi, Tao
>>>>
>>>> On Monday 12 April 2010 13:16:43 Tao Ma wrote:
>>>>> Hi dong yang,
>>>>>
>>>>> Dong Yang Li wrote:
>>>>>> I still get a bug with this check and without my patch:
>>>>> yes, the check doesn't work actually in this case.
>>>>>
>>>>>> [16179.955148] (13400,1):ocfs2_truncate_file:465 ERROR: bug
>>>>>> expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
>>>>>> [16179.955157]
>>>>>> (13400,1):ocfs2_truncate_file:465 ERROR: Inode 254789, inode i_size =
>>>>>> 811008 != di i_size = 809011, i_flags = 0x1 the call trace is the
>>>>>> same.
>>>>>>
>>>>>>
>>>>>> the problem is this check in ocfs2_direct_IO_get_blocks just check if
>>>>>> we are going beyond the blocks right now, so if a direct write won't
>>>>>> play with new blocks but extending the i_size still get a pass, like
>>>>>> the error above said, di->i_size is 809011, using 198 blocks and the
>>>>>> direct write end up with i_size 811008, just same 198 blocks.
>>>>> yeah, you are right.
>>>> Thanks for the script,
>>>> and a stupid question: why we still try to call __generic_file_aio_write
>>>> and let it try direct write first in ocfs2_file_aio_write even we
>>>> decided we could not do the direct write?
> yes, I also concerned about the i_alloc_sem, that's why I asked the question above.
> and I think we can remove the check in ocfs2_direct_IO_get_blocks, as it does not work.
> and your suggestion sb->s_blocksize * (iblocks+contig_blocks)>inode->i_size will give -EIO
> to those good direct writes which are not going beyond i_size but also played with
> the last partial block. e.g. an inode allocated with 4 blocks and i_size is 3 * 4096 + 2000
> and we wanna do a direct io with pos=0 and length=3 * 4096 + 1000, as we are at block level in
> o_d_I_g_b().
No, I don't mean to return -EIO. My old thought is that we can just 
clear_buffer_mapped like a hole and return 0, and then let buffer_write 
to do it. Maybe I said it somehow misleading.

Regards,
Tao
