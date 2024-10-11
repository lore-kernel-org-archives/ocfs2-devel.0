Received: from mail-108-mta53.mxroute.com (mail-108-mta53.mxroute.com [136.175.108.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF871754B
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Oct 2024 01:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611546; cv=none; b=SToh8TjSv3MQlGrnI8QRg+5IevY75aGeVIadGeKGpKhVK+psic4oXVNMIM+UbxsZXmQN2Qtfc75w6UP2ks4mmmR5f6DXhuUdWLLbLyxps6GjQL7zR75CyIdjZ+y3max8FjORHIf1z72gzJlOZBWtunP9m1rq2jQo67/Js8l0B3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611546; c=relaxed/simple;
	bh=eMEi30HCHoAAv+JpEoZK1ER7d1QkHukLsqPSuZDJKOk=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=pKuFhlUHjjE+RHTE3MCM9lzJ6seVQiyTZ8VW3ipc3FuzEPI2i3Lno+l5pKqzNwKEFnv/o+H9FXm4j7SV38toZBjyQXDR6RvvvBCgv+3zuEB6Fy02FotaatJJfx8y9eAC3qJPJCPMs3eYvhNb3UIOeAg2OA+83OlUXtDq7OxF22k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=Dgnq+EqG; arc=none smtp.client-ip=136.175.108.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="Dgnq+EqG"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta53.mxroute.com (ZoneMTA) with ESMTPSA id 19279421bf90003e01.005
 for <ocfs2-devel@lists.linux.dev>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Fri, 11 Oct 2024 01:47:08 +0000
X-Zone-Loop: d10abf5224315a6e7f965d41115baaa458f2b3ac390a
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pdzEL4cm+5xHpBoIcDQGXqMijQus5IPuZqSbT5JzXiA=; b=Dgnq+EqGvWgMGgCsRfZZK0D65V
	+14hm3ZdjxuNAjEsCQybe9vOSGdflkuUx57no2qIArOPftpNyGLR/jDMD3azilgZBRkark8P/W7x4
	92evQO7sjOd7CpPtS8cj5YECPKIQKvTyxccKrt0RZClJiE/B2154TKXCmIJp9XzLZrTrw5Pd2bA0B
	IeZJ67jH7YHFuKrYj9B2T94ChTIyGC5ueS+i69BAP1Qc1m8RardY/PoOAI2hvhTkBavIn3yVG7VEl
	2y2A9hhwb+7C/5F0gxEyDOYbr1KgwrvfuqYoRewEdJj53bPrt2cCLJefQC4AmxK0LnKPFMibgvxvL
	bmV/bKEw==;
References: <4195446e-2d2b-442c-a1ad-b1498d243a70@linux.alibaba.com>
 <tencent_91D2962236324AA47465761367183C8F3709@qq.com>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V2] ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
Date: Fri, 11 Oct 2024 09:07:09 +0800
In-reply-to: <tencent_91D2962236324AA47465761367183C8F3709@qq.com>
Message-ID: <ed4no1gp.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Thu 10 Oct 2024 at 22:31, Edward Adam Davis <eadavis@qq.com> 
wrote:

> Syzbot reported a kernel BUG in ocfs2_truncate_inline.
> There are two reasons for this: first, the parameter value 
> passed is greater
> than UINT_MAX, second, the start and end parameters of 
> ocfs2_truncate_inline
> are "unsigned int".
>
> So, we need to add a sanity check for byte_start and byte_len 
> right before
> ocfs2_truncate_inline() in ocfs2_remove_inode_range(), if they 
> are greater
> than UINT_MAX return -EFBIG.
>
> Reported-by: 
> syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
> Closes: 
> https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> V1 -> V2: move sanity check to ocfs2_remove_inode_range
>
>  fs/ocfs2/file.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index ad131a2fc58e..05d6a8acfcda 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1784,6 +1784,11 @@ int ocfs2_remove_inode_range(struct inode 
> *inode,
>  		return 0;
>
>  	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
> +		if (byte_start > UINT_MAX || byte_start + byte_len > 
> UINT_MAX) {
>
Why not use ocfs2_max_inline_data_with_xattr() here? Yes, UINT_MAX 
indeed
solves overflow problem Syzbot reported but you can find much 
lowerer
limit if once looked into inline data structures.
Also, ocfs2_truncate_inline() can be enhanced e.g. replace
BUG_ON(start > end) with error out.

--
Su


> +			ret = -EFBIG;
> +			mlog_errno(ret);
> +			goto out;
> +		}
>  		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
>  					    byte_start + byte_len, 0);
>  		if (ret) {
