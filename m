Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24867260F;
	Mon,  1 Dec 2025 02:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764557523; cv=none; b=tRl0exLHLzUBKvNwF0QfR58VpWQ0Yrz/sfnniISSLtWSWOKFrcS0AARDK25bqC3hbJblYfkIYClVYYCUJ2PeTCoy1BY7jNLb556S2X/pVYwfWVX7o/Ndpuna7yzvMBz7+RwRuInenu5Oo99hb4URVLlDbosl8FLEZUKVHZ0smDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764557523; c=relaxed/simple;
	bh=SsKVj6swBFW5RFW+TWrIMIm84saB4za7AaAzjKec2eA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K1V3NojS3f2rz5Ca+T1m6bYKjAM7x5aYE8TTabmoiaKknJDQHbnuJ1R2ZPXnqz/ju8f78H1McnPNclQzfg5kXT4f9dcSm9bb9Suk24GtlFgvb2rTIBtccH1rAguzX7hGsaJ2MjYk2NMPT3FZ2sW+sOSajnFDmT9JBp0AyXF837g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WHnhKjx+; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WHnhKjx+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764557511; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5tbmBQnkx11LaNGtFZDscSuQ3/UEG61lPv1bDzgXx+8=;
	b=WHnhKjx+S5953ll9WESUJ5tG/NdN6+LzLTVozm6fQyrZx155Y6El3cEVSL7xWPVFMqsafBwgQtTQqU0ZrNoJp2yWC2ppEK9aLUPXdYIY4Kzkj0mjvi6lImhJZ0uJ7BtnShGfOdsPYY5b5aq3s1rBHwiPNDbE8ECUXBnAqJ65P04=
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wtl.o-a_1764557509 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Dec 2025 10:51:49 +0800
Message-ID: <6d27a5aa-1e32-4dd3-997c-ddc015be88a3@linux.alibaba.com>
Date: Mon, 1 Dec 2025 10:51:49 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
To: Prithvi Tambewagh <activprithvi@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com, khalid@kernel.org,
 syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
References: <20251130104637.264258-1-activprithvi@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251130104637.264258-1-activprithvi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/30 18:46, Prithvi Tambewagh wrote:
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
>  fs/ocfs2/suballoc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..84bb2d11c2aa 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1993,6 +1993,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  
>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
>  

This blank line can be eliminated.

> +	if (le16_to_cpu(cl->cl_next_free_rec) == 0) {

Better to add the upper limit check as well. e.g.

!le16_to_cpu(cl->cl_next_free_rec) ||
le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)

Thanks,
Joseph

> +		status = ocfs2_error(ac->ac_inode->i_sb,
> +				     "Chain allocator dinode %llu has 0 chains\n",
> +				     (unsigned long long)le64_to_cpu(fe->i_blkno));
> +		goto bail;
> +	}
> +
>  	victim = ocfs2_find_victim_chain(cl);
>  	ac->ac_chain = victim;
>  
> 
> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3

