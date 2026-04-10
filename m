Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD0A3C4566
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 09:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775813782; cv=none; b=dq/fkKI/OZ/fyPcOv1I+A2YCH/jeLE7zpbEMbuWlk/kIz459wgwBtSIIfQQtBsjkRaVuuhnMaIXUIRBqjYM5AvCuQLtWQkhlcbaHsynZ9UpdPz7YKoAFUzBLNL9yYrA3NIylxHwMXnqjvzWg1n2XblIkOcLNGFQW2TGPohKcB2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775813782; c=relaxed/simple;
	bh=Q5HqopVXvznleLB8sZzZR6yynZqS6k/x5nz4bYiW6KQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cFcVf3PmkQu0Hb/Wnw+X6Y1NVxHe9oUYcQKPZXPI3u8OF+UcPaCLlltgHESuDhiK8CWH/Nh3Gkk+Cm3wBNOIZwh1E0xUPPkbY2RFKqd3SVARxz/a+cxrK/becWFxT/Yv5sDDFIHsGWt8YLaCw/fPw+fv0KRdFz5ExCL09w8l3y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TiD7sBlV; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TiD7sBlV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775813776; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O6OOi/TQIpkEhMUuaXrYZqVvrAPcV8lAWcJSeUUufEE=;
	b=TiD7sBlVgnXBK2ugvtQycW8ydh0OklH+570v68lLxQAZoo4FcmgVx9wJCKosbmQaL9ctTWcqh9xBjji6oki8amnjyTMTT0pJ8akwMsQPooDSgTIl/DPH4V4xjoLuD5ns/kKtZ08F3Eq1i7fipZpXL/ASY/VGE4anjwJMrnLqcvE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X0kxdqs_1775813775;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0kxdqs_1775813775 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 17:36:16 +0800
Message-ID: <f6a98534-32d9-48fd-a2ff-da57b0e478a6@linux.alibaba.com>
Date: Fri, 10 Apr 2026 17:36:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
To: Tejas Bharambe <thbharam@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org,
 syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com,
 Tejas Bharambe <tejas.bharambe@outlook.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <20260410083816.34951-1-tejas.bharambe@outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260410083816.34951-1-tejas.bharambe@outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/10/26 4:38 PM, Tejas Bharambe wrote:
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
> Fix this by saving ip_blkno as a plain integer before calling
> filemap_fault(), and removing vma from the trace event. Since
> ip_blkno is copied by value before the lock can be dropped, it
> remains valid regardless of what happens to the vma or inode
> afterward.
> 
> Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>

Fixes: 614a9e849ca6 ("ocfs2: Remove FILE_IO from masklog.")
Cc: stable@vger.kernel.org
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

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

