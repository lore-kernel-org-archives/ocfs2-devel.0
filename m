From: Jeff Moyer <jmoyer@redhat.com>
Date: Thu, 31 May 2012 10:08:13 -0400
Subject: [Ocfs2-devel] [PATCH 1/2] aio: make kiocb->private NUll in
	init_sync_kiocb()
In-Reply-To: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
	(Junxiao Bi's message of "Thu, 31 May 2012 12:12:29 +0800")
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <x49k3zscuk2.fsf@segfault.boston.devel.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, joe.jin@oracle.com

Junxiao Bi <junxiao.bi@oracle.com> writes:

> Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
> commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
> io flag is involved in it to serialize the unaligned aio. As
> *private is not initialized in init_sync_kiocb() of do_sync_write(),
> this unaligned io flag may be unexpectly set in an aligned dio.
> And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
> to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
> will hang forever at ocfs2_aiodio_wait() in ocfs2_file_write_iter().

> We can't initialized this flag in ocfs2_file_write_iter() since
> it may be invoked several times by do_sync_write(). So we initialize
> it in init_sync_kiocb(), it's also useful for other similiar use of
> it in the future.

I don't see any ocfs2_file_write_iter in the upstream kernel.
ocfs2_file_aio_write most certainly could set ->private to 0, it
will only be called once for a given kiocb.

That point aside, I have no issues with setting private to NULL in
init_sync_kiocb.  If you fix up the comment to reflect reality
w.r.t. the upstream kernel source, I'll ack the patch.

Cheers,
Jeff
