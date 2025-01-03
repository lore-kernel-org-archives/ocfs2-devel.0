Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7E82594A0
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 01:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735867525; cv=none; b=XaFoFGq7b9sE29ywb31eKMF2h4EV1GUMsAjz9g4wTqJC6ilZEy+ikqsueQihGVDLRXJ273ZYwM0owwuy+GGMps8USNBqYUfzYgRl/E1FjhK14aZcDPNNCbfzrcopeVfRwR8y/hF+lcnjvCXBv1QE2NNTHEJQdML9ShiJPKubYTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735867525; c=relaxed/simple;
	bh=6PS2/lvxvvtsj3UyzkFKDCWhDOK60icsH637llenaEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nhZZW+R4v5eq8oEVWhmZYEz33mWjLZwK8/YqeesVn0kaQfY9q3lWGtkpQ8NBr9X9yyrjWwRM/McXLZLlDD0QX5IQn5aI2rvd0rcyabAznnxmEwrRYD5xuTckHkDiZsrHnXJuUi0AYjtDw4ZFUxEaeZT41YXCjey5FRQrJnU/KUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xvF3a5hT; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xvF3a5hT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735867520; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wcH6VC2+aXaqTv0YKNAq7xTtWo28VC2OZ6vPjjwupqw=;
	b=xvF3a5hTfw0j4EXtyd/6jDn8k0428Ypvrq2fz5qgFLHpj2WP38lajlTgCf3e515YQ/E6v/+Tv5ODuGuCxy2eds7NV3EX+hmkWerBoJv04raNYJWqhgPGKEWIKStAhCOiytonU7UGJw7qP9IhIkQ4r3k6C9r6I979ILl8qn3UiZ0=
Received: from 30.221.128.253(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMrO6do_1735867199 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jan 2025 09:20:00 +0800
Message-ID: <617e1774-eee0-4a00-ad03-d5b707a101f1@linux.alibaba.com>
Date: Fri, 3 Jan 2025 09:19:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: Add a sanity check for corrupted file system.
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com, jlbec@evilplan.org,
 syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
References: <20250102124539.711325-1-sunjunchao2870@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250102124539.711325-1-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Actually this is v2.

On 2025/1/2 20:45, Julian Sun wrote:
> Hi,
> 
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
> index f7672472fa82..83d3343b3e3c 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -435,6 +435,15 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  		}
>  	}
>  
> +	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
> +		ret = ocfs2_error(inode->i_sb, "Invalid dinode #%llu: next_free_rec is %u, count is %u\n",
> +				  (unsigned long long)di_bh->b_blocknr,
> +				  le16_to_cpu(di->id2.i_list.l_next_free_rec),
> +				  le16_to_cpu(di->id2.i_list.l_count));
> +
> +		goto out;
> +	}
> +
>  	i = ocfs2_search_extent_list(el, v_cluster);
>  	if (i == -1) {
>  		/*

