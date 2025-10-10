Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E921C8605
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 05:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760075638; cv=none; b=DVkMzsYrO8t80sYKF5CM3UgYMoRCoGv7yCzXeT983gizlklJDmD9r/SuzR4AsoHEPghcWaHckD3ubYrjfZSVewV1PTjZOSYzkVg0kzQkVMw+JayDplVjpSOR/CBRfTk47t9fbLDAnlLT/33SGurTKkHcyabiaPZe3eVUdENpBBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760075638; c=relaxed/simple;
	bh=2ohd1Y2myT0GhdDKrMwgVj/IRnx6ajnRgn9oWDBvyBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FI2FkG1rnGgasnrvLue7ubQ5oSRnk3m1iPc057mLs7KMz9XY6UR1jT99rtpeQSOEkQw7BYCaIcf24cVNUazh6sJpx8yZpiiLttTr7SOxqCjVaru/qDNMYLLrP/y/wrlAkWfxVhyFGW+WnyFlC5UzPRjBKPCfmOZZhMnzUZHucXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OcOSUjQZ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OcOSUjQZ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e5bcf38e0so1724415e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Oct 2025 22:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760075634; x=1760680434; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pqXZRx4KCUhm5GNMIvH1DkFMNZNtM0p8W/UgRq77x2Y=;
        b=OcOSUjQZfLazWRiGZMKDpuc3K6DyCGxXgAVwZhtZFTLG9Pubat5atjtccEiYtjijdJ
         Fi+nw3CqYYXjPhON9HXxUiTbRjGs0yl6/yKI5eDAgHc9voSMIJ6LfRkjCn8seih6XJlc
         ATpy7pOSeCbiNXamgEXAGc1ubH5FeDaDXDViD9JQEeGP8Skdrjh3RZsuEMOlWsKP9eDV
         Ft6Yl/VaPKSMxLS4SAgeMgen0Fz/yGabDmJuoHdjkzkcHu5TxhEto8Vh+P5hwIsy8Oen
         B/t8MHX/Xr7e4qOOBJCRcAfRlP2A/W2QeATYg3wAmkvcTjYzO+/HjkDPeF1SmL3pieej
         96UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760075634; x=1760680434;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pqXZRx4KCUhm5GNMIvH1DkFMNZNtM0p8W/UgRq77x2Y=;
        b=rUioYNuH75GRgQF+E1O3C8RvEQT1PxCMdnnDNgVFgh0d5sg5uFaqsrH7+KnBz+BiLt
         Kw7+jVV2g20Hyp+FaV7iXMOlsdYzvi1ibLnZut+BLAhUeeYWuY/ArbXlQmHszY85CbXq
         8cSpqoVqwhg033g+kN/UdtRbAl5LET6Ktr3zoZqOXxJsKcwsi0+4PWq9NXuwGdHV4xyi
         OpJwXX8bH1L6ytb3mselRtG3gtmwkuYJXhfQ6+KRK9vzD4O4yzCQ9hpEzvW91e/KfbOJ
         NDaP0YgaC/6VwT6lSCRuXXDKHtraORESp4N0GTCMx+UBH8HuPLkpkr5V6MhFBXuTvn3L
         0SeA==
X-Gm-Message-State: AOJu0YzvEwR8WgNJ+fosJUygSw9Yky3sf17A0WYo0u4rMJSSz6IDIhTZ
	3a0mU0ZfIg03CloXN3XiCCcXm9BGkmSHB9BhpX6SvFCy/r+38gZTtKDvNQfuncEqv1Y=
X-Gm-Gg: ASbGnctkPcm4MdFmM3fyxsCZg5rEY0vLAaa19WpmNbwO+Qc4uKCTTjdzZQa0NQlbOHH
	RFbAf7qvs49kwdC6uL6ii+qMC1JIiU9oC+aCfsVezbtMZEUQLFZQ3KUQuDjTCpPnlWjHvzUfF7q
	+Uf41mfh3Sq4vl0vRHGZNH8JELlGokr1OomUA3WBbGA/Lyiy5dZZJbfin8c34qsmPVI1yMQoUkk
	43anK7Eq6w8bGim0DE0AUbudf3jSb8bmdarbI2T7Y9j4bRA8f2ofuCIT6D/T/gP6RzzJ9wjCnwL
	M9NU3ECux3AtrUf9m6ZERyP2Xc80Gs8oARTv/LnEp+eYKlAol6ZiQPIZ1uaMaty46XcA62Y9M6F
	6x4vTmPoEafIYdU2cZJiECHPnVje6zu7mQu4qhw5xzJLixBKg
X-Google-Smtp-Source: AGHT+IGcIZcDvPubXjifTdTZMuP16dDdn0+z75U6HqC3LW4YKHWq/2jmMh4Klu/jH9TxinoO6pzHsg==
X-Received: by 2002:a05:6000:2401:b0:3f3:1be5:ecbf with SMTP id ffacd0b85a97d-4266e8e1e70mr3626623f8f.7.1760075633989;
        Thu, 09 Oct 2025 22:53:53 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b63a03dsm1652285b3a.19.2025.10.09.22.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 22:53:53 -0700 (PDT)
Message-ID: <93f3ef3c-0363-430b-acf8-db70bd4a4b16@suse.com>
Date: Fri, 10 Oct 2025 13:53:49 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add extra consistency check to
 ocfs2_dx_dir_lookup_rec()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
References: <8af5355e-5a05-46c5-bee6-c7ed3de71c0b@suse.com>
 <20251007094626.196143-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251007094626.196143-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Joseph,

Do you have time to check my following comment?

On 10/7/25 17:46, Dmitry Antipov wrote:
> In 'ocfs2_dx_dir_lookup_rec()', check whether an extent list length
> of the directory indexing block matches the one configured via the
> superblock parameters established at mount, thus preventing an
> out-of-bounds accesses while iterating over the extent records below.
> 
> Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
> v2: move sanity check to ocfs2_dx_dir_lookup_rec() (Heming Zhao)
>      and rely on the convenient ocfs2_error() to handle error
> ---
>   fs/ocfs2/dir.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8c9c4825f984..ece0462a5d26 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -778,6 +778,14 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>   	struct ocfs2_extent_block *eb;
>   	struct ocfs2_extent_rec *rec = NULL;
>   
> +	if (le16_to_cpu(el->l_count) !=
> +	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {

el->l_count represents the length of the array l_recs[], the max value is
ocfs2_extent_recs_per_dx_root(sb). Therefore, we should use "<=" instead of "!=".

- Heming

> +		ret = ocfs2_error(inode->i_sb,
> +				  "Inode %lu has invalid extent list length %u\n",
> +				  inode->i_ino, le16_to_cpu(el->l_count));
> +		goto out;
> +	}
> +
>   	if (el->l_tree_depth) {
>   		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
>   				      &eb_bh);

