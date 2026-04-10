Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0479C39E17E
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 08:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775809862; cv=none; b=nrd9Ao6hCrFtUT2ranowl7YNTdQQA6v4c3jwRzUgU20mmO6+UatG73A4R4TTPXKIT0zHevCf+Gr34di+3lqdKAJBd7Mk011miiESB6qjWQizAdNoOid/z404RBfE3sPuSURG/6JGS59PH32Znts3+aPgGepkzDG+6w1rz9m73y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775809862; c=relaxed/simple;
	bh=meBUagcQzf/KXW7vshrt/fhOQZUjImMG8jH98eCRy2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q1coN+8ccl2WYY92UmV8z1+K6PJDn9LoXhZC7yFiuaEBN7o6gFNBnlYmMVeIDsi+BRrwiaVz4pQhURB8hCZ1JSHpEP1g85BGCiXfNbfo8/71vy3HEDhQx39yaJW0GYAP8AIljs1zwIL/lnTecbpA0I4v3mYrxgW1TMwUz8fKyNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iLqLEGXe; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iLqLEGXe"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775809855; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sNiGueAduvX5NeS0ysrJUUhks+cuUI0I5tgI1l+Uv7Q=;
	b=iLqLEGXea+pds21+BlqDvmX9BxlrtIOe5zof1d+rDX7Cr7jqqF0Qo8LDYw0DL+GHjvxJh03dGaH7oEDv2ouuwjIGgOB+kQsUiYZE+LgvtA+xx3DK2MJAjexbhs/qYxCsdAKqF8U/+iWQDveyFZ7ID6OmPlm2w577ZWj0blQEqrs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X0kmyfg_1775809854;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0kmyfg_1775809854 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 16:30:54 +0800
Message-ID: <98810912-b89a-4409-8602-7f7c4a2074ef@linux.alibaba.com>
Date: Fri, 10 Apr 2026 16:30:52 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
To: Tejas Bharambe <thbharam@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org,
 syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, Tejas Bharambe <tejas.bharambe@outlook.com>
References: <20260410080445.29422-1-tejas.bharambe@outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260410080445.29422-1-tejas.bharambe@outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/10/26 4:04 PM, Tejas Bharambe wrote:
> From: Tejas Bharambe <tejas.bharambe@outlook.com>
> 
> filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
> as documented in mm/filemap.c:
> 
>   "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
>   may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."
> 
> When this happens, a concurrent munmap() can call remove_vma() and free
> the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
> becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
> dereferences it -- a use-after-free.
> 
> Fix this by saving the inode reference before calling filemap_fault(),
> and removing vma from the trace event. The inode remains valid across
> the lock drop since the file is still open, so the trace can fire in
> all cases without dereferencing the potentially freed vma.
> 

The commit log should also be updated.
Also do not send to stable@vger.kernel.org by default.

Thanks,
Joseph

> Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
> Cc: stable@vger.kernel.org
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
> ---
>  fs/ocfs2/mmap.c        |  7 +++----
>  fs/ocfs2/ocfs2_trace.h | 10 ++++------
>  2 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 50e2faf64c..6c570157ca 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -30,7 +30,8 @@
>  
>  static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  {
> -	struct vm_area_struct *vma = vmf->vma;
> +	unsigned long long ip_blkno =
> +		OCFS2_I(file_inode(vmf->vma->vm_file))->ip_blkno;
>  	sigset_t oldset;
>  	vm_fault_t ret;
>  
> @@ -38,11 +39,9 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  	ret = filemap_fault(vmf);
>  	ocfs2_unblock_signals(&oldset);
>  
> -	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
> -			  vma, vmf->page, vmf->pgoff);
> +	trace_ocfs2_fault(ip_blkno, vmf->page, vmf->pgoff);
>  	return ret;
>  }
> -
>  static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
>  			struct buffer_head *di_bh, struct folio *folio)
>  {
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index 4b32fb5658..6c2c97a980 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,
>  
>  TRACE_EVENT(ocfs2_fault,
>  	TP_PROTO(unsigned long long ino,
> -		 void *area, void *page, unsigned long pgoff),
> -	TP_ARGS(ino, area, page, pgoff),
> +		 void *page, unsigned long pgoff),
> +	TP_ARGS(ino, page, pgoff),
>  	TP_STRUCT__entry(
>  		__field(unsigned long long, ino)
> -		__field(void *, area)
>  		__field(void *, page)
>  		__field(unsigned long, pgoff)
>  	),
>  	TP_fast_assign(
>  		__entry->ino = ino;
> -		__entry->area = area;
>  		__entry->page = page;
>  		__entry->pgoff = pgoff;
>  	),
> -	TP_printk("%llu %p %p %lu",
> -		  __entry->ino, __entry->area, __entry->page, __entry->pgoff)
> +	TP_printk("%llu %p %lu",
> +		  __entry->ino, __entry->page, __entry->pgoff)
>  );
>  
>  /* End of trace events for fs/ocfs2/mmap.c. */

