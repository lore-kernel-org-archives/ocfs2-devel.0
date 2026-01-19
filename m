Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941A0330337
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768845721; cv=none; b=t0XAs42gJVRMD+0fsrTb6pYERoX0lpbCMJ64gmCxaWhxag8ijbLF8np+xPSXhNLbwRDCRRN8Zqw+VU4e/1FqaEKVBVeiUpRUnURQgCPOma4o9fL9PdNa7lqFM5l4tVFVGOHWTdPoxM6esnbGtFS22QVqqKBklYSfVX/av85Wh28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768845721; c=relaxed/simple;
	bh=Mbd6B76acQYFcT25UuF4U150G/AIM3mo8YkVwgKDm0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UURmcK4RKftpnUCQJCRSVQm99TN3bUuYF+L3S45ndET66ouHpi5ecVFSl7OrQg1CPg20T+GGrodFpni0OLj1vizp8kWZMoLWsIxR0A37s2FwZcNXer4V2QQqKBU13wXsLV697oXATKPaGI5pw2KjSFgZyxHumsHtXzxfpQSgc90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X0/ZGV+j; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X0/ZGV+j"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-45c7400259bso1700904b6e.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 10:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768845709; x=1769450509; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m06w4WXj+V7Ts8qLgM3nR20C9EMLJygWYWZnc/rqyZU=;
        b=X0/ZGV+jvecxNQGLJHpDnv9uvJpNCfBKXmqa8TvLNoxkoqg8eNUNqU4Mgo//YnzdVG
         lSNP8SoWf5ROsY3BKH2/lzvUGlE3+ceKyLBdLK9AF5E0G1oukBT+JwPw9es1ZHX0FpTw
         NYAd/uToeyTg5zzPwZD1nsBAk5P1tTuxPIVn96NdaB4qM+1FSw85BK1gKREyY5uknTi1
         K7Dc6eQe86dFKNnUbMBYLEw9PCU6WG8zSRUBnjoZVCCFm1phuqiynnigJb6ELzKhyJuJ
         MaX96Y3f/nLHvUCquCe4dabpoNxIfx2RFiNnZTYmAKN/YDKOogLKTtCQiUQj43XvJnT4
         hLOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768845709; x=1769450509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m06w4WXj+V7Ts8qLgM3nR20C9EMLJygWYWZnc/rqyZU=;
        b=vLLcQk4WWSDv6qP653uqZ3w6ZjvTOH0swi1tQ/1zZje/KMy433X+HiFcPcGXm1RRvH
         wbnlgs3tiX6eo9ClFfdRsB3hnb/CrHzVvna/Gx3+Sp3eFdh1ivLCTvTGO8zz0YziOtV0
         6iBQ8kA36mWUXV5UlAWM3D7vEkIvm2YAFGQ01s0I0Esjp9vIS/Lstnaz65xXWKh4CZLe
         Tnx3TgbUm1yPqNavm9NZDUSneeGYE3uQKwcp/aUB5Yxn0NiIi4YQCMWdfs0zXgD4ergd
         BfMgcvyLAkfVOjpY9HAm/lkfd5Hq8ri2T6IyR2/2X5Q4A8OoTZzt5WmOcKHwocMetvRn
         GRZA==
X-Forwarded-Encrypted: i=1; AJvYcCXjuxIPKBShePfc2w/iA7FrMzFyEYjBG9g6l5v4+hnSQcbQCWKDzn27S4Drsy5YbddRGi7oSJp9NaXOOg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1HhBPO/kePjJfy4gVXtHaHCEQwBjHdZoyhmQ04mnrHRwNx+N2
	W8P85hOAd5WBE3RZgJI4BeE7B/QsZLyyAT7qXDLffK937uzBID9qi79S
X-Gm-Gg: AY/fxX7eRcyuesSjx2Fikm9isnlKDt9zeeoU8pGvaPcoX8ic7KAovjRqbXV9/fzrcek
	xYCAb6qFFIRyYkWO/Q3SwMUtj4+JU7NwIflb8+XHFTYzn3Hbeu4V+ulPC5dJNMxQ55M2z8PPueu
	l1jJVoIawBkK+MvGUE6+ygcIVSX96V1ii/yvmRDu/5i7u6LvqSwIeOwoaJnp7ga3T4AK8uWo2m2
	2piu59O7KyZCJKz1ELlRUPTJVGHoWzTgU/cMgnBGO9K2tQFqsBM6VeHvb4vddaIFVMb/UdbwaMi
	+QrZzfSJ2wBvEheatTpNaewOUEIEJpDWCczOuHk8fIofwycrMKE4P/saXRjXdoUs8vBywZ1tHOO
	5awoFrvmK7LP4Wov9p24Se0BNWjoGMPMNAFw42/Kq3mcYFtFxA6iFgxq4O3K3pDD1INlnZZg6K4
	T7jwQM9de9LZXOjTSjhuXDy7PI6BCdUFNa
X-Received: by 2002:a05:6808:1a1a:b0:450:b7a0:41ca with SMTP id 5614622812f47-45c9d73516bmr5400321b6e.22.1768845709285;
        Mon, 19 Jan 2026 10:01:49 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9e03e82esm5780228b6e.15.2026.01.19.10.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 10:01:48 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: heming.zhao@suse.com
Cc: jiashengjiangcool@gmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: fix slab-out-of-bounds in ocfs2_rotate_requires_path_adjustment
Date: Mon, 19 Jan 2026 18:01:47 +0000
Message-Id: <20260119180147.1708-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <nvaagj2qdkgifr7lwyzybwyvfvuwmxunpjinklepvtyoi5v6tw@vsihwyqiu2i4>
References: <nvaagj2qdkgifr7lwyzybwyvfvuwmxunpjinklepvtyoi5v6tw@vsihwyqiu2i4>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 19 Jan 2026 22:50:00 +0800, Heming Zhao wrote:
> On Fri, Jan 16, 2026 at 05:21:13PM +0000, Jiasheng Jiang wrote:
>> In ocfs2_rotate_requires_path_adjustment(), the variable 'next_free' is
>> assigned the value of 'left_el->l_next_free_rec'. This value is then used
>> to index the 'l_recs' array as 'next_free - 1'.
>> 
>> If the filesystem is corrupted or in an unexpected state such that
>> 'l_next_free_rec' is 0, this leads to an array index of -1, triggering
>> a slab-out-of-bounds access.
>> 
>> Other functions in alloc.c, such as ocfs2_rotate_leaf() and
>> ocfs2_update_edge_lengths(), effectively guard against this condition.
>> This patch adds a similar check to return 0 immediately if 'next_free'
>> is 0, preventing the out-of-bounds access.
> 
> Do you have reproduction steps to support your analysis?
> 
> - Heming

Regarding the reproduction steps, we detected this issue through static
analysis. We do not have a specific script to reproduce this as it
requires a corrupted filesystem image.

However, if the filesystem metadata is corrupted (e.g., due to bit rot or
software bugs), it is possible that l_next_free_rec reads as 0. In the
current implementation, this leads to accessing l_recs with index -1,
causing a slab-out-of-bounds access.

This patch is intended as a hardening measure. Instead of crashing the
kernel when encountering such invalid on-disk data, it is safer to abort
the operation gracefully.

This change also improves consistency within fs/ocfs2/alloc.c. Other
functions such as ocfs2_rotate_leaf() and ocfs2_update_edge_lengths()
already guard against this specific condition (next_free == 0) to avoid
invalid access.

This also aligns with recent fixes like Commit 44acc46d182f ("ocfs2:
avoid NULL pointer dereference in dx_dir_lookup_rec()"), which addressed
issues caused by empty extent lists.

I will update the commit message in the next version to explicitly state
that this is a hardening measure against on-disk corruption.

- Jiasheng

>> 
>> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
>> ---
>>  fs/ocfs2/alloc.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 58bf58b68955..b15c6f751d99 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -2327,6 +2327,10 @@ static int ocfs2_rotate_requires_path_adjustment(struct ocfs2_path *left_path,
>>  
>>  	left_el = path_leaf_el(left_path);
>>  	next_free = le16_to_cpu(left_el->l_next_free_rec);
>> +
>> +	if (unlikely(next_free == 0))
>> +		return 0;
>> +
>>  	rec = &left_el->l_recs[next_free - 1];
>>  
>>  	if (insert_cpos > le32_to_cpu(rec->e_cpos))
>> -- 
>> 2.25.1
>> 
