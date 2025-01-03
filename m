Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429EA1B87EC
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 09:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735898022; cv=none; b=kY1TTatQBmOWHSYfWQ2yXisZZ5whOsMvQp/sZVOrl5xBIUt0SqeZNX8nNJZH9w7vzfs9gzRFHbeqmzxLaLhlEDsPZ/G3aryc5qQ6SvsTpFl8PD+B3PvaHGQjkFEtZCOHjdkc2DeQt1oPgxmoEjfMqP00YA9pydqezdr26a0oJJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735898022; c=relaxed/simple;
	bh=UN7WtBTx+Ct6Owu8cpUfqHiiPddQDMMNVxPioDxUxC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DBLNz4wNl0tP8HV6G9IUIAOcT7s/R0TqdFGd8te0NDGyc/ptOMSXNZ2OwAL3rRR0Xoa0iuxu9k24XBKzZaDHAsMqOwi6vijcduZdm8eGeWSIEIR5IpMrf+hecJVko3cQyEj90dmPC77YY1uzKxvUP+lr/8yOFadJOcv7qsoFsBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HQ9rF7iu; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HQ9rF7iu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735898011; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=POeXsEOCs3Tt+yIWKPdgUtQozq497AY0uH8+rELRyi4=;
	b=HQ9rF7iuj72JEvk03BwAxK9wqu412+lI8QEq2MSEcosjQOgjM87UUEYBoNXqTmBkxjwa6OjPQQn/EZcwUAuXazh9A5ep/lGJ5C6rYqEAfYbhRtmdKNwNjhJP6bMt4XwwnYIH1U6F5sVw1EOO7bMmlpx2Xgymvzx7j+fbG/XU3Q0=
Received: from 30.221.128.253(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMss5Fd_1735898009 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jan 2025 17:53:30 +0800
Message-ID: <908a2822-28d0-4f79-a49a-28998885f174@linux.alibaba.com>
Date: Fri, 3 Jan 2025 17:53:28 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] ocfs2: Check el->l_next_free_rec in
 ocfs2_get_clusters_nocache
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com, jlbec@evilplan.org,
 syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
References: <20250103050202.825893-1-sunjunchao2870@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250103050202.825893-1-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/3 13:02, Julian Sun wrote:
> Hi,
> 

This is not suitable in commit log.

> Recently syzbot reported a use-after-free issue[1].
> 
> The root cause of the problem is that the journal
> inode recorded in this file system image is corrupted.
> The value of "di->id2.i_list.l_next_free_rec" is 8193,
> which is greater than the value of "di->id2.i_list.l_count" (19).
> 
> To solve this problem, an additional check should be added
> within ocfs2_get_clusters_nocache(). If the check fails, an error will
> be returned and the file system will be set to read-only.
> 
> [1]: https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@google.com/T/
> 
> Reported-and-tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2313dda4dc4885c93578
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> ---
>  fs/ocfs2/extent_map.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index f7672472fa82..04794ac228d8 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -435,6 +435,15 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  		}
>  	}
>  
> +	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
> +		ret = ocfs2_error(inode->i_sb, "Invalid dinode #%llu: next_free_rec is %u, count is %u\n",
> +				  (unsigned long long)di_bh->b_blocknr,
> +				  le16_to_cpu(el->l_next_free_rec),
> +				  le16_to_cpu(el->l_count));
> +

Or change it to:

	ocfs2_error(...);
	ret = -EFOFS;

To be consistent with l_tree_depth check.
Also it can decrease code indent.

Thanks,
Joseph

> +		goto out;
> +	}
> +
>  	i = ocfs2_search_extent_list(el, v_cluster);
>  	if (i == -1) {
>  		/*

