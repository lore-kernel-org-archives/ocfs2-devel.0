Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792727584;
	b=e82Z5Bt5o6z08M9POBfgM/Sm0PTGIxstGsGOZT3Bx+89ZzXXcLorxAPhLAo+s8q6Amyz
	 tGwUCqJYsntmuDzS4G4donegZpSTxSPTdeHi8hB8TZMulXyi9zB0q8a7XK9iX/3frEkxE
	 5lqbP3zGGmOQLm8yefs7YpFzX9+Iu5ChPQI1ICz8nVyPlWMQPLLq2gNCsmY7Kr3I4hRRU
	 zuLqXMjb+Z2eRmk70slvdxzoKEm14QipR3pvwxUjRG6qjOP6sDMGWnU4LQi7OSuK0FWaB
	 l0C6cSP/FJ/sTuCDLH2zdDfrtTMcgJ5uF/Hj5pJKBS8yPGwnm0Jl/JxQY9ULBD9VloA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792727584;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=pVmQtPj73xkx0kK7v4cYdZ5fibluKU+0zwiIjqhOZRA=;
	b=yxDDCIyZYiZ1aAsq507bqCUWSp8IBIOZKKxVLaP65Zi+8cPnNzOamXgTtuxA/Ipp6D/Y
	 t/0HYjoUFJhoA2O7ucnnly6BdYyRk/X97tRZNTStlgrFfQh6HjNa4euX7p8PaLlByK1B6
	 3aZ78BbjhAsGafYdl5xzK31Ado1qm9IEYUAMumTvEpGREW2JF/oilvN0/VuXTJUNbaaCT
	 74nks/RQ6v2KkYwcWiR3pyavRMszgMFcG+uBZT2hnLasNwZ8mbbHjLG7tbAWRSWzJX7jZ
	 wKawHX0vXGLDrthlZnXCkgyMwCL83ER8pnsyhIxmD1SiRnVH4Og2DdYhoTV1hmukByQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="KGee/SXg";
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAA1606A319
	for <ocfs2-devel@lists.linux.dev>; Fri, 23 Oct 2026 03:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AAA1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KGee/SXg
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792727578; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pVmQtPj73xkx0kK7v4cYdZ5fibluKU+0zwiIjqhOZRA=;
	b=KGee/SXgDv1nJdN3gkFUKLw5K2Se5hGIGO4JHhsDIKf8i94LHF2iS0kR3RspzU7oQbkURDNH4FBxmH9eAjTMbo6mYRUCe2RaDAtc8vsqi/EDKSl/5pTkTuJlXZBwfb1yKalK2zUWHcNuOJ6TGMK82Hc2wF9SCNcq82WA/04vRCI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDKqBZ4_1792727577;
Received: from 30.221.129.69(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDKqBZ4_1792727577 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 11:52:57 +0800
Message-ID: <ea316ce8-6496-41ad-ae00-731538870e81@linux.alibaba.com>
Date: Fri, 23 Oct 2026 11:52:57 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] ocfs2: snapshot dentry names in file and setattr
 traces
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-0@gmail.com>
 <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/22/26 5:08 PM, Cen Zhang wrote:
> The open, fsync, read, write and splice-read trace calls pass the live
> dentry name and length to the shared ocfs2__file_ops event class.
> ocfs2_setattr() passes the same unprotected arguments to its own event.
> Both events size and copy a __string field separately. A reference to
> the dentry does not pin the external storage backing an individual name.
> 
> With an event enabled, a caller can be preempted after loading the name
> pointer. A long-to-short rename can then replace the name and reclaim its
> old external allocation before the trace callback sizes or copies it,
> provided no other snapshot retains that allocation.
> 
> The setattr inode lock does not exclude every rename: a same-directory
> rename of a source directory need not take that directory's inode lock.
> It can therefore change the dentry name while setattr records its event.
> Inline names and separately loaded lengths can also change during trace
> record sizing and copying.
> 
> Take a dentry name snapshot around each of these six trace calls and
> pass both the string and length from the snapshot. Check event enablement
> before taking a snapshot. Keep the event classes and formats unchanged.
> 
> Also remove the redundant NULL-inode check in the read callback.
> file_inode() returns the open file's inode, which is already used by the
> trace call above the check.
> 
> The historical report below is from the read path.
> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in strlen+0x85/0xa0
>     Read of size 1 at addr ffff88810a5b2b18 by task python3/496
> 
>     [CPU and host details omitted.]
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      ? strlen+0x85/0xa0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __virt_addr_valid+0x20e/0x420
>      ? strlen+0x85/0xa0
>      kasan_report+0xe0/0x110
>      ? strlen+0x85/0xa0
>      strlen+0x85/0xa0
>      trace_event_raw_event_ocfs2__file_ops+0xf0/0x480
>      ? __pfx_trace_event_raw_event_ocfs2__file_ops+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? pmbd_probe_hit_cookie+0xe7/0x1c0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
>      ocfs2_file_read_iter+0x6cd/0xb30
>      ? __pfx_ocfs2_file_read_iter+0x10/0x10
>      ? selinux_file_permission+0x11d/0x540
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? security_file_permission+0x26/0x80
>      vfs_read+0x7d2/0xc20
>      ? __pfx_vfs_read+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_do_sys_openat2+0x10/0x10
>      ksys_read+0x111/0x200
>      ? __pfx_ksys_read+0x10/0x10
>      ? irqentry_exit+0xbe/0x820
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? trace_hardirqs_on_prepare+0x11d/0x150
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [User register dump omitted.]
>      </TASK>
> 
>     Allocated by task 489:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_kmalloc+0xaa/0xb0
>      __kmalloc_noprof+0x2de/0x780
>      __d_alloc+0x5fc/0x8c0
>      d_alloc_parallel+0x106/0x11d0
>      lookup_open+0x3ff/0x13e0
>      path_openat+0x95e/0x2020
>      do_file_open+0x21e/0x470
>      do_sys_openat2+0xf4/0x1b0
>      __x64_sys_openat+0x136/0x1e0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
>     Freed by task 0:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      __rcu_free_sheaf_prepare+0x65/0x2a0
>      rcu_free_sheaf_nobarn+0x1d/0x50
>      rcu_core+0x6be/0x1ed0
>      handle_softirqs+0x1fa/0x8d0
>      __irq_exit_rcu+0x113/0x1e0
>      irq_exit_rcu+0xe/0x20
>      sysvec_apic_timer_interrupt+0x6c/0x80
>      asm_sysvec_apic_timer_interrupt+0x1a/0x20
> 
>     The buggy address belongs to the object at ffff88810a5b2b00
>      which belongs to the cache kmalloc-rcl-192 of size 192
>     The buggy address is located 24 bytes inside of
>      freed 192-byte region [ffff88810a5b2b00, ffff88810a5b2bc0)
> 
>     [Page and shadow-memory dumps omitted.]
> 
> Fixes: 468eedde23d6 ("ocfs2: Remove mlog(0) from fs/ocfs2/file.c")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/file.c | 100 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 64 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index d6e977ba6565..c6e7606ff9e1 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -85,10 +85,17 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
>  	int mode = file->f_flags;
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  
> -	trace_ocfs2_file_open(inode, file, file->f_path.dentry,
> -			      (unsigned long long)oi->ip_blkno,
> -			      file->f_path.dentry->d_name.len,
> -			      file->f_path.dentry->d_name.name, mode);
> +	if (trace_ocfs2_file_open_enabled()) {
> +		struct dentry *dentry = file->f_path.dentry;
> +		struct name_snapshot name;
> +
> +		take_dentry_name_snapshot(&name, dentry);
> +		trace_ocfs2_file_open(inode, file, dentry,
> +				      oi->ip_blkno,
> +				      name.name.len, name.name.name,
> +				      mode);
> +		release_dentry_name_snapshot(&name);
> +	}
>  
>  	if (file->f_mode & FMODE_WRITE) {
>  		status = dquot_initialize(inode);
> @@ -174,11 +181,17 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
>  	tid_t commit_tid;
>  	bool needs_barrier = false;
>  
> -	trace_ocfs2_sync_file(inode, file, file->f_path.dentry,
> -			      oi->ip_blkno,
> -			      file->f_path.dentry->d_name.len,
> -			      file->f_path.dentry->d_name.name,
> -			      (unsigned long long)datasync);
> +	if (trace_ocfs2_sync_file_enabled()) {
> +		struct dentry *dentry = file->f_path.dentry;
> +		struct name_snapshot name;
> +
> +		take_dentry_name_snapshot(&name, dentry);
> +		trace_ocfs2_sync_file(inode, file, dentry,
> +				      oi->ip_blkno,
> +				      name.name.len, name.name.name,
> +				      (unsigned long long)datasync);
> +		release_dentry_name_snapshot(&name);
> +	}
>  
>  	if (unlikely(ocfs2_emergency_state(osb)))
>  		return -EROFS;
> @@ -1132,15 +1145,19 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	int had_lock;
>  	struct ocfs2_lock_holder oh;
>  
> -	trace_ocfs2_setattr(inode, dentry,
> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
> -			    dentry->d_name.len, dentry->d_name.name,
> -			    attr->ia_valid,
> -				attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
> -				attr->ia_valid & ATTR_UID ?
> +	if (trace_ocfs2_setattr_enabled()) {
> +		struct name_snapshot name;
> +
> +		take_dentry_name_snapshot(&name, dentry);
> +		trace_ocfs2_setattr(inode, dentry, OCFS2_I(inode)->ip_blkno,
> +				    name.name.len, name.name.name, attr->ia_valid,
> +				    attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
> +				    attr->ia_valid & ATTR_UID ?
>  					from_kuid(&init_user_ns, attr->ia_uid) : 0,
> -				attr->ia_valid & ATTR_GID ?
> +				    attr->ia_valid & ATTR_GID ?
>  					from_kgid(&init_user_ns, attr->ia_gid) : 0);
> +		release_dentry_name_snapshot(&name);
> +	}
>  
>  	status = ocfs2_emergency_state(osb);
>  	if (unlikely(status)) {
> @@ -2392,11 +2409,17 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>  	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
>  	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
>  
> -	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
> -		(unsigned long long)OCFS2_I(inode)->ip_blkno,
> -		file->f_path.dentry->d_name.len,
> -		file->f_path.dentry->d_name.name,
> -		(unsigned int)from->nr_segs);	/* GRRRRR */
> +	if (trace_ocfs2_file_write_iter_enabled()) {
> +		struct dentry *dentry = file->f_path.dentry;
> +		struct name_snapshot name;
> +
> +		take_dentry_name_snapshot(&name, dentry);
> +		trace_ocfs2_file_write_iter(inode, file, dentry,
> +					    OCFS2_I(inode)->ip_blkno,
> +					    name.name.len, name.name.name,
> +					    (unsigned int)from->nr_segs);
> +		release_dentry_name_snapshot(&name);
> +	}
>  
>  	if (!direct_io && nowait)
>  		return -EOPNOTSUPP;
> @@ -2542,17 +2565,16 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
>  	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
>  
> -	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
> -			(unsigned long long)OCFS2_I(inode)->ip_blkno,
> -			filp->f_path.dentry->d_name.len,
> -			filp->f_path.dentry->d_name.name,
> -			to->nr_segs);	/* GRRRRR */
> -
> +	if (trace_ocfs2_file_read_iter_enabled()) {
> +		struct dentry *dentry = filp->f_path.dentry;
> +		struct name_snapshot name;
>  
> -	if (!inode) {
> -		ret = -EINVAL;
> -		mlog_errno(ret);
> -		goto bail;
> +		take_dentry_name_snapshot(&name, dentry);
> +		trace_ocfs2_file_read_iter(inode, filp, dentry,
> +					   OCFS2_I(inode)->ip_blkno,
> +					   name.name.len, name.name.name,
> +					   to->nr_segs);
> +		release_dentry_name_snapshot(&name);
>  	}
>  
>  	if (!direct_io && nowait)
> @@ -2624,11 +2646,17 @@ static ssize_t ocfs2_file_splice_read(struct file *in, loff_t *ppos,
>  	ssize_t ret = 0;
>  	int lock_level = 0;
>  
> -	trace_ocfs2_file_splice_read(inode, in, in->f_path.dentry,
> -				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
> -				     in->f_path.dentry->d_name.len,
> -				     in->f_path.dentry->d_name.name,
> -				     flags);
> +	if (trace_ocfs2_file_splice_read_enabled()) {
> +		struct dentry *dentry = in->f_path.dentry;
> +		struct name_snapshot name;
> +
> +		take_dentry_name_snapshot(&name, dentry);
> +		trace_ocfs2_file_splice_read(inode, in, dentry,
> +					     OCFS2_I(inode)->ip_blkno,
> +					     name.name.len, name.name.name,
> +					     flags);
> +		release_dentry_name_snapshot(&name);
> +	}
>  
>  	/*
>  	 * We're fine letting folks race truncates and extending writes with

