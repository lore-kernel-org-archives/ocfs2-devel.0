Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792583838;
	b=NsWiCjjbzJcJHnzsr6Y8R3ptIrgog1/nIbQdXUBpX3/7PmjPlD461fgw36tBrESmqFit
	 ge35rwitrcNkrRATx7uIlS/M/dHjQOQt1IjxJwnxk3F4IuDh0nQdkM3uCOiLgObBMd8C0
	 yaeeMbmbdC6B8qGg0zBXt/YrKZyEt2DFoU+RyJgWgSlFSGdxoZeMb1HQOnmCL131KU1Bq
	 Oevc6x+/xGyr3XKgPd73flD8A2j0SbuBNTWUNGSv7qRaIcKmVy16aqrMSfw1SgufieF8l
	 qZpfDWh1SlMi1LfS4kaKv80Iik7CGrYAIelfxYXGY8uk6tuWqH9m1iwF/fAL4ySGFTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792583838;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+UMytylQ6mrojiHLcj3je07Z0OFvxutj7+E3X5FQ4SU=;
	b=uEhkxwXpr96wOOW7jMspV3w09wQcHYoS+28HiAgpB5l5U4QOjNIQbff2qLOc14csTguC
	 xBF3c7IturuHrHU0+AEeixGXOiDYxBrqxE9HlLIz3dtitPtGEzn03N0Bi5VWvEG4lT5mE
	 CD3ZhRCCi4boO6Y1sDfm+7w8rMlLADumF2k7kyj3j29vsCA/AsNhMmzUp3EORRzYE5c35
	 23Q/ip0KesRGp19HYkdvE/h6F47v2PzeEvFqtLidLWda2DnIU05OD/9JXN4NuBcoNXDme
	 WOb68SJKS8MnSDTYrZR2WWMy50O+AjV0NKoYoO2nmJnhOvWyMxtXs1aEkfScHUYE4Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oOWLmY5b;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8D8606A319
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Oct 2026 11:57:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F8D8606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oOWLmY5b
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792583827; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+UMytylQ6mrojiHLcj3je07Z0OFvxutj7+E3X5FQ4SU=;
	b=oOWLmY5b19CixnXCwVq5DDikCvFckGDWo7X0h5PljUP6odrNhMMBwc1cqU7lfxDGNsQR6HQFFshVmOLMTL4Lig/vSush55RHXrBtlXv6Qkuqr4+D+twg3/bSeL4EdIZzExn7/2Eq9f8oICqnVk9j5++iDFytlM0rNa/URQchS7A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDGHZKw_1792583825;
Received: from 30.221.149.139(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDGHZKw_1792583825 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 19:57:06 +0800
Message-ID: <9e071e7d-ae86-4b55-8609-1f00a0deb913@linux.alibaba.com>
Date: Wed, 21 Oct 2026 19:57:05 +0800
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
Subject: Re: [PATCH v3 1/2] ocfs2: snapshot dentry names in file-operation
 traces
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-0@gmail.com>
 <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/20/26 11:43 AM, Cen Zhang wrote:
> The open, fsync, read, write and splice-read trace calls pass the live
> dentry name and length to the shared ocfs2__file_ops event class. A
> file reference pins the dentry, but not the external allocation backing
> an individual name. The event needs those bytes when sizing its
> __string field and when copying the string into the trace record.
> 
> With the relevant event enabled, a caller can be preempted after
> evaluating its name argument. A concurrent long-to-short rename of
> the same dentry can replace and reclaim the external name before
> the trace callback uses it, provided no other snapshot retains it:
> 
>   File-operation caller                Renamer
>   ---------------------                -------
>   load d_name.name
>   <preempted>
>                                        vfs_rename()
>                                          ocfs2_rename()
>                                            ocfs2_dentry_move()
>                                              d_move()/copy_name()
>                                        release rename name snapshot
>                                        RCU reclamation completes
>   trace callback sizes/copies
>     through the old name pointer
> 
> The pointer argument is evaluated before the trace wrapper protects
> probe execution, so that protection does not cover the old name
> across this window. Inline names and separately read lengths can also
> change while the event is being recorded.
> 
> Take a dentry name snapshot around each of these five trace calls and

Seems ocfs2_setattr() also risks the same race, and it is missed in last
review comments.

> pass both the string and its length from the snapshot. Inline names
> are copied and external names stay referenced until the trace call
> finishes. Check each event-enabled flag before taking a snapshot so
> disabled tracing does not incur snapshot work. The trace event class
> and its format stay unchanged.
> 
> The report below is from the read path; the other four call sites
> have the same unprotected name argument.
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
> ---
>  fs/ocfs2/file.c | 79 ++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 55 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index d6e977ba6565..3c4637b32c09 100644
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
> @@ -2392,11 +2405,17 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
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
> @@ -2542,11 +2561,17 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
>  	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
>  
> -	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
> -			(unsigned long long)OCFS2_I(inode)->ip_blkno,
> -			filp->f_path.dentry->d_name.len,
> -			filp->f_path.dentry->d_name.name,
> -			to->nr_segs);	/* GRRRRR */
> +	if (trace_ocfs2_file_read_iter_enabled()) {
> +		struct dentry *dentry = filp->f_path.dentry;
> +		struct name_snapshot name;
> +
> +		take_dentry_name_snapshot(&name, dentry);
> +		trace_ocfs2_file_read_iter(inode, filp, dentry,
> +					   OCFS2_I(inode)->ip_blkno,
> +					   name.name.len, name.name.name,
> +					   to->nr_segs);
> +		release_dentry_name_snapshot(&name);
> +	}
>  
>  
>  	if (!inode) {

This looks wried, the inode is dereferenced above in OCFS2_I(inode)->ip_blkno,
but checked below.
file_inode() returns filp->f_inode, so it seems inode is never NULL here.

Thanks,
Joseph
