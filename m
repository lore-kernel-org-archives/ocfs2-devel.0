From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Thu, 27 Dec 2012 12:08:47 -0600
Subject: [Ocfs2-devel] [PATCH] Initialize unaligned I/O bit to clear
In-Reply-To: <50DBB197.7080601@oracle.com>
References: <CAJtY7HVZSF+icmBNc2cSwQdwK3EjTs0S3G4anp-HDyQNnEScCw@mail.gmail.com>
	<50DBB197.7080601@oracle.com>
Message-ID: <CAJtY7HWG5VCK-T+Gexsk5CPAzniZ1ANojjzBsJtLWEqm8XDs2Q@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On Wed, Dec 26, 2012 at 8:25 PM, Junxiao Bi <junxiao.bi@oracle.com> wrote:
> Hi Goldwyn,
>
> Not the correct way to fix this issue. The root cause of your issue is
> kiocb->private is not init well. And it had been fixed in commit
> 2dfd06036ba7ae8e7be2daf5a2fff1dac42390bf.

I agree. Thanks, this is a much better fix.

OTOH, you could remove ocfs2_iocb_clear_sem_locked() from
ocfs2_file_aio_write/read()
This will save some a couple of cycles / CPU cache operations.

>
> commit 2dfd06036ba7ae8e7be2daf5a2fff1dac42390bf
> Author: Junxiao Bi <junxiao.bi@oracle.com>
> Date:   Wed Jun 27 17:09:54 2012 +0800
>
>     aio: make kiocb->private NUll in init_sync_kiocb()
>
>     Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
>     commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
>     io flag is involved in it to serialize the unaligned aio. As
>     *private is not initialized in init_sync_kiocb() of do_sync_write(),
>     this unaligned io flag may be unexpectly set in an aligned dio.
>     And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
>     to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
>     will hang forever at ocfs2_aiodio_wait() in ocfs2_file_aio_write().
>
>     Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>     Cc: stable at vger.kernel.org
>     Acked-by: Jeff Moyer <jmoyer@redhat.com>
>     Signed-off-by: Joel Becker <jlbec@evilplan.org>
>
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index 2314ad8..b1a520e 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -140,6 +140,7 @@ struct kiocb {
>                 (x)->ki_dtor = NULL;                    \
>                 (x)->ki_obj.tsk = tsk;                  \
>                 (x)->ki_user_data = 0;                  \
> +               (x)->private = NULL;                    \
>         } while (0)
>
>  #define AIO_RING_MAGIC                 0xa10a10a1
>
> Thanks,
> Junxiao.
>
>
> On 12/27/2012 06:52 AM, Goldwyn Rodrigues wrote:
>> The fields of kiocb received in ocfs2_file_aio_write can be
>> uninitialized/non-zero. This could result in UNALIGED_AIO bit in
>> iocb->private set. This causes the oi->ip_unaligned_aio to decrement,
>> well below zero blocking future AIO.
>>
>> Clear unaligned bit to fix this.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
>>
>> ---
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 37d313e..d3bc462 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -2254,6 +2254,7 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
>>
>>       mutex_lock(&inode->i_mutex);
>>
>> +     ocfs2_iocb_clear_unaligned_aio(iocb);
>>       ocfs2_iocb_clear_sem_locked(iocb);
>>
>>  relock:
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>



-- 
Goldwyn
