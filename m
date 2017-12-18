From: Gang He <ghe@suse.com>
Date: Sun, 17 Dec 2017 22:30:04 -0700
Subject: [Ocfs2-devel] [patch 11/11] ocfs2: nowait aio support
In-Reply-To: <5A34DB5D.7020800@huawei.com>
References: <5a20852b.Suoho2jIQTKYp+nU%akpm@linux-foundation.org>
	<5A34DB5D.7020800@huawei.com>
Message-ID: <5A37C2DC020000F90009EF81@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com




>>> 
> Hi Gang,
> 
> On 2017/12/1 6:24, akpm at linux-foundation.org wrote:
>> From: Gang He <ghe@suse.com>
>> Subject: ocfs2: nowait aio support
>> 
>> Return EAGAIN if any of the following checks fail for direct I/O:
>> 
>> - Cannot get the related locks immediately
>> 
>> - Blocks are not allocated at the write location, it will trigger
>>   block allocation and block IO operations.
>> 
>> [ghe at suse.com: v2]
>>   Link: 
> https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_151194 
> 4612-2D9629-2D4-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8P
> Zh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=03axuTG8C
> 4n44K1VY4yCWSg99FrknrLMs6_MlBfcfZU&s=bPQ5h9lbd8EtCwlBcfN_UJx6O1Fr6JiZUO7Ak2Igd
> ds&e=
>> Link: 
> https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_151177 
> 5987-2D841-2D4-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZ
> h8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=03axuTG8C4
> n44K1VY4yCWSg99FrknrLMs6_MlBfcfZU&s=TX3FDWVXDkrHLxSD3HW3GW5igY6jogyX7Sf-OB5WrYk&
> e=
>> Signed-off-by: Gang He <ghe@suse.com>
>> Cc: Mark Fasheh <mfasheh@versity.com>
>> Cc: Joel Becker <jlbec@evilplan.org>
>> Cc: Junxiao Bi <junxiao.bi@oracle.com>
>> Cc: Joseph Qi <jiangqi903@gmail.com>
>> Cc: Changwei Ge <ge.changwei@h3c.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>> 
>>  fs/ocfs2/dir.c         |    2 
>>  fs/ocfs2/dlmglue.c     |   20 ++++++--
>>  fs/ocfs2/dlmglue.h     |    2 
>>  fs/ocfs2/file.c        |   95 ++++++++++++++++++++++++++++++---------
>>  fs/ocfs2/mmap.c        |    2 
>>  fs/ocfs2/ocfs2_trace.h |   10 ++--
>>  6 files changed, 99 insertions(+), 32 deletions(-)
>> 
>> diff -puN fs/ocfs2/dir.c~ocfs2-nowait-aio-support fs/ocfs2/dir.c
>> --- a/fs/ocfs2/dir.c~ocfs2-nowait-aio-support
>> +++ a/fs/ocfs2/dir.c
>> @@ -1957,7 +1957,7 @@ int ocfs2_readdir(struct file *file, str
>>  
>>  	trace_ocfs2_readdir((unsigned long long)OCFS2_I(inode)->ip_blkno);
>>  
>> -	error = ocfs2_inode_lock_atime(inode, file->f_path.mnt, &lock_level);
>> +	error = ocfs2_inode_lock_atime(inode, file->f_path.mnt, &lock_level, 1);
>>  	if (lock_level && error >= 0) {
>>  		/* We release EX lock which used to update atime
>>  		 * and get PR lock again to reduce contention
>> diff -puN fs/ocfs2/dlmglue.c~ocfs2-nowait-aio-support fs/ocfs2/dlmglue.c
>> --- a/fs/ocfs2/dlmglue.c~ocfs2-nowait-aio-support
>> +++ a/fs/ocfs2/dlmglue.c
>> @@ -2515,13 +2515,18 @@ int ocfs2_inode_lock_with_page(struct in
>>  
>>  int ocfs2_inode_lock_atime(struct inode *inode,
>>  			  struct vfsmount *vfsmnt,
>> -			  int *level)
>> +			  int *level, int wait)
>>  {
>>  	int ret;
>>  
>> -	ret = ocfs2_inode_lock(inode, NULL, 0);
>> +	if (wait)
>> +		ret = ocfs2_inode_lock(inode, NULL, 0);
>> +	else
>> +		ret = ocfs2_try_inode_lock(inode, NULL, 0);
>> +
>>  	if (ret < 0) {
>> -		mlog_errno(ret);
>> +		if (ret != -EAGAIN)
>> +			mlog_errno(ret);
>>  		return ret;
>>  	}
>>  
>> @@ -2533,9 +2538,14 @@ int ocfs2_inode_lock_atime(struct inode
>>  		struct buffer_head *bh = NULL;
>>  
>>  		ocfs2_inode_unlock(inode, 0);
>> -		ret = ocfs2_inode_lock(inode, &bh, 1);
>> +		if (wait)
>> +			ret = ocfs2_inode_lock(inode, &bh, 1);
>> +		else
>> +			ret = ocfs2_try_inode_lock(inode, &bh, 1);
>> +
>>  		if (ret < 0) {
>> -			mlog_errno(ret);
>> +			if (ret != -EAGAIN)
>> +				mlog_errno(ret);
>>  			return ret;
>>  		}
>>  		*level = 1;
>> diff -puN fs/ocfs2/dlmglue.h~ocfs2-nowait-aio-support fs/ocfs2/dlmglue.h
>> --- a/fs/ocfs2/dlmglue.h~ocfs2-nowait-aio-support
>> +++ a/fs/ocfs2/dlmglue.h
>> @@ -123,7 +123,7 @@ int ocfs2_try_open_lock(struct inode *in
>>  void ocfs2_open_unlock(struct inode *inode);
>>  int ocfs2_inode_lock_atime(struct inode *inode,
>>  			  struct vfsmount *vfsmnt,
>> -			  int *level);
>> +			  int *level, int wait);
>>  int ocfs2_inode_lock_full_nested(struct inode *inode,
>>  			 struct buffer_head **ret_bh,
>>  			 int ex,
>> diff -puN fs/ocfs2/file.c~ocfs2-nowait-aio-support fs/ocfs2/file.c
>> --- a/fs/ocfs2/file.c~ocfs2-nowait-aio-support
>> +++ a/fs/ocfs2/file.c
>> @@ -140,6 +140,8 @@ static int ocfs2_file_open(struct inode
>>  		spin_unlock(&oi->ip_lock);
>>  	}
>>  
>> +	file->f_mode |= FMODE_NOWAIT;
>> +
>>  leave:
>>  	return status;
>>  }
>> @@ -2132,12 +2134,12 @@ out:
>>  }
>>  
>>  static int ocfs2_prepare_inode_for_write(struct file *file,
>> -					 loff_t pos,
>> -					 size_t count)
>> +					 loff_t pos, size_t count, int wait)
>>  {
>> -	int ret = 0, meta_level = 0;
>> +	int ret = 0, meta_level = 0, overwrite_io = 0;
>>  	struct dentry *dentry = file->f_path.dentry;
>>  	struct inode *inode = d_inode(dentry);
>> +	struct buffer_head *di_bh = NULL;
>>  	loff_t end;
>>  
>>  	/*
>> @@ -2145,13 +2147,40 @@ static int ocfs2_prepare_inode_for_write
>>  	 * if we need to make modifications here.
>>  	 */
>>  	for(;;) {
>> -		ret = ocfs2_inode_lock(inode, NULL, meta_level);
>> +		if (wait)
>> +			ret = ocfs2_inode_lock(inode, NULL, meta_level);
>> +		else
>> +			ret = ocfs2_try_inode_lock(inode,
>> +				overwrite_io ? NULL : &di_bh, meta_level);
>>  		if (ret < 0) {
>>  			meta_level = -1;
>> -			mlog_errno(ret);
>> +			if (ret != -EAGAIN)
>> +				mlog_errno(ret);
>>  			goto out;
>>  		}
>>  
>> +		/*
>> +		 * Check if IO will overwrite allocated blocks in case
>> +		 * IOCB_NOWAIT flag is set.
>> +		 */
>> +		if (!wait && !overwrite_io) {
>> +			overwrite_io = 1;
>> +			if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
>> +				ret = -EAGAIN;
>> +				goto out_unlock;
>> +			}
>> +
> Can we lock the 'ip_alloc_sem' in ocfs2_overwrite_io()?
Hi Alex, I feel it is better that there is not any lock within ocfs2_overwrite_io() function, since it can be re-used by other code in the future if possible.
Before use ocfs2_overwrite_io() function, we should get two kinds of lock, inode lock and ip_alloc_sem lock.
If we move one lock into the function, the user will become a little confused to get the correct locks, possibly will forget to get inode lock. 

> 
> BTW, should we consider the ocfs2_inode_lock() in 
> ocfs2_prepare_inode_for_refcount()?
In this case, if ocfs2_overwrite_IO() function is returned OK, we will not enter ocfs2_prepare_inode_for_refcount() path,
If enter that code path, that means to need allocate meta-block, for non-block IO mode, the code should has broken out to return error after ocfs2_overwrite_IO() function .  

Thanks
Gang


>> +			ret = ocfs2_overwrite_io(inode, di_bh, pos, count);
>> +			brelse(di_bh);
>> +			di_bh = NULL;
>> +			up_read(&OCFS2_I(inode)->ip_alloc_sem);
>> +			if (ret < 0) {
>> +				if (ret != -EAGAIN)
>> +					mlog_errno(ret);
>> +				goto out_unlock;
>> +			}
>> +		}
>> +
>>  		/* Clear suid / sgid if necessary. We do this here
>>  		 * instead of later in the write path because
>>  		 * remove_suid() calls ->setattr without any hint that
>> @@ -2199,7 +2228,9 @@ static int ocfs2_prepare_inode_for_write
>>  
>>  out_unlock:
>>  	trace_ocfs2_prepare_inode_for_write(OCFS2_I(inode)->ip_blkno,
>> -					    pos, count);
>> +					    pos, count, wait);
>> +
>> +	brelse(di_bh);
>>  
>>  	if (meta_level >= 0)
>>  		ocfs2_inode_unlock(inode, meta_level);
>> @@ -2211,7 +2242,7 @@ out:
>>  static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>>  				    struct iov_iter *from)
>>  {
>> -	int direct_io, rw_level;
>> +	int rw_level;
>>  	ssize_t written = 0;
>>  	ssize_t ret;
>>  	size_t count = iov_iter_count(from);
>> @@ -2223,6 +2254,8 @@ static ssize_t ocfs2_file_write_iter(str
>>  	void *saved_ki_complete = NULL;
>>  	int append_write = ((iocb->ki_pos + count) >=
>>  			i_size_read(inode) ? 1 : 0);
>> +	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
>> +	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
>>  
>>  	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
>>  		(unsigned long long)OCFS2_I(inode)->ip_blkno,
>> @@ -2230,12 +2263,17 @@ static ssize_t ocfs2_file_write_iter(str
>>  		file->f_path.dentry->d_name.name,
>>  		(unsigned int)from->nr_segs);	/* GRRRRR */
>>  
>> +	if (!direct_io && nowait)
>> +		return -EOPNOTSUPP;
>> +
>>  	if (count == 0)
>>  		return 0;
>>  
>> -	direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
>> -
>> -	inode_lock(inode);
>> +	if (direct_io && nowait) {
>> +		if (!inode_trylock(inode))
>> +			return -EAGAIN;
>> +	} else
>> +		inode_lock(inode);
>>  
>>  	/*
>>  	 * Concurrent O_DIRECT writes are allowed with
>> @@ -2244,9 +2282,13 @@ static ssize_t ocfs2_file_write_iter(str
>>  	 */
>>  	rw_level = (!direct_io || full_coherency || append_write);
>>  
>> -	ret = ocfs2_rw_lock(inode, rw_level);
>> +	if (direct_io && nowait)
>> +		ret = ocfs2_try_rw_lock(inode, rw_level);
>> +	else
>> +		ret = ocfs2_rw_lock(inode, rw_level);
>>  	if (ret < 0) {
>> -		mlog_errno(ret);
>> +		if (ret != -EAGAIN)
>> +			mlog_errno(ret);
>>  		goto out_mutex;
>>  	}
>>  
>> @@ -2260,9 +2302,13 @@ static ssize_t ocfs2_file_write_iter(str
>>  		 * other nodes to drop their caches.  Buffered I/O
>>  		 * already does this in write_begin().
>>  		 */
>> -		ret = ocfs2_inode_lock(inode, NULL, 1);
>> +		if (nowait)
>> +			ret = ocfs2_try_inode_lock(inode, NULL, 1);
>> +		else
>> +			ret = ocfs2_inode_lock(inode, NULL, 1);
>>  		if (ret < 0) {
>> -			mlog_errno(ret);
>> +			if (ret != -EAGAIN)
>> +				mlog_errno(ret);
>>  			goto out;
>>  		}
>>  
>> @@ -2277,9 +2323,10 @@ static ssize_t ocfs2_file_write_iter(str
>>  	}
>>  	count = ret;
>>  
>> -	ret = ocfs2_prepare_inode_for_write(file, iocb->ki_pos, count);
>> +	ret = ocfs2_prepare_inode_for_write(file, iocb->ki_pos, count, !nowait);
>>  	if (ret < 0) {
>> -		mlog_errno(ret);
>> +		if (ret != -EAGAIN)
>> +			mlog_errno(ret);
>>  		goto out;
>>  	}
>>  
>> @@ -2355,6 +2402,7 @@ static ssize_t ocfs2_file_read_iter(stru
>>  	int ret = 0, rw_level = -1, lock_level = 0;
>>  	struct file *filp = iocb->ki_filp;
>>  	struct inode *inode = file_inode(filp);
>> +	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
>>  
>>  	trace_ocfs2_file_aio_read(inode, filp, filp->f_path.dentry,
>>  			(unsigned long long)OCFS2_I(inode)->ip_blkno,
>> @@ -2374,9 +2422,14 @@ static ssize_t ocfs2_file_read_iter(stru
>>  	 * need locks to protect pending reads from racing with truncate.
>>  	 */
>>  	if (iocb->ki_flags & IOCB_DIRECT) {
>> -		ret = ocfs2_rw_lock(inode, 0);
>> +		if (nowait)
>> +			ret = ocfs2_try_rw_lock(inode, 0);
>> +		else
>> +			ret = ocfs2_rw_lock(inode, 0);
>> +
>>  		if (ret < 0) {
>> -			mlog_errno(ret);
>> +			if (ret != -EAGAIN)
>> +				mlog_errno(ret);
>>  			goto bail;
>>  		}
>>  		rw_level = 0;
>> @@ -2393,9 +2446,11 @@ static ssize_t ocfs2_file_read_iter(stru
>>  	 * like i_size. This allows the checks down below
>>  	 * generic_file_aio_read() a chance of actually working.
>>  	 */
>> -	ret = ocfs2_inode_lock_atime(inode, filp->f_path.mnt, &lock_level);
>> +	ret = ocfs2_inode_lock_atime(inode, filp->f_path.mnt, &lock_level,
>> +				     !nowait);
>>  	if (ret < 0) {
>> -		mlog_errno(ret);
>> +		if (ret != -EAGAIN)
>> +			mlog_errno(ret);
>>  		goto bail;
>>  	}
>>  	ocfs2_inode_unlock(inode, lock_level);
>> diff -puN fs/ocfs2/mmap.c~ocfs2-nowait-aio-support fs/ocfs2/mmap.c
>> --- a/fs/ocfs2/mmap.c~ocfs2-nowait-aio-support
>> +++ a/fs/ocfs2/mmap.c
>> @@ -184,7 +184,7 @@ int ocfs2_mmap(struct file *file, struct
>>  	int ret = 0, lock_level = 0;
>>  
>>  	ret = ocfs2_inode_lock_atime(file_inode(file),
>> -				    file->f_path.mnt, &lock_level);
>> +				    file->f_path.mnt, &lock_level, 1);
>>  	if (ret < 0) {
>>  		mlog_errno(ret);
>>  		goto out;
>> diff -puN fs/ocfs2/ocfs2_trace.h~ocfs2-nowait-aio-support fs/ocfs2/ocfs2_trace.h
>> --- a/fs/ocfs2/ocfs2_trace.h~ocfs2-nowait-aio-support
>> +++ a/fs/ocfs2/ocfs2_trace.h
>> @@ -1449,20 +1449,22 @@ DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_rem
>>  
>>  TRACE_EVENT(ocfs2_prepare_inode_for_write,
>>  	TP_PROTO(unsigned long long ino, unsigned long long saved_pos,
>> -		 unsigned long count),
>> -	TP_ARGS(ino, saved_pos, count),
>> +		 unsigned long count, int wait),
>> +	TP_ARGS(ino, saved_pos, count, wait),
>>  	TP_STRUCT__entry(
>>  		__field(unsigned long long, ino)
>>  		__field(unsigned long long, saved_pos)
>>  		__field(unsigned long, count)
>> +		__field(int, wait)
>>  	),
>>  	TP_fast_assign(
>>  		__entry->ino = ino;
>>  		__entry->saved_pos = saved_pos;
>>  		__entry->count = count;
>> +		__entry->wait = wait;
>>  	),
>> -	TP_printk("%llu %llu %lu", __entry->ino,
>> -		  __entry->saved_pos, __entry->count)
>> +	TP_printk("%llu %llu %lu %d", __entry->ino,
>> +		  __entry->saved_pos, __entry->count, __entry->wait)
>>  );
>>  
>>  DEFINE_OCFS2_INT_EVENT(generic_file_aio_read_ret);
>> _
>> 
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com 
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
>> 
>> .
>> 
