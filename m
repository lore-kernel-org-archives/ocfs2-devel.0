Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3F6199FAB
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 03:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775101638; cv=none; b=NUnLF/8ykOTHUWKIlxiRiMQiCX2DSXL4CsKMPHJdgsBObPTJ4JmFmlT3FTmd3GpDRE1J5nLmgaXFrfSsmpCPJaTay/Fa9nLNhGwe0+QU/drXGQ6/sirixr49IUJw8mG2yJL9ZAiF+UK13RnTxy8V6fVfgwvuIBXw36sHMNCdwSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775101638; c=relaxed/simple;
	bh=6WpJm91BnTb/nme//9KT0fM/4w5SvxmpdZncsUMgp48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/2DVYVy4MDXCMYV+wF6RD6x+kKLiVfem2d6k5DqhJX0OF40t7b68HF30642is7BGn9DUdS3LKptmRyEhTvqXPT08uWRHe0fMq20dZvfuwHmSaDaOJa1i+iR8DhykSX4wTDE4U73V+Sd4270EYabqSgFLSwwhTq+hVMVji3NRLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=N0UoiLwN; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="N0UoiLwN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775101634; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lG/ZlrO3wWrfeYUwtsWNGM007bGBADhKy9/XjxVU5Tk=;
	b=N0UoiLwN0cPlwae05lfgCbzxJmcqzvLs3shgNGjxkpXvC0+BD68XM0Tsyjy9inKmcsXzpmO7A8OJatkKm807ku2j4NIm/uu3WXxonyuIPTM2QGrfuEXwGdmoKPwI9RAPtPFJMfgFk9BuK3QiUAPSGoRJVYBVwm9KKXSjHbZwm50=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X0FsID5_1775101633;
Received: from 30.221.145.69(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0FsID5_1775101633 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 11:47:14 +0800
Message-ID: <183fdc2a-b6f9-4ffb-8d12-a5ead1b0d207@linux.alibaba.com>
Date: Thu, 2 Apr 2026 11:47:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
To: tejas bharambe <tejas.bharambe@outlook.com>,
 akpm <akpm@linux-foundation.org>
Cc: "mark@fasheh.com" <mark@fasheh.com>,
 "jlbec@evilplan.org" <jlbec@evilplan.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
 <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <JH0PR06MB6632E1E416539AAF508ECAB28951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <JH0PR06MB6632E1E416539AAF508ECAB28951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/2/26 11:08 AM, tejas bharambe wrote:
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
> Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/mmap.c        |  6 +++---
>  fs/ocfs2/ocfs2_trace.h | 10 ++++------
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 50e2faf64c..41c08c5a3d 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -30,7 +30,7 @@
>  
>  static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  {
> -	struct vm_area_struct *vma = vmf->vma;
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	sigset_t oldset;
>  	vm_fault_t ret;
>  
> @@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  	ret = filemap_fault(vmf);
>  	ocfs2_unblock_signals(&oldset);
>  
> -	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
> -			  vma, vmf->page, vmf->pgoff);
> +	trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
> +			  vmf->page, vmf->pgoff);
>  	return ret;
>  }
>  
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

