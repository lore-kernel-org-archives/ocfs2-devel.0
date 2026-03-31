Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0762D3ED128
	for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950952; cv=none; b=dFTKP3AKzVsFv2SEzZT83P60TfOK2kvKMIVBw/hmQtBPE7Bj1q3XR49N/IBsSs78cefuxO2Lht+GuNkZaxQG86lVCnkv1wfZCHoKaheNu+N1qNRD34gH69JJIxygextIqCYWGcLWItA9KB5MMY1lOToVwbRte3gZErv78tga4Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950952; c=relaxed/simple;
	bh=LwcG9Er8QoZv+gFx/UCw6laGYaNGTvatnlzqNu1sqAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvoHz2pTLwMlYdaH4n4o5NG3Wi0+vKmuSutDGuwlW+bqn/GPI4BIfy2uCLlqOPiVyr1DizeVKbnVWDT2s0Lk8kSu738CXDgYhP+AjhxCKALGIhb/2yyfSnN4/vNyXfGLfqVuwIWCHZKnVfevl9+nhMXkdvcoLPSx9MjhD6dE39Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QUMCPbtm; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QUMCPbtm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774950947; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=w8SWplK25ZIJxu8mwVTMYiHp0d/cTLaUxOWTL3QmcrU=;
	b=QUMCPbtmVjWsld232H5m5Ht6/f2T62c5n8o+Hkk8d5jbAKmjWZmdKj8IVvzrb2EnhdDEcvcrnB0zcysEXOpMREu3VrBki+lBSu/mTyaBbT8X23SDCDyTI+EEL4W69c9ppRzGoYuXZ8O11R0YQ36jKzcOVdrtlQEKZC40spHI8Vo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X03ylgp_1774950946;
Received: from 30.221.145.64(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X03ylgp_1774950946 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 17:55:46 +0800
Message-ID: <5f7200f6-41b6-438b-bd22-461ea651ebf6@linux.alibaba.com>
Date: Tue, 31 Mar 2026 17:55:45 +0800
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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <JH0PR06MB663281D3B927A61AAA2BDAA08953A@JH0PR06MB6632.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/31/26 2:20 PM, tejas bharambe wrote:
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
> Fix this by returning early when VM_FAULT_RETRY is set, skipping the
> trace that dereferences the potentially freed vma.
> 
> Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
> ---
>  fs/ocfs2/mmap.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 50e2faf64c..adf6423ae9 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -38,6 +38,14 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  	ret = filemap_fault(vmf);
>  	ocfs2_unblock_signals(&oldset);
>  
> +	/*
> +	 * filemap_fault() may drop the mmap_lock and return VM_FAULT_RETRY.
> +	 * In that case the vma may have been freed by a concurrent munmap(),
> +	 * so we must not dereference it.
> +	 */
> +	if (ret & VM_FAULT_RETRY)
> +		return ret;
> +

How about change it like this:

Remove vma from ocfs2_fault trace event. Then

struct inode *inode = file_inode(vmf->vma->vm_file);
...
ret = filemap_fault(vmf);
...
trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno, vmf->page, vmf->pgoff);

This can keep trace event in all cases.

Thanks,
Joseph

>  	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
>  			  vma, vmf->page, vmf->pgoff);
>  	return ret;

