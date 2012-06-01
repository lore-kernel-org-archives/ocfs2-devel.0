From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 01 Jun 2012 09:41:52 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] aio: make kiocb->private NUll in
	init_sync_kiocb()
In-Reply-To: <x49k3zscuk2.fsf@segfault.boston.devel.redhat.com>
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
	<x49k3zscuk2.fsf@segfault.boston.devel.redhat.com>
Message-ID: <4FC81DE0.5080403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, joe.jin@oracle.com

On 05/31/2012 10:08 PM, Jeff Moyer wrote:
> Junxiao Bi <junxiao.bi@oracle.com> writes:
>
>> Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
>> commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
>> io flag is involved in it to serialize the unaligned aio. As
>> *private is not initialized in init_sync_kiocb() of do_sync_write(),
>> this unaligned io flag may be unexpectly set in an aligned dio.
>> And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
>> to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
>> will hang forever at ocfs2_aiodio_wait() in ocfs2_file_write_iter().
>> We can't initialized this flag in ocfs2_file_write_iter() since
>> it may be invoked several times by do_sync_write(). So we initialize
>> it in init_sync_kiocb(), it's also useful for other similiar use of
>> it in the future.
> I don't see any ocfs2_file_write_iter in the upstream kernel.
> ocfs2_file_aio_write most certainly could set ->private to 0, it
> will only be called once for a given kiocb.
From sys_io_submit->..->io_submit_one->aio_run_iocb->aio_rw_vect_retry, 
it seems that aio_write could be called two times. See the following
scenario.
1. There is a file opened with direct io flag, in aio_rw_vect_retry,
aio_write is called first time. If the direct io can
not be completed, it will fall back into buffer io, see line 2329 in
aio_write.
2. If the very buffer io is a partial write, then it will return back
to  aio_rw_vect_retry and issue the second aio_write.
>
> That point aside, I have no issues with setting private to NULL in
> init_sync_kiocb.  If you fix up the comment to reflect reality
> w.r.t. the upstream kernel source, I'll ack the patch.
OK, I will fix the comment.
>
> Cheers,
> Jeff
