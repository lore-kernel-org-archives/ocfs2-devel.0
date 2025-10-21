Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B342F363B
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 11:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761045233; cv=none; b=dq+YNS/5NQtDuOuN4t7hw6vPy9/cxR1i44N8KtkNSWMgfnxFrue0aZYttzzxjV3kWYm6kqU944XkuptpFWwNLiiTP18I3l0CdiAoMAfv6Z6AlBbt5Tc5oM/bkB8fciWo7hcPgFNw/zs2Qp7ofJVvo/PW3fHrQzwa1tTCzxkuO2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761045233; c=relaxed/simple;
	bh=AqcH9i6X9tcg0dfOTuPxaMmwJdu/pyO2R5ul4o/Vkyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sV2tsyAIeo0nfV9GnUbU//Yd0+1X4cYhMkxB7ZN6POgYNeWqg9efh+CF3630g/ijOSGzhCD/Yk2ELZ1dsJLHk79CI9sruz6WJDT6fy+BeTIOtUKsuf3CHBdHqfcfGWNXWryCXLFQHpeC1pfg4gvpb7AO1OdXf/zpAOsvUvPk0Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TVaiVB0P; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TVaiVB0P"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-470ff9b5820so8764125e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 04:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761045229; x=1761650029; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ritGUtb+aMGkln2xy4Rq/+o0iaEHcenof+kz0S49P4=;
        b=TVaiVB0PhLbu3g/VetxnJeG3vtqRW9DfsONakHq1FnGBUHQWIojiysTI88zTycRmsj
         UnC6gNLBo1IlO4iNTPaIw2Od5YkGz7d2O7pNKmuHBF+ass9zDg67g2V0IPaqGcqYwe3t
         Lle+x8OuL7LKiXO82IkjflsQiEgNax5PaZKsCAreIHzhqjaangDNMhPCwK/ChYAELphg
         Kn/Jylrxv/OStZx3Mry5cKOnjbtQl7HKKqZ0GXCCHRCS/aNL0auo7k1w4ijNVVTPRdNB
         YRrkTGdsHy9rg4CDGm/qSwiPFpjwYPBPRjBTltAXG3JhEG1VlY2pAuAN73NpTkrzR4Jv
         5vOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761045229; x=1761650029;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ritGUtb+aMGkln2xy4Rq/+o0iaEHcenof+kz0S49P4=;
        b=a2stpo3kTL/yCxXoyuW34IEL6ADgrvo6mil0GwlhPLgZ6JDPLlXzLiIv4DQVysPhEO
         Qd0P4OgISh2HkLUj94MB4dbVUdDXdGvw1re7RpiHiej7OC6/3GbWWk6wl8Qc1YcnwnN1
         y3tVTdTvsnK9fdqjJSDikBAOT305kqS+yAzPOBoaW9GexNHMKx7pBtieLfl6XTL5GeDP
         sqiUI8UX31AFesqI7Uc9qBAe9CmZ7UJQs4491PEYVEPRTHsmf8I4nA3zPS/Sqdz7f9D7
         /gJZ5k1m2cYn0i0vxceQlSE4x/zpztvBn/9JGun6wP4lgJKDvQr/eXIwcQ/A01cqefbw
         1wtA==
X-Gm-Message-State: AOJu0YzpwjGASgKdV3bsK0Wb7xNUz63j+Sg/A3rKzJ1FCRveTqbDrrW0
	V7JUy55f/6NKftHBi3GzGlxf1NUh2+0sr6XC3VqXIRzcxrEF76E+FMxklhJsgbBkMpM=
X-Gm-Gg: ASbGncvTzRAB66KsQboIntCCVA19M9JgjgcJMBXoiLAI/feBX6tg5VLpwHiatXa4BtD
	wBGmpZHjf570CL8xnKZYbm68MGy/+6hPK/2IhGzRcy7Um3MYWmPqt1g4Q9g4Q9zmpOzEqG9Ooct
	2QazQKJpf4OQxZYQG8fBmzHvCdsYbsCm0VFqZALFSpzf7tnXLDH2JdcVZRAhGvJc0YVOY50+IXG
	o0i+zcmevrb/T5Y1cB32TPwPTTpg2Edvx9yDnqIVZ19nYAR0WBnsokwUoa992LXzrcHJQDUsCPL
	QYuY6tNSg+jcPcRz8/Ur7b18U6SSQyuOxiKD1SgOGk4UzdGNZv20nWSCIGT9KU92X/0aCr3gXgk
	lCgZ1QqCxXeHo71We+geTCD7iXRzwW7ozrTBYSq7PMv2TzS8sJTl0iWvp1sYZnJpnKVEFt8tPQv
	kTqzq/NCw=
X-Google-Smtp-Source: AGHT+IFUJAVFx/bXe5Y1SFNogSLFi2pP3Ig/q0UaZfrqHbZWejcOsW7P1D2aUfOrAoAzXaddFGIGXQ==
X-Received: by 2002:a5d:5f49:0:b0:3ee:1125:fb68 with SMTP id ffacd0b85a97d-42704d855ccmr6555907f8f.2.1761045228891;
        Tue, 21 Oct 2025 04:13:48 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76676a2esm10005670a12.15.2025.10.21.04.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 04:13:48 -0700 (PDT)
Message-ID: <eced0737-ea77-4b3e-b301-4c7403a7994d@suse.com>
Date: Tue, 21 Oct 2025 19:13:43 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: add extra consistency check to
 ocfs2_replay_truncate_records()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
References: <5d5f0edc-1251-4c15-8d3c-dc3c8023a871@suse.com>
 <20251021080344.86238-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251021080344.86238-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 16:03, Dmitry Antipov wrote:
> In 'ocfs2_replay_truncate_records()', check whether truncate log
> length matches the one comes from the superblock parameters defined
> when making a filesystem and current record index is within the valid
> range, thus preventing an out-of-bounds accesses while iterating over
> the log records below.
> 
> Reported-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4d55dad3a9e8e9f7d2b5
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>> ---
> v3: bail on tl->tl_used > tl->tl_count since array indexing always uses tl->tl_used - 1
> v2: adjust commit message (Heming Zhao)
> ---
>   fs/ocfs2/alloc.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 162711cc5b20..657a9becc870 100644
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
> +	if (le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count)) {
> +		status = -EINVAL;
> +		mlog_errno(status);
> +		goto bail;
> +	}
>   	i = le16_to_cpu(tl->tl_used) - 1;
>   	while (i >= 0) {
>   		handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);

