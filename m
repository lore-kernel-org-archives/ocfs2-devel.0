Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6EB14386D
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Nov 2024 03:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731640613; cv=none; b=MiQfhAnlVw1Ftq6Ln4A5wglR6mgWjFrDbrbiKqUY0+JTePjVPW84R6Ms5vL0q0xOlmWP7N1Wc1+lSPDSoSc+CbJinIHPHOXUysJkfa0A2CxhwDv1d9fn7WViiVlCWcU2msubEHXPfarJXSA/bAoOrgSlyLWLUUJHoLum1Fdzj5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731640613; c=relaxed/simple;
	bh=2RuJBwe44eTAqEuBnQgQfvFxXzd7y9GfABmyfV07R8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ayCjWZUwVBzdiGQR+X6eyzlcG7oXWWSk4u1U2EnIRVnxaERJ599CaNN7uNdDj/89g29Np4S6Nn/j9Z3WG7fb6v816adpvleFobL1ki8gmzKQllrDRmmiwo66LId8uXXiwUBkKJPRlAyXyG9wnQH1fZZnLrxPzycKc++FZsospig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VS4rMt5d; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VS4rMt5d"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731640608; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=k9fMrSOVrJ+jnsuxQn2xBTuPZe1UDD6HJqhgi6FyVXw=;
	b=VS4rMt5deDmbpSwHO8ynoTC8+JUdB+fIakPEWUk4oDyncf3G1RYpaH5iEPiQlkOD2Qt52fo0p/N2oVTV7kcD3Ig7a1yQ6WCEd0a73JyvirM6uZ2YUnpsUTSQWqvLvxVqhRRkpyjT7EgQimbY1rTfHR5WY5xWKw/a5IBL1+ywJp8=
Received: from 30.171.192.161(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WJR-EIK_1731640606 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 15 Nov 2024 11:16:47 +0800
Message-ID: <005f819e-aecb-4eb7-9e0f-60b9cad91d78@linux.alibaba.com>
Date: Fri, 15 Nov 2024 11:16:46 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix uninitialized value in ocfs2_file_read_iter()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+a73e253cca4f0230a5a5@syzkaller.appspotmail.com
References: <20241029091736.1501946-1-dmantipov@yandex.ru>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241029091736.1501946-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/29/24 5:17 PM, Dmitry Antipov wrote:
> Syzbot has reported the following KMSAN splat:
> 
> BUG: KMSAN: uninit-value in ocfs2_file_read_iter+0x9a4/0xf80
>  ocfs2_file_read_iter+0x9a4/0xf80
>  __io_read+0x8d4/0x20f0
>  io_read+0x3e/0xf0
>  io_issue_sqe+0x42b/0x22c0
>  io_wq_submit_work+0xaf9/0xdc0
>  io_worker_handle_work+0xd13/0x2110
>  io_wq_worker+0x447/0x1410
>  ret_from_fork+0x6f/0x90
>  ret_from_fork_asm+0x1a/0x30
> 
> Uninit was created at:
>  __alloc_pages_noprof+0x9a7/0xe00
>  alloc_pages_mpol_noprof+0x299/0x990
>  alloc_pages_noprof+0x1bf/0x1e0
>  allocate_slab+0x33a/0x1250
>  ___slab_alloc+0x12ef/0x35e0
>  kmem_cache_alloc_bulk_noprof+0x486/0x1330
>  __io_alloc_req_refill+0x84/0x560
>  io_submit_sqes+0x172f/0x2f30
>  __se_sys_io_uring_enter+0x406/0x41c0
>  __x64_sys_io_uring_enter+0x11f/0x1a0
>  x64_sys_call+0x2b54/0x3ba0
>  do_syscall_64+0xcd/0x1e0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Since an instance of 'struct kiocb' may be passed from the block layer
> with 'private' field uninitialized, introduce 'ocfs2_iocb_init_rw_locked()'
> and use it from where 'ocfs2_dio_end_io()' might take care, i.e. in
> 'ocfs2_file_read_iter()' and 'ocfs2_file_write_iter()'.
> 
> Reported-by: syzbot+a73e253cca4f0230a5a5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a73e253cca4f0230a5a5
> Fixes: 7cdfc3a1c397 ("ocfs2: Remember rw lock level during direct io")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.h | 2 ++
>  fs/ocfs2/file.c | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index 45db1781ea73..1d1b4b7edba0 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -70,6 +70,8 @@ enum ocfs2_iocb_lock_bits {
>  	OCFS2_IOCB_NUM_LOCKS
>  };
>  
> +#define ocfs2_iocb_init_rw_locked(iocb) \
> +	(iocb->private = NULL)
>  #define ocfs2_iocb_clear_rw_locked(iocb) \
>  	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
>  #define ocfs2_iocb_rw_locked_level(iocb) \
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 58887456e3c5..1e37176ac405 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2390,6 +2390,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>  	} else
>  		inode_lock(inode);
>  
> +	ocfs2_iocb_init_rw_locked(iocb);
> +
>  	/*
>  	 * Concurrent O_DIRECT writes are allowed with
>  	 * mount_option "coherency=buffered".
> @@ -2536,6 +2538,8 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  	if (!direct_io && nowait)
>  		return -EOPNOTSUPP;
>  
> +	ocfs2_iocb_init_rw_locked(iocb);
> +
>  	/*
>  	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
>  	 * need locks to protect pending reads from racing with truncate.

