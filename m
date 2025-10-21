Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA5A13D638
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 01:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761010355; cv=none; b=gF2YkDP02DWcwe0fOD7PVM3lPO3voKxh6bWqiD1fMVw0EXpum98KO4C2g/Mdt2+QAzdJtn4mfxORzhs0gh30+aNTXbc2rGwug7nMdXRRhfMcWaJrcI1RgzDC0nL1deRuxRDzj+kZLET64X6fAcfNMueN5ZCPs3qGe5clkrio3Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761010355; c=relaxed/simple;
	bh=2C3nCWV1GE7Wy0aTehEvty0v9VYhZ1wHWVTqjtSZgDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NqjSvMnIdjOiTi3R6l4KiJuFXBd55lJpIr+J8uZsphLr6RInjg6nDcxA70TqDpaeev+88vT6jsvb5uLVv1ep/Ihzu1bmPoyEzK3MmuCwkl2G2UUxNbvbwYUrPyD/CJZCneV9us4pIrNwHKkdwX3aOXMdtD6wG4ZpuLyKeoWOilo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BVDTVQ1O; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BVDTVQ1O"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-427054641f0so724121f8f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 20 Oct 2025 18:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761010351; x=1761615151; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ioACizwHUzqB5i8R/yCC9iRuhi7nrx0DDYX3EDZ7ndQ=;
        b=BVDTVQ1OBgNSxZDH/myH4vsFst+i52yLQmysgmexb9Q1zqUidYmm5eApoCED2+/Buu
         BgwfPMnTIJjimL7gISi+BAZ+tmiSFG/exJqQtj1uwoAkfJLl65lBZ2menMzQr+wtCxaK
         2yQIgYmItttBYAjbLpG8+bwPjzk1yMLuGLvM76rP3yP5syj9VgDQW54gZLdWvgJxUo3p
         6Ni4ZW0WDP4B8faZs++cE1nta/ajJOX2R2EGLvFQtPidTXDWfvwRjitfYX/2ZnZV2NYE
         sDS9NQSQsw/8OCuEtfwwGsRkAKvun2c9su5gb0tBokZC+Os90I/kmbD7Kb1IbGbKvjSa
         3kvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761010351; x=1761615151;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ioACizwHUzqB5i8R/yCC9iRuhi7nrx0DDYX3EDZ7ndQ=;
        b=KAdCthh1UrtTe86NKIkd1nNQhVVyepO6jE0MnHVR88BzjMlHB+psLnqnmePw54I4He
         waOHUPWZ2AuVdz2TcvMPJ5H22KSRy/0KfVVm+djQo9GfocpYoWet9kdXQUzi2VbibRPx
         3u9J/RL5AqnL4YOvuAryQUhG1o2lvTKIRXj/a1Hn4GYA2YRALW0QdlAaTLFdXIbKTmVJ
         A0seGbRGhJpON7Sq5nN1dvMLCgOf/b6L3OoTWlAToMgYDw6Tv4dtIDTWJPanoEgP9Zra
         SDq2zr17trjqnyECQqTctlA1TzL+A+m85vxfUb+v1p+bopuL8/evIRPnUoEukkDuJsp4
         pmsg==
X-Gm-Message-State: AOJu0Yz5DDuO9Ks42hM+96NtaE+sJN6xrIBbJILcLKTkt49uGZautOsE
	4xK/l8yEg2JICzWuT7cmv8PiySTbgi5uTtLRm6wphfMwfNoPWwXbw2SeSZWL4nJ1kUs=
X-Gm-Gg: ASbGncsVaA4yk833D5YlXweqdYpjfUXfbi57hf+g63RfGa3GKL8BxKGc9J65G0RADEm
	ZZY73DxQ+0UQWSLvtUqtOu+VPoNrcoJm/tX07I/4TMCd4WIrLMEmL2PGX64DgLFTp2pUuYyJ26H
	VS/Wgj//kgVKkE77EX6H+4k+SuFPoAVNTr/b6ONRmPfCxQ74l8S9TY3lQ06Z6bCwWBQ2oFiWfSl
	5cJaVloQTu9AMZHv3gxmOiRKeN01PnOebUWTe9lTmBsnmyPBkA6EcVPOL+a2PuQz5wZfmbaZ1Qr
	xmfIRa7S0DCSt4ErUOKnAmdtvT99XMv+S3+ypkpaNqdGpb4CMCVd1WXSaU1RnWcMoRnsUZeaPa1
	vofDoV5OsjiJ8bDF7twqnoYBn169B7Mzos1a8Im/R9Ki+aHffVDiAYWJiFFELP3OSrQXa/LpvaU
	bgSIgUk3zNVAaYU3G0XA==
X-Google-Smtp-Source: AGHT+IHEN/angEwKGw1uC6mMxhQqgh3qmqdACEGRj3ANWf79MuecUQL3DYO7kEV5R4ib/MLcZxR7Sg==
X-Received: by 2002:a05:6000:18a3:b0:3fb:6f9d:2711 with SMTP id ffacd0b85a97d-4284e56a021mr592383f8f.8.1761010350961;
        Mon, 20 Oct 2025 18:32:30 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a23011ec97sm9621884b3a.67.2025.10.20.18.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 18:32:30 -0700 (PDT)
Message-ID: <5d5f0edc-1251-4c15-8d3c-dc3c8023a871@suse.com>
Date: Tue, 21 Oct 2025 09:32:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add extra consistency check to
 ocfs2_replay_truncate_records()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
References: <18c4bf1b-5860-46ff-9e55-71e715fafdf2@suse.com>
 <20251020150227.210267-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251020150227.210267-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/25 23:02, Dmitry Antipov wrote:
> In 'ocfs2_replay_truncate_records()', check whether truncate log
> length matches the one comes from the superblock parameters defined
> when making a filesystem and current record index is within the valid
> range, thus preventing an out-of-bounds accesses while iterating over
> the log records below.
> 
> Reported-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4d55dad3a9e8e9f7d2b5
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
> v2: adjust commit message (Heming Zhao)
> ---
>   fs/ocfs2/alloc.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 162711cc5b20..143ce8ba6071 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -5941,6 +5941,16 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>   
>   	di = (struct ocfs2_dinode *) tl_bh->b_data;
>   	tl = &di->id2.i_dealloc;
> +	if (le16_to_cpu(tl->tl_count) != ocfs2_truncate_recs_per_inode(osb->sb)) {
> +		status = -EINVAL;
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +	if (le16_to_cpu(tl->tl_used) >= le16_to_cpu(tl->tl_count)) {
> +		status = -EINVAL;
> +		mlog_errno(status);
> +		goto bail;
> +	}
>   	i = le16_to_cpu(tl->tl_used) - 1;
>   	while (i >= 0) {
>   		handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);

