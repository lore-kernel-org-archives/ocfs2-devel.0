Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432C627442
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Feb 2026 06:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772258528; cv=none; b=oK/bhzBVahSPh2i+tNYW8/OxZysr9N0pBMbo1ab40XuAqy/00bgTYKmx3oivDyi0x/lo+bK/WSbkbCak+uNGvMLrVKG9xOWS5I0Fs5JXt77s0o82bKEGXh2DVNvoGcP/oc6+Cw5nK07/2QaNNHRpyTYlONtOiim0IyDG8BOK66E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772258528; c=relaxed/simple;
	bh=x5oaxEP7OCLMQw5SBgfwsdXk0kH66XYyPnm1K6bmKWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bYOsR9qRMw4SLKNkH8mk0P+KgbiUtezV1/MtXeqxzRXE3ZpiN05QgTqrwPif1LalgJYTLVhrNhlNiXmUgHdXSjAQnJvQfDNwy15X5KRMTg/4Cwdhb8ftwwq55KnCG25DdjatQMs6Dfd73b24Jzjluh1aOqZvgy/U+tYZLmNeurc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZcwTqCqB; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZcwTqCqB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772258518; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZueptbwO4eq05Z8v6GrbQlvMIz3qN9KUp0HW2YZt9co=;
	b=ZcwTqCqB6A2rr61BtvFXIKdzeZCc7Fqm0ztcLKed7lwhIz9f9mQc+mEsmiKTV4/240/8+UUqFHEbrPszH0Kt9YK8efz7dv1wbsGMxyYLDiliTvYzD5G6ag5Btij5OgtOMtMTIQ04uz9adoIECByodGmvfI/D/ABaWNZKSoWzUsw=
Received: from 30.221.129.112(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WzwX-Pe_1772258516 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 28 Feb 2026 14:01:57 +0800
Message-ID: <bd3926d7-3069-48cb-a04c-b8ab285d47e1@linux.alibaba.com>
Date: Sat, 28 Feb 2026 14:01:55 +0800
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
 activprithvi@gmail.com,
 syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com,
 akpm <akpm@linux-foundation.org>
References: <20260224084909.28361-1-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260224084909.28361-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Heming,

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

When running into ocfs2_mknod->ocfs2_get_init_inode,
ocfs2_reserve_new_inode is finished and INODE_ALLOC_SYSTEM_INODE gets
unlocked in ocfs2_free_ac_resource at the end.
So I get confused about the above deadlock sequence.
Am I missing something?

Joseph

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
> +	}
>  	chunk = ocfs2_find_free_entry(sb, type, &offset);
>  	if (!chunk) {
>  		chunk = ocfs2_extend_local_quota_file(sb, type, &offset);

