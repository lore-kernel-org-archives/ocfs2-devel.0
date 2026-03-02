Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4B2D238F
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Mar 2026 09:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772443794; cv=none; b=CtX9CUHn6yeF+ib5UruBLVT+VztB1IXQkpj8SIvsdgXKzFBVbjQqc9zSSNoqdKVpJ5xX1Bz1Oq3diEYU6shKkHGhBoiabEDcoGkzqHtuiNkODyfdgkS1qwNeAdRhuHGPC5LatrIdwwIFI+zsg+udjEW8KM53CiskIAcQId0HJFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772443794; c=relaxed/simple;
	bh=3QHK1b9BeHTOcrVD1Z3zzQSxOI5j9Cz5ZYr0bS6CbS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uXbdqsZtnGREse08tvVryU/ECLFeIGlecOEVI4Sd1E0vgS0BeiL3BIlrWQPYFb/o419H5YeCdOgbbpZxtlF2Br5zUNC/tvPidvQtrGHoWv65HDwd2cfcpdy8rccfID82dd3bvEe1S7UCHnmh3jjgYSQB3//Ooi3LEtjVMHkHw4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kHrf3OvZ; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kHrf3OvZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772443789; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kQ9J4U1xGLkiQcpl1ZnBh7MOPQOcnyr4uyhu1NAHZY8=;
	b=kHrf3OvZRkLzTMzeU/5L6OCY8CFwwYiQzSS9pjmiz5+hq+c75OTyC9cd1a6nzUZ5k4na4j3U2QHQmoxXSOb7nppLly3O2w4CcjB5f0v9wEOnF5PoddDdIbiwBIGoDQMIytm+lIiz15gWP16F54HPAEe7SZtik6ehFsvprZr72Fk=
Received: from 30.221.129.66(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-3ETP-_1772443787 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Mar 2026 17:29:47 +0800
Message-ID: <0f2ed4dc-8ad9-4dba-834c-a672de0cee97@linux.alibaba.com>
Date: Mon, 2 Mar 2026 17:29:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix deadlock when creating quota file
To: Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 activprithvi@gmail.com, syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
References: <20260302061707.7092-1-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260302061707.7092-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/2/26 2:17 PM, Heming Zhao wrote:
> syzbot detected a circular locking dependency. the scenarios:
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(&ocfs2_quota_ip_alloc_sem_key);
>                                 lock(&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
>                                 lock(&ocfs2_quota_ip_alloc_sem_key);
>    lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> 
> or:
>        CPU0                    CPU1
>        ----                    ----
>   lock(&ocfs2_quota_ip_alloc_sem_key);
>                                lock(&dquot->dq_lock);
>                                lock(&ocfs2_quota_ip_alloc_sem_key);
>   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> 
> Following are the code paths for above scenarios:
> 
> path_openat
>  ocfs2_create
>   ocfs2_mknod
>   + ocfs2_reserve_new_inode
>   |  ocfs2_reserve_suballoc_bits
>   |   inode_lock(alloc_inode) //C0: hold INODE_ALLOC_SYSTEM_INODE
>   |    //ocfs2_free_alloc_context(inode_ac) is called at the end of
>   |    //caller ocfs2_mknod to handle the release
>   |
>   + ocfs2_get_init_inode
>      __dquot_initialize
>       dqget
>        ocfs2_acquire_dquot
>        + ocfs2_lock_global_qf
>        |  down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)//A2:grabbing
>        + ocfs2_create_local_dquot
>           down_write(&OCFS2_I(lqinode)->ip_alloc_sem)//A3:grabbing
> 
> evict
>  ocfs2_evict_inode
>   ocfs2_delete_inode
>    ocfs2_wipe_inode
>     + inode_lock(orphan_dir_inode) //B0:hold
>     + ...
>     + ocfs2_remove_inode
>        inode_lock(inode_alloc_inode) //INODE_ALLOC_SYSTEM_INODE
>         down_write(&inode->i_rwsem) //C1:grabbing
> 
> generic_file_direct_write
>  ocfs2_direct_IO
>   __blockdev_direct_IO
>    dio_complete
>     ocfs2_dio_end_io
>      ocfs2_dio_end_io_write
>      + down_write(&oi->ip_alloc_sem) //A0:hold
>      + ocfs2_del_inode_from_orphan
>         inode_lock(orphan_dir_inode) //B1:grabbing
> 
> Root cause for the circular locking:
> 
> DIO completion path:
>  holds oi->ip_alloc_sem and is trying to acquire the orphan_dir_inode lock.
> 
> evict path:
>  holds the orphan_dir_inode lock and is trying to acquire the
>  inode_alloc_inode lock.
> 
> ocfs2_mknod path:
>  Holds the inode_alloc_inode lock (to allocate a new quota file) and is
>  blocked waiting for oi->ip_alloc_sem in ocfs2_acquire_dquot().
> 
> How to fix:
> 
> Replace down_write() with down_write_trylock() in ocfs2_acquire_dquot().
> If acquiring oi->ip_alloc_sem fails, return -EBUSY to abort the file creation
> routine and break the deadlock.
> 
> Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v1 -> v2:
> - revise commit: the explanation in ocfs2_mknod() path
> - fix error handling mistake in ocfs2_lock_global_qf and 
>   ocfs2_create_local_dquot
> ---
>  fs/ocfs2/quota_global.c | 16 +++++++++++++++-
>  fs/ocfs2/quota_local.c  |  4 +++-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index e85b1ccf81be..77b8f0363e94 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -311,11 +311,25 @@ int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
>  	spin_unlock(&dq_data_lock);
>  	if (ex) {
>  		inode_lock(oinfo->dqi_gqinode);
> -		down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
> +		if (!down_write_trylock(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)) {
> +			inode_unlock(oinfo->dqi_gqinode);
> +			status = -EBUSY;
> +			goto bail;
> +		}
>  	} else {
>  		down_read(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
>  	}
>  	return 0;
> +
> +bail:
> +	/* does a similar job as ocfs2_unlock_global_qf */
> +	ocfs2_inode_unlock(oinfo->dqi_gqinode, ex);
> +	brelse(oinfo->dqi_gqi_bh);
> +	spin_lock(&dq_data_lock);
> +	if (!--oinfo->dqi_gqi_count)
> +		oinfo->dqi_gqi_bh = NULL;
> +	spin_unlock(&dq_data_lock);
> +	return status;
>  }
>  
>  void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index c4e0117d8977..e749cd064c87 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -1224,7 +1224,9 @@ int ocfs2_create_local_dquot(struct dquot *dquot)
>  	int status;
>  	u64 pcount;
>  
> -	down_write(&OCFS2_I(lqinode)->ip_alloc_sem);
> +	if (!down_write_trylock(&OCFS2_I(lqinode)->ip_alloc_sem))
> +		return -EBUSY;
> +
>  	chunk = ocfs2_find_free_entry(sb, type, &offset);
>  	if (!chunk) {
>  		chunk = ocfs2_extend_local_quota_file(sb, type, &offset);

