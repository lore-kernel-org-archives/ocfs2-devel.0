Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1047410D37
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Feb 2026 10:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772276020; cv=none; b=ONK6wN/NGvxzuKcH2p3QRWA9LrQJc8tWyU4vPn11u7Ns6MOC6a2jnt9ZktcZu6h7meb9h1cYxqWOjGfq7CFY18m631E2gjbhvJ2lSjLkHjnSkCDeRPIX/QmaaLTajpIvuLhCsCp0MHoi/C3Bees1SzjMK2XNQFQZ2X+we4IMrvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772276020; c=relaxed/simple;
	bh=mp37iUT9CBPceUfxJWxzhIYhKDxI0SY/LttS6rzHmzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dWLgInoIzzS7sTcL8kjWAa+gB+IMM/Dvc1twfLS87enMzzRj2Tj/D2yv4gfnLCvJdahO/8/etsk/jF3DuySOQsQtpTmUGSX5a/OT11Q7O7ancimnIs/wWRpd4W0mHAdu56/ii6cuhGLmQXmy32tu31qOdVSc1aX2gVwCUuRlkkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=q9vflkws; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="q9vflkws"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772276015; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5sQ0nJne69u+q4bxwmF15TeZNOilP2wv9CFAAd6QcTc=;
	b=q9vflkwsN3FzZHjy3jURTSPIAlku5XC5HLXuWtEjUaAS1xPHyGozRktcjkxGwpCTxFH+dV9aHRjzWz/zmQmn/Cuo0VAZIk8b2xGQPq0sjhwh75H5WYY+SfSbRSnYuPreRQhOJGjZAvJSX1jFLCIEv44th65+sFB0jcUWGUZ6VIc=
Received: from 30.221.129.112(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WzxHtKL_1772276014 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 28 Feb 2026 18:53:34 +0800
Message-ID: <d5b1842e-ba46-4bb3-b4e6-c0d45cf900a6@linux.alibaba.com>
Date: Sat, 28 Feb 2026 18:53:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix deadlock when creating quota file
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 activprithvi@gmail.com, syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
References: <20260224084909.28361-1-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260224084909.28361-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/24/26 4:48 PM, Heming Zhao wrote:
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
>   |    //at end of this func, ocfs2_free_alloc_context(inode_ac) calls inode_unlock
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
> ---
>  fs/ocfs2/quota_global.c | 5 ++++-
>  fs/ocfs2/quota_local.c  | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index e85b1ccf81be..4321d8f59402 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -311,7 +311,10 @@ int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
>  	spin_unlock(&dq_data_lock);
>  	if (ex) {
>  		inode_lock(oinfo->dqi_gqinode);
> -		down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
> +		if (!down_write_trylock(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)) {
> +			inode_unlock(oinfo->dqi_gqinode);

You've missed the oinfo->dqi_gqinode cleanup.

> +			return -EBUSY;
> +		}
>  	} else {
>  		down_read(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
>  	}
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index c4e0117d8977..e451f3d96037 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -1224,7 +1224,10 @@ int ocfs2_create_local_dquot(struct dquot *dquot)
>  	int status;
>  	u64 pcount;
>  
> -	down_write(&OCFS2_I(lqinode)->ip_alloc_sem);
> +	if (!down_write_trylock(&OCFS2_I(lqinode)->ip_alloc_sem)) {
> +		status = -EBUSY;
> +		goto out;

We cannot goto out here since it does up_write.
It seems we can return EBUSY directly.

Joseph

> +	}
>  	chunk = ocfs2_find_free_entry(sb, type, &offset);
>  	if (!chunk) {
>  		chunk = ocfs2_extend_local_quota_file(sb, type, &offset);

