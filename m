From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 14 Apr 2010 08:13:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered
In-Reply-To: <20100413235434.GA5530@mail.oracle.com>
References: <4BC0B776020000460001DCCA@novprvlin0050.provo.novell.com>
	<4BC2ACBB.80909@oracle.com> <20100413235434.GA5530@mail.oracle.com>
Message-ID: <4BC508A3.4070104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Mon, Apr 12, 2010 at 01:16:43PM +0800, Tao Ma wrote:
>   
>> Dong Yang Li wrote:
>>     
>>> I still get a bug with this check and without my patch:
>>>       
>> yes, the check doesn't work actually in this case.
>>     
>>> [16179.955148] (13400,1):ocfs2_truncate_file:465 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
>>> [16179.955157] (13400,1):ocfs2_truncate_file:465 ERROR: Inode 254789, inode i_size = 811008 != di i_size = 809011, i_flags = 0x1
>>> the call trace is the same.
>>>
>>>
>>> the problem is this check in ocfs2_direct_IO_get_blocks just check if we are going beyond the blocks right now,
>>> so if a direct write won't play with new blocks but extending the i_size still get a pass, like the error above said, di->i_size is 809011, using 198 blocks and the direct write end up with i_size 811008, just same 198 blocks.
>>>       
>> yeah, you are right.
>>     
>
> 	I think Sunil and I have found the real culprit.
> 	If a file is opened for O_DIRECT, and there are no holes,
> refcounts or anything, we are doing direct I/O.  ocfs2_file_aio_write()
> (o_f_a_w() from now on) locks things down like so:  lock(i_mutex),
> down_read(ip_alloc_sem), PR(rw_lock).  We have ip_alloc_sem preventing
> size changes on the local node and rw_lock preventing size changes on
> other nodes.  We call generic_file_direct_write() ourselves.
> 	If a file is not opened with O_DIRECT, we are doing regular
> buffered writes.  o_f_a_w() locks like so: lock(i_mutex),
> EX(rw_lock).  It is protecting against other nodes, but it does not
> touch ip_alloc_sem.  Why?  Because we call __generic_file_aio_write(),
> which will call ->write_begin().  ip_alloc_sem will be taken inside
> ->write_begin().  That's where we protect against other local processes.  
> 	You may already see where I'm going with this.  If we are open
> with O_DIRECT, but we have to fall back to buffered, we will do this
> locking:  lock(i_mutex), down_read(ip_alloc_sem), PR(rw_lock),
> NL(rw_lock), up_read(ip_alloc_sem), EX(rw_lock).  That is, we start with
> the direct I/O locking, then back off and do the buffered locking.  But
> when we get into __g_f_a_w(), it will try the direct I/O again.  If the
> leading portion of the I/O is capable of direct I/O, it will go into
> direct mode *without ever taking ip_alloc_sem*.  Once it gets to the
> portion of the I/O that cannot be done direct, it will fall back to
> buffered for the rest of the I/O and will call ->write_begin() as
> expected.
> 	So this I/O that extends i_size to the end of the allocation
> will proceed as a direct I/O but will not have ip_alloc_sem.  Thus
> truncate (and any other allocation change) can race on the local
> machine.
> 	I think some form of Dong Yang's patch is going to be necessary.
>   
oh, yes, your analysis make sense.
But that doesn't prove that my get_block suggestion doesn't work in this 
case.
If we can find this situation in ocfs2_direct_IO_get_blocks and 
clear_buffer_mapped. It should fall
back to buffer_write for the last block and update i_size properly.
Actually, the check should be easy.
sb->s_blocksize * (iblocks+contig_blocks)>inode->i_size.

In this way, we should have to fall to buffer write only necessarily.

Regards,
Tao

Regards,
Tao
> Joel
>
>   
