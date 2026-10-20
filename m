Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792461694;
	b=JrU13Sq/Y492Ky3HHyzW4M74iw3oR79DEvvMHVYmQBkyYXz6pbShzjJ6WO3bQDy8WP9Z
	 eTsZe/hz6lqvRKn4fgxTVj4L9HDKbl/XllMSnckyQCUrmqQeixXdglQ04w74FfwjlX7xK
	 /8APGSMkiZeDQtq7ZnTB/agNB5B94Dgr7IVq4m/V8QYRQzgxO+DB559wcD1esX3ejHLcq
	 426x3mdBVo7HQowFTdPVTAJT0podgNGs1yirBe9NKrJj6NSBl8J+FbfO1hxjFw0xIFCsv
	 plsEy++zaTTSIndNh9K2jrLnKNE9ABdkhn2GJ4Osrk6XKtLw0YygrUpQcW5BdDYhEMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792461694;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=wnaxOSSamcwglqOAKuHSshc8q0Bth/jG+/jg/lNxKrs=;
	b=uiFkKUO0aE1kM+2/KXNGrG6YLeEInMDulD4l1eE6YX7mPeSqh1GCaNIP0WPkJh77Rvv5
	 s616vxltOCOPO7RCvfMJ2siE03Ihz7exTTrUDClhUVQo9Y+v31pzOIQPkIAB3YUVSug2o
	 rWCUIu9Q1l/0+OoxdMnaRbbDgpVWxEH4gb01OjOjNk4KWyz+cDQ+K3UxkSDQTwchK4qAe
	 aYZ9vYYYHWQAlE1QNdkGI5BsEE8c8CDEnlqy0bFA26gF6Qzl6pP+TWWk/QhFLaMmPscq2
	 0NE40icXHse/98DvxGgOqZ/pqT01nERQrq/uENjZ259FH2kEIQ7hDq67G3/WkG0GoUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=lmX2gm15;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34287606A319
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 02:01:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34287606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=lmX2gm15
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792461689; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wnaxOSSamcwglqOAKuHSshc8q0Bth/jG+/jg/lNxKrs=;
	b=lmX2gm1505iNXpP5s5eTRqx+l/axR0lmuicIMM9ZEiXF3yrZK84b4NQJC4Lu1KVras082eqAmSiaPeIdcD0Q6+WCbLRzScUTSIojSxp1ZB5TBPf25qSO1m+fdF/K5W1y98sHYhm9DiWpJVJ2YkdhaUqA1jhddiE7q/3kfr6TB7k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDB87H3_1792461687;
Received: from 30.221.145.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDB87H3_1792461687 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Oct 2026 10:01:28 +0800
Message-ID: <2f07abae-1675-46d3-8142-c7dd335b671c@linux.alibaba.com>
Date: Tue, 20 Oct 2026 10:01:27 +0800
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
Subject: Re: [PATCH v2] ocfs2: stabilize the dentry name while tracing reads
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0088-v4-a9a0df898afb4fc65fa0@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0088-v4-a9a0df898afb4fc65fa0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/26 1:36 AM, Cen Zhang wrote:
> An open file pins its dentry, but not the external allocation backing
> an individual dentry name. ocfs2_file_read_iter() passes d_name.name to
> its trace event without holding d_lock or a name snapshot. The event's
> __string field needs those bytes for both strlen() sizing and the
> subsequent copy.
> 
> With the read event enabled, a read of an open long-named file can be
> preempted after evaluating the trace argument. A successful concurrent
> long-to-short rename of the same dentry can then reclaim that name,
> provided no other name snapshot retains it:
> 
>   Reader                              Renamer
>   ocfs2_file_read_iter()
>     load old d_name.name
>     <preempted>
>                                       vfs_rename()
>                                         take_dentry_name_snapshot()
>                                         ocfs2_rename()
>                                           ocfs2_dentry_move()
>                                             d_move()/copy_name()
>                                         release_dentry_name_snapshot()
>                                       kfree_rcu() reclamation completes
>     trace callback calls strlen()
>       through the old name pointer
> 
> The pointer load precedes the rename, and sizing follows reclamation,
> so strlen() reads freed name storage. The tracepoint's SRCU section
> protects its probes, and the event callback disables preemption only
> after the caller has loaded the name pointer.
> 
> Take a dentry name snapshot before tracing and release it after the
> trace call. The snapshot copies inline names and pins external name
> storage, keeping both the string and its length stable while the event
> sizes and copies the name. This avoids holding d_lock across trace
> callbacks. Check whether the event is enabled before taking a snapshot
> to avoid adding snapshot work to reads when tracing is disabled.
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
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> Assisted-by: LLM
> 
> ---
> Changes in v2:
> - Replace d_lock around the tracepoint with a dentry name snapshot so trace
>   callbacks run without the caller holding the dentry lock.
> - Pass both the name and its length from the snapshot; keep the event
>   enabled check and release the snapshot after the trace call.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0088-v3-d628f98bfcb6784a0bfb@gmail.com
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index d6e977ba6565..fc357c227ad8 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2542,11 +2542,17 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
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
> +					   to->nr_segs); /* GRRRRR */
> +		release_dentry_name_snapshot(&name);
> +	}
>  
>  
>  	if (!inode) {

The change looks fine.
Six call sites feed the same ocfs2__file_ops class, which has the single
__string(d_name, d_name), so it seems we'd better send a series to fix
all of them:
  trace_ocfs2_file_open
  trace_ocfs2_file_release
  trace_ocfs2_sync_file
  trace_ocfs2_file_read_iter
  trace_ocfs2_file_write_iter
  trace_ocfs2_file_splice_read

Thanks,
Joseph
