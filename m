Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792482215;
	b=wwHkbYT4aT5Kb4WxNpnK5ZOOohujMimOEpIso6DIOHBGN18SYHIaT17gEsoDtdlj7J3c
	 dHewqAUJpvQ7YmKQHc5XGdsJUmITL9LB5C5WppE6pzN7dqoGDeHYVeMTvBZVPNF01gMu+
	 iBEK3nL7TSYkcs2QYh2kFXbfwNnCg+CLdyg49uz/5kM+Kj4ePZhhtYyFUK41vq9KPNnGO
	 YGaTt1+50Cmypv8AZhvchG4SHgNT6q7HlWTisPPVyCTcXJ7WNWRdmR7sWz6Nfk3yKVQE+
	 Uf/UTgNIAzw2kJqp3akEHEIp78CepsADy19uaTv1jLzRW7Sj+slYKf2HNHCKfnv/4Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482215;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=uu63qmqNvAJMzzdOPrVRwU8iPV7E/KmddMafoX0Pa1U=;
	b=mzrtK+bbV4T5N56Do0vGD5n+hGCp54kprOa8Hp3rDMTczxk1u5INrl+lUxmHEzYutKks
	 OtkEiKYVjSwg0ZUwrdhNmEWdlQOIvg1DtZsrIMTzScNsGUBs7YQFSU6MkFBYFFl3PUUXn
	 p1qqfvr04GOWlBgosKJHj4/WvhMGpKQaOlMN4PVZ8sUzhVFOnoRD5mjGosB/cLZQ0sIYI
	 8pVNqbxULQBn7rMF8Lqc9Ekg2uTCj9nH6y17r6KrIVaNyKZ3fNP6JZO2tTqk4neHVvBV9
	 iyLjZFqM8f+tNqd2Odvijtby9ORDfDDyDLFRWzWHDPGriPrQ6Bdxk8U3An16ds8YVYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=yh+E1G++;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E42606A31E
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 07:43:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86E42606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=yh+E1G++
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792482203; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uu63qmqNvAJMzzdOPrVRwU8iPV7E/KmddMafoX0Pa1U=;
	b=yh+E1G++3Kp4pGDqb7vZZVVh9/k+vXM2nne+n3UsHxJWmSX2MMoD8tNDVT91gA4MVSa3aYlZep5Na1bzXnGPmQe4yEzImyZYDgx0xOsVseY/Ypa2ywiMyQpuOFMW5jCsbCmXc4I2ZeSbiNLCxyTnWPsfVgnUdqVBhPpbyH95bec=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XDC9X5v_1792482201;
Received: from 30.221.145.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDC9X5v_1792482201 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Oct 2026 15:43:21 +0800
Message-ID: <f4f403bf-efc4-4629-bb7b-2c3b2cc35303@linux.alibaba.com>
Date: Tue, 20 Oct 2026 15:43:21 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate non-coherent freefrag bitmap inode
To: Jiale Yao <yaojiale02@163.com>
References: <20261018114118.927071-1-yaojiale02@163.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, Tristan Ye <tristan.ye@oracle.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261018114118.927071-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/18/26 7:41 PM, Jiale Yao wrote:
> The non-coherent freefrag ioctl path reads the global bitmap inode
> directly and trusts its chain list. A malformed cl_next_free_rec value
> can therefore index beyond cl_recs while scanning chains.
> 

Could you  provide the detailed bug report?

> Validate the inode block before consuming its bitmap and chain metadata.
> 
> Fixes: d24a10b9f8ed ("Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2info ioctl.")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  fs/ocfs2/ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index cbe59d231666..8383f900c847 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -575,6 +575,12 @@ static int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
>  			mlog_errno(status);
>  			goto bail;
>  		}
> +
> +		status = ocfs2_validate_inode_block(osb->sb, bh);
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto bail;
> +		}

ocfs2_validate_inode_block() only validates cl_next_free_rec when
on-disk dinode has OCFS2_CHAIN_FL set. So a crafted global bitmap block
without that flag still lets the freefrag chain walk index past cl_recs[]
and read out of bounds from the buffer_head.

Thanks,
Joseph

>  	}
>  
>  	gb_dinode = (struct ocfs2_dinode *)bh->b_data;

