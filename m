From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Sat, 02 Jun 2012 10:59:05 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] aio: make kiocb->private NUll in
	init_sync_kiocb()
In-Reply-To: <x49r4ty69bw.fsf@segfault.boston.devel.redhat.com>
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
	<x49k3zscuk2.fsf@segfault.boston.devel.redhat.com>
	<4FC81DE0.5080403@oracle.com>
	<x49r4ty69bw.fsf@segfault.boston.devel.redhat.com>
Message-ID: <4FC98179.4000400@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, joe.jin@oracle.com

On 06/02/2012 04:55 AM, Jeff Moyer wrote:
> Junxiao Bi<junxiao.bi@oracle.com>  writes:
>
>> On 05/31/2012 10:08 PM, Jeff Moyer wrote:
>>> Junxiao Bi<junxiao.bi@oracle.com>  writes:
>>>
>>>> Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
>>>> commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
>>>> io flag is involved in it to serialize the unaligned aio. As
>>>> *private is not initialized in init_sync_kiocb() of do_sync_write(),
>>>> this unaligned io flag may be unexpectly set in an aligned dio.
>>>> And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
>>>> to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
>>>> will hang forever at ocfs2_aiodio_wait() in ocfs2_file_write_iter().
>>>> We can't initialized this flag in ocfs2_file_write_iter() since
>>>> it may be invoked several times by do_sync_write(). So we initialize
>>>> it in init_sync_kiocb(), it's also useful for other similiar use of
>>>> it in the future.
>>> I don't see any ocfs2_file_write_iter in the upstream kernel.
>>> ocfs2_file_aio_write most certainly could set ->private to 0, it
>>> will only be called once for a given kiocb.
>>  From sys_io_submit->..->io_submit_one->aio_run_iocb->aio_rw_vect_retry,
>> it seems that aio_write could be called two times. See the following
>> scenario.
>> 1. There is a file opened with direct io flag, in aio_rw_vect_retry,
>> aio_write is called first time. If the direct io can
>> not be completed, it will fall back into buffer io, see line 2329 in
>> aio_write.
> Huh?  What's line 2329 in aio_write?
See the following code.

2312         can_do_direct = direct_io;
2313         ret = ocfs2_prepare_inode_for_write(file, ppos,
2314                                             iocb->ki_left, appending,
2315 &can_do_direct, &has_refcount);
2316         if (ret < 0) {
2317                 mlog_errno(ret);
2318                 goto out;
2319         }
2320
2321         if (direct_io && !is_sync_kiocb(iocb))
2322                 unaligned_dio = ocfs2_is_io_unaligned(inode, 
iocb->ki_left,
2323                                                       *ppos);
2324
2325         /*
2326          * We can't complete the direct I/O as requested, fall back to
2327          * buffered I/O.
2328          */
2329         if (direct_io && !can_do_direct) {
2330                 ocfs2_rw_unlock(inode, rw_level);
2331
2332                 have_alloc_sem = 0;
2333                 rw_level = -1;
2334
2335                 direct_io = 0;
2336                 goto relock;
2337         }

The above is the source code how direct io falled back to buffer io. In 
line 2313, in function ocfs2_prepare_inode_for_write(), it will judge 
whether the direct io can be executed. If not, the variable 
"can_do_direct" will be set to false, then the variable "direct_io" will 
be set to 0 in line 2335. This means that generic_file_buffered_write() 
will be called in the following code, not generic_file_direct_write(), 
see the following code. So if the generic_file_buffered_write() is a 
partial write, then its return value "written" will be made as the 
return value of the aio_write, see line 2439. Then it return back to 
aio_rw_vect_retry(), the condition (ret > 0 && iocb->ki_left > 0 && 
opcode == IOCB_CMD_PWRITEV) is true. Then aio_write will be called 
second time. As the unaligned I/O flag may be set in the kiocb at the 
first time call of aio_write, it may affect the second call of aio_write 
if its direct IO is aligned.

2372         if (direct_io) {
2373                 written = generic_file_direct_write(iocb, iov, 
&nr_segs, *ppos,
2374                                                     ppos, count, 
ocount);
2375                 if (written < 0) {
2376                         ret = written;
2377                         goto out_dio;
2378                 }
2379         } else {
2380                 current->backing_dev_info = 
file->f_mapping->backing_dev_info;
2381                 written = generic_file_buffered_write(iocb, iov, 
nr_segs, *ppos,
2382                                                       ppos, count, 0);
2383                 current->backing_dev_info = NULL;
2384         }

2438         if (written)
2439                 ret = written;
2440         return ret;
>
>> 2. If the very buffer io is a partial write, then it will return back
>> to  aio_rw_vect_retry and issue the second aio_write.
> For the generic case, the fallback to buffered I/O happens in
> __generic_file_aio_write, without bouncing all the way back up the call
> stack to aio_rw_vect_retry.  I see in ocfs2, things are a bit different:
>
> retry->aio_rw_vect_retry->ocfs2_file_aio_write->generic_file_direct_write
>    ->ocfs2_direct_IO->__blockdev_direct_IO
>
> That last function can return 0 if not all of the data was written via
> direct I/O.  At that point, you return all of the way up the chain to
> aio_rw_vect_retry, which checks the return value (ret).  If it was 0,
> then it goes ahead and retries the complete I/O.  How does that make any
> progress?!
>
> Cheers,
> Jeff
