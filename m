Received: from out199-10.us.a.mail.aliyun.com (out199-10.us.a.mail.aliyun.com [47.90.199.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C1533EC
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jan 2025 06:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735800497; cv=none; b=ZDIhY8Y3kbGSd48j7Ge+kU+yRAAKyJ3VvVoMpIzq/WYuCuyMT97hpt38UpL0AgGZbC9i7j0FRv/I+rhbZWC08c36sOAPge+ThXbDC0C9HwaXxyeAo4Rshl830H432bAiPdpQhaQKmYxz/3JyFW/52idlrrN3EY4BOYRfIf0aXpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735800497; c=relaxed/simple;
	bh=JskNzxiSiDHw6CopiWCM3v/YSsciPYQKsWGwouJS+sE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EvYqDA3sHPIAeXCRSkf1hTPUA9N8+Lfm091qOdqaO6vGIDm4hhIoMnsiQxwBFZ6P8EVArLXPvgDiTIRV5HdSb3IP2VOVtU0LZtoWVY6tHoiJ/PKKdx2+0tTbdL7dOteF9qAOQxay4huQqGUH7OWCdcyZhyV8BloIZOYpVgvgOYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aocQveU4; arc=none smtp.client-ip=47.90.199.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aocQveU4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735800475; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=44535r1crqXmpfk/Den1pnrnV+7x91sG3iGyN2k9pjU=;
	b=aocQveU4TpSQbyr+Fz5l+hJfwr17VzRoHMVP2asn4FlkyYDlx2IY4VgviOTp//1+dHni6yhay1HNfilLfqMsEmjuijnGwaGrZbAD+XaNrS+4Lat4YBNCQrXEzxmq4i04U3eaSBggBNXBee0fsQFuce/CeJ9U0MWoksz6VyQm4Dk=
Received: from 30.221.129.127(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMl166E_1735800473 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Jan 2025 14:47:54 +0800
Message-ID: <daf3251d-0b20-4e87-8988-bb1d098d7c74@linux.alibaba.com>
Date: Thu, 2 Jan 2025 14:47:53 +0800
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
References: <20250102035321.391540-1-sunjunchao2870@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250102035321.391540-1-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/2 11:53, Julian Sun wrote:
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
>  fs/ocfs2/extent_map.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index f7672472fa82..7fdbecb9c031 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -414,6 +414,16 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  	el = &di->id2.i_list;
>  	tree_height = le16_to_cpu(el->l_tree_depth);

Move this down close to tree_height check.

>  
> +	if (le16_to_cpu(di->id2.i_list.l_next_free_rec) >
> +	    le16_to_cpu(di->id2.i_list.l_count)) {

Use le16_to_cpu(el->l_next_free_rec) and le16_to_cpu(el->l_count).

Thanks,
Joseph

> +		ret = ocfs2_error(inode->i_sb, "Invalid dinode #%llu: next_free_rec is %u, count is %u\n",
> +				  (unsigned long long)di_bh->b_blocknr,
> +				  le16_to_cpu(di->id2.i_list.l_next_free_rec),
> +				  le16_to_cpu(di->id2.i_list.l_count));
> +
> +		return ret;
> +	}
> +
>  	if (tree_height > 0) {
>  		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, v_cluster,
>  				      &eb_bh);

