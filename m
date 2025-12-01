Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D185D3002DF;
	Mon,  1 Dec 2025 09:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764583011; cv=none; b=q+zNE4MrsmzJaOHKxOZq75cisIuasecyeFKohUongtcOT8b799gXhvJfqqxDfjM5KsNwzZxwJUiOQdzXVGHPUYG8f3CEuhfE5dS2qVIugdXua50O1k/9+SLkWBIzfCrC1LOCxOGsrljOgz1WSwTLvQvoIFOvkclfwuzyTjaGpdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764583011; c=relaxed/simple;
	bh=0741VqD7rQZoGULYdAYLBHLWiFwdSlYmacBxnqit0XQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QIrTQMAZGEPfh0t5zJwBVcEBbdImNXryslj3z4g4O0vUuRogrn3TDmopYgodcE7UJd+h1uMSqgliS6n+0Cw+74yMyE6LTB3qK3vC4YL5uPM8FCjhD3PfxxciMYW6TeZLzM+6w9CoHWTeqPuM58NNA0speHAGbXgLfVvXGHWMhKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mabxn8Or; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mabxn8Or"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764583005; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Q2Q+D3JvL0e9Lyrus7NV2+aMElmrM7D00PDkV3l5gPo=;
	b=mabxn8Ort1Tg16PDEOyQo2s19Bi5Em8MrKaF0cEY9lIaeMkZu4JFF8I8p9C4u5VbD3EjRuQeXSeTA9W5klAy47b0vbg6L2ywInUogA41OE7nMJ4SX8er9FLmR0QHu+0vQUhvESoX23t+Zg2UjH0r/sDo5irpMutLlo/64Bj2vUs=
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wtp9WvP_1764583004 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Dec 2025 17:56:45 +0800
Message-ID: <fa898d5b-ac9d-44bf-ab98-a520f89dbc28@linux.alibaba.com>
Date: Mon, 1 Dec 2025 17:56:43 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix kernel BUG in ocfs2_find_victim_chain
To: Prithvi Tambewagh <activprithvi@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com, khalid@kernel.org,
 syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
References: <20251201092450.84991-1-activprithvi@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251201092450.84991-1-activprithvi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/1 17:24, Prithvi Tambewagh wrote:
> syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
> `cl_next_free_rec` field of the allocation chain list is 0, triggring the
> BUG_ON(!cl->cl_next_free_rec) condition and panicking the kernel.
> 
> To fix this, `cl_next_free_rec` is checked inside the caller of
> ocfs2_find_victim_chain() i.e. ocfs2_claim_suballoc_bits() and if it is
> equal to 0, ocfs2_error() is called, to log the corruption and force the
> filesystem into read-only mode, to prevent further damage.
> 
> Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
> Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> ---
> v1->v2:
>  - Remove extra line before the if statement in patch
>  - Add upper limit check for cl->cl_next_free_rec in the if condition
> 
>  fs/ocfs2/suballoc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..1257c39c2c11 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1992,6 +1992,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  	}
>  
>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
> +	if (!le16_to_cpu(cl->cl_next_free_rec) ||
> +	    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
> +		status = ocfs2_error(ac->ac_inode->i_sb,
> +					"Chain allocator dinode %llu has 0 chains\n",

The log message also has to be updateed. How about:

if (!le16_to_cpu(cl->cl_next_free_rec) ||
    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
	status = ocfs2_error(ac->ac_inode->i_sb,
			     "Chain allocator dinode %llu has invalid next "
			     "free chain record %u, but only %u total\n",
			     (unsigned long long)le64_to_cpu(fe->i_blkno),
			     le16_to_cpu(cl->cl_next_free_rec),
			     le16_to_cpu(cl->cl_count));

Joseph

> +					(unsigned long long)le64_to_cpu(fe->i_blkno));
> +		goto bail;
> +	}
>  
>  	victim = ocfs2_find_victim_chain(cl);
>  	ac->ac_chain = victim;
> 
> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3

