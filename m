Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B77175A6A
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 03:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100759; cv=none; b=FzTTmLRPvVBKt/hG7tV1uU3cZ7Lc/37+iXZxcwLg/CLK76lnmCa61KSPEdsmCT7pugnYLBpdaaYxFll9z7+wiNfCz1cm6KYaGteQCJ66OBtFxrAG7cDd8EGV2b+9yiszmEXr1Q8+CiKgEhKYMPIHNrR8zL0hC4rahu5DFuFpM+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100759; c=relaxed/simple;
	bh=a5+LTNgi9SF6V3+WYt8pBmlA/+4lzfs/jlyRot70miw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NebYDGPzfECOYBuNphaumnaCcQcmAeUEIZmaFSaqfbql0oldqkJjDDPx12rKT+c0wzLbbsNWRXVsWf0z9gFaNSTCUXroVA/D5Y/21PUZdXmt36bXlY8/APAYfhPfFAkxU4Q3UTm/D+f6hSQ1qnGH4q8m7znVxpYWRZfZFaWjtsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wgFLGhp/; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wgFLGhp/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775100747; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=puBaTayvDqxUGG5DuWoaou08x+t9vvFx+Z5qWssasnM=;
	b=wgFLGhp/wEmPWJBzZYVPl7Z2HjV6qeG1hxZlJrHCZuvhpVSGl1dm6jb1Mrl2M3jSlLKLRI9GxjPIju1KqgW4a4oKqPVrLzupbMZq+RZ1Ct9V+lSYVMOUHNUb8PaurjIwcGjMQYmsy3yTXQS+pdyPOX+UllnRAD7QTCEj9gGdo/U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X0Fooxo_1775100746;
Received: from 30.221.145.69(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0Fooxo_1775100746 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 11:32:27 +0800
Message-ID: <df2da2fb-c222-430e-83d6-1855ab34272d@linux.alibaba.com>
Date: Thu, 2 Apr 2026 11:32:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
To: tejas bharambe <tejas.bharambe@outlook.com>
Cc: "mark@fasheh.com" <mark@fasheh.com>,
 "jlbec@evilplan.org" <jlbec@evilplan.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
 <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <JH0PR06MB663236841A642C2D058C1FD28951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <JH0PR06MB663236841A642C2D058C1FD28951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 4/2/26 11:10 AM, tejas bharambe wrote:
> filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
> as documented in mm/filemap.c:
> 
>   "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
>   may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."
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
> ---
>  fs/ocfs2/mmap.c        |  6 +++---
>  fs/ocfs2/ocfs2_trace.h | 10 ++++------
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 50e2faf64c..41c08c5a3d 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -30,7 +30,7 @@
>  
>  static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  {
> -	struct vm_area_struct *vma = vmf->vma;
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	sigset_t oldset;
>  	vm_fault_t ret;
>  
> @@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  	ret = filemap_fault(vmf);
>  	ocfs2_unblock_signals(&oldset);
>  
> -	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
> -     vma, vmf->page, vmf->pgoff);
> +	trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
> +     vmf->page, vmf->pgoff);

Seems malformed?

>  	return ret;
>  }
>  
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index 4b32fb5658..6c2c97a980 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,
>  
>  TRACE_EVENT(ocfs2_fault,
>  	TP_PROTO(unsigned long long ino,
> -   void *area, void *page, unsigned long pgoff),
> -	TP_ARGS(ino, area, page, pgoff),
> +   void *page, unsigned long pgoff),
> +	TP_ARGS(ino, page, pgoff),
>  	TP_STRUCT__entry(
>    __field(unsigned long long, ino)
> -  __field(void *, area)
>    __field(void *, page)
>    __field(unsigned long, pgoff)
>  	),
>  	TP_fast_assign(
>    __entry->ino = ino;
> -  __entry->area = area;
>    __entry->page = page;
>    __entry->pgoff = pgoff;
>  	),
> -	TP_printk("%llu %p %p %lu",
> -    __entry->ino, __entry->area, __entry->page, __entry->pgoff)
> +	TP_printk("%llu %p %lu",
> +    __entry->ino, __entry->page, __entry->pgoff)

Ditto.

>  );
>  
>  /* End of trace events for fs/ocfs2/mmap.c. */
> --
> 2.53.0
> 

