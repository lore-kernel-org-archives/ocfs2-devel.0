From: Jeff Moyer <jmoyer@redhat.com>
Date: Fri, 01 Jun 2012 16:55:31 -0400
Subject: [Ocfs2-devel] [PATCH 1/2] aio: make kiocb->private NUll in
	init_sync_kiocb()
In-Reply-To: <4FC81DE0.5080403@oracle.com> (Junxiao Bi's message of "Fri, 01
	Jun 2012 09:41:52 +0800")
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
	<x49k3zscuk2.fsf@segfault.boston.devel.redhat.com>
	<4FC81DE0.5080403@oracle.com>
Message-ID: <x49r4ty69bw.fsf@segfault.boston.devel.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, joe.jin@oracle.com

Junxiao Bi <junxiao.bi@oracle.com> writes:

> On 05/31/2012 10:08 PM, Jeff Moyer wrote:
>> Junxiao Bi <junxiao.bi@oracle.com> writes:
>>
>>> Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
>>> commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
>>> io flag is involved in it to serialize the unaligned aio. As
>>> *private is not initialized in init_sync_kiocb() of do_sync_write(),
>>> this unaligned io flag may be unexpectly set in an aligned dio.
>>> And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
>>> to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
>>> will hang forever at ocfs2_aiodio_wait() in ocfs2_file_write_iter().
>>> We can't initialized this flag in ocfs2_file_write_iter() since
>>> it may be invoked several times by do_sync_write(). So we initialize
>>> it in init_sync_kiocb(), it's also useful for other similiar use of
>>> it in the future.
>> I don't see any ocfs2_file_write_iter in the upstream kernel.
>> ocfs2_file_aio_write most certainly could set ->private to 0, it
>> will only be called once for a given kiocb.
> From sys_io_submit->..->io_submit_one->aio_run_iocb->aio_rw_vect_retry, 
> it seems that aio_write could be called two times. See the following
> scenario.
> 1. There is a file opened with direct io flag, in aio_rw_vect_retry,
> aio_write is called first time. If the direct io can
> not be completed, it will fall back into buffer io, see line 2329 in
> aio_write.

Huh?  What's line 2329 in aio_write?

> 2. If the very buffer io is a partial write, then it will return back
> to  aio_rw_vect_retry and issue the second aio_write.

For the generic case, the fallback to buffered I/O happens in
__generic_file_aio_write, without bouncing all the way back up the call
stack to aio_rw_vect_retry.  I see in ocfs2, things are a bit different:

retry->aio_rw_vect_retry->ocfs2_file_aio_write->generic_file_direct_write
  ->ocfs2_direct_IO->__blockdev_direct_IO

That last function can return 0 if not all of the data was written via
direct I/O.  At that point, you return all of the way up the chain to
aio_rw_vect_retry, which checks the return value (ret).  If it was 0,
then it goes ahead and retries the complete I/O.  How does that make any
progress?!

Cheers,
Jeff
