Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AB6339B41
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 03:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775014105; cv=none; b=IPwRkdkHq0rs3dMqA0J2d6lj7IwcKvozW4hOy51foyvili9htAw7RiSC+MGwq5UlKp/otr2Ez5Sz1JTF/yo8pXAE6lhiJ/Rdmrke6G53e/RHVmRv3tOBij2ilAyiceMxYRpety3pWuxtOtU1UwwytB7Io/B43lV4bOGpi3aOai0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775014105; c=relaxed/simple;
	bh=iOBtZq2FQV7zby5EmATd1pXC6ILvaGEebb6vGUBIjYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lhJGNKfB/5x27PhBZvFl9w5ntTaasD6dJR28hioUApfcXEF98SdS65hwlYAhdIbdmUjl3w4vQ13GRq11YlwoqIUefK84LJcUwHCAvuoTu7I6P6ior+TWWlbC5rRaacuMPK7zwY4ZQ1cs7U39w7JE/Z5pe5XloP4zOHIcTgRtxAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bNkKsxOo; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bNkKsxOo"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775014099; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=m1xFu2uwUxuA+kQ5clFDyHsazE4yNF0cgDLfMtwyD00=;
	b=bNkKsxOowquAid80amHf6yD2BpX8BEeLOg9Ee3Cx1dwYJv761TzcMD8gVIYFr+73OxwC1gyvqa4mc1W9pWMYe1RH2UAhQOV32/19qMEb/V70DJUWGSiqGp3Bm5HtsVZyOwMqbMu0nsreVsyuX1JwWUe4Xf+JGPcKT39EqDBwwZE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X06pIha_1775014095;
Received: from 30.221.145.27(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X06pIha_1775014095 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Apr 2026 11:28:18 +0800
Message-ID: <b403e0e7-7269-4e38-9855-5a6a41b2bea0@linux.alibaba.com>
Date: Wed, 1 Apr 2026 11:28:13 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
To: tejas bharambe <tejas.bharambe@outlook.com>
Cc: "mark@fasheh.com" <mark@fasheh.com>,
 "jlbec@evilplan.org" <jlbec@evilplan.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
 <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
 Heming Zhao <heming.zhao@suse.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <JH0PR06MB663281D3B927A61AAA2BDAA08953A@JH0PR06MB6632.apcprd06.prod.outlook.com>
 <5f7200f6-41b6-438b-bd22-461ea651ebf6@linux.alibaba.com>
 <JH0PR06MB66326B03AB7ABB7E40C0A2398950A@JH0PR06MB6632.apcprd06.prod.outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <JH0PR06MB66326B03AB7ABB7E40C0A2398950A@JH0PR06MB6632.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

It looks fine to me.
Could you please send a formal patch based on the mainline?

Joseph

On 4/1/26 11:24 AM, tejas bharambe wrote:
> Hi Joseph, 
> 
> That is nice.  
> Did the following:
> 1. Using inode
> 2. Removed vma (had to update the ocfs2_trace.h as well)
> 
> Thank you for the suggestion
> 
> Please find v2 below:
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
> Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
> ---
>  fs/ocfs2/mmap.c        | 14 +++-----------
>  fs/ocfs2/ocfs2_trace.h | 10 ++++------
>  2 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index adf6423ae9..41c08c5a3d 100644
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
> @@ -38,16 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  	ret = filemap_fault(vmf);
>  	ocfs2_unblock_signals(&oldset);
>  
> -	/*
> -	 * filemap_fault() may drop the mmap_lock and return VM_FAULT_RETRY.
> -	 * In that case the vma may have been freed by a concurrent munmap(),
> -	 * so we must not dereference it.
> -	 */
> -	if (ret & VM_FAULT_RETRY)
> -		return ret;
> -
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

