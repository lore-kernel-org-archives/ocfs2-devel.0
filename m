Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B481F1932
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768842740; cv=none; b=hr2AbVwh7BG7iHJOqtg8pIdyztlZsX4BoAcrGhHpLA6Qop04lrDBnPeCZBPiJRnLLwq/iSvyLxRMFFl8WdI1oIGhM5nJqChIJ44/jrdd4YR32MBqX+LuAreTZ/FcGw2b3eySXB4sKCuVRT2ODD2cXGUTbiMMXQHWroajzISG2Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768842740; c=relaxed/simple;
	bh=Es8fWJIXZFvBKNnhHl4h+J2YcPiwozZIBFfu63J/rAc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rMv12nkyiH+PQ/zq7YCHKU2rJC4NENW+PZwumqmkNyNv8k2PeS7z/yiZf56ddzDHINWhx1uocm7gndMxrYU7XFARTUpasGamZfvvceTOAvoHApgf6VKgJYiWdNZj37HILuGs3MJGcH7Z2lPPjt2heelpQfqv8cOkQQld5fx3AWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmHPDOnR; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmHPDOnR"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-45c86087949so1621154b6e.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 09:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768842737; x=1769447537; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VF5ppv2Sxgm2Nlm7d7GJMxqNR8PWC8FPp4y5+/xcFc0=;
        b=jmHPDOnR3kSai8XOHgq0EW/cIQYdGG6YiB3bBQDwQV0UvohXaxcEZ6z3rpdhGYUxmV
         HoFFhJcv5Kx6rnJfc7ad0Lt5lJINXaIZBR31NI/mbDCz1XFYboX6LOuA1w2B0jwZtQCP
         5+EvnQxGsWRoCrdW33SZfY8SadBF98rfWa0Kt4ZBOgVmKM9ZXtS2pYodNEGYZOpG3x5B
         Fhg0gDypV5jLHDVeYPb1/iHk3GGRajg2mTVHkpvgwpXahcjvpBeMcTw7Ixl5JM1QH3wm
         bJz4EakVWpLaokO3VgQnaiYzR584ifOa0O4zPSfz/RyU3KAELFjSRKNLhBgrM/sI+aUg
         zqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768842737; x=1769447537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VF5ppv2Sxgm2Nlm7d7GJMxqNR8PWC8FPp4y5+/xcFc0=;
        b=qykd1nS5sIqm1EsnEUjkJ7bbeTGt6ePzV2hqeCtbLI+UkrOOzllTFrg7vLX/JOt9ah
         +Ng+jZkrYtq8mvK6qONN1QtdnDp3bgLKvQbOL87TmRCpbkUIXsYECplxGyCT2bdAqch1
         uJNhh9kcbvi7pwXlqGiMpzMjSC2jLWK+vbOS0gWB6mEKjIJFDuKWR8vMLtTZeZb7oUIk
         dsyaCGU6u8DtXsxf3AUl0D+MmovWyyLJ9optGNpqxUSTjWOlv4kP7ge4fh1kz+L93Dwk
         ZTdxh2E58m/+MDfQ8z7uLJGhAMnOCiSnB+zJaxMVWfrGaaI5q8Nts4/RTSxCzDiY+84w
         YK2g==
X-Forwarded-Encrypted: i=1; AJvYcCU/2uNj6Ub2VOgdadlyphPjyW5zyBF/PVf6nSqrimo/OoeavtHO3HA6RivT5Q1OuP3z3N1xfoUCXl0dPQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwWY/u65ZVXqRnqgfeQkNF4DAkhKZadDSquaQcalmH6EWvfNmr4
	DJXB4RU3bmpJRCLHJSF88+X5zEeVCvNuhmpgtNfSXAGK+NF+8ymRuoNv
X-Gm-Gg: AY/fxX71R59k/dfhTPcUsKNZUKV8NgK4pc92rQrVtfFinu/zKmJdCsohx0Flh2mVSgB
	9h1kuJZbtYvROfBuzW9s2LBPQqyVLDiBHlUXKWAPD8IPL0oZoZFdUy462p4nElNkBIkEWPsv1+y
	svJi5yeTSV34gsaWlZaN17JWsR2lGs++TjEanAMTdg6oMnwKesFx6Xb/vw1xL5GfAftN8pAq/KG
	hJeyyuWdnT8akOpEux9yX6evXff2o04I1sGfBUdq9w2d46Q05ZGTBOkxD7iFCnROEmkC2aSvfkw
	yssc23uzO+ZGu9+36AeRwzT0D5iOZEwGoivlmAhRF7SYN8rQAyUHILKnwcRvaoxbwbj/THMWKC7
	w6XdvRtEPCfgukyBCKcMOdPS5W2Z0t9UX6DqgwhtrHymlPEO3hNUBLIxzmEvMqZqBOxk7UaxDeG
	QiGtIJ1Y684l2Ea6b3Nc++02Db4WLkLCLb
X-Received: by 2002:a05:6808:159b:b0:456:9f44:da9f with SMTP id 5614622812f47-45c9d4ee409mr5551384b6e.0.1768842737066;
        Mon, 19 Jan 2026 09:12:17 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f6dsm7061688a34.20.2026.01.19.09.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 09:12:16 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: heming.zhao@suse.com
Cc: jiashengjiangcool@gmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH v2] ocfs2: Fix NULL pointer dereference in ocfs2_get_refcount_rec()
Date: Mon, 19 Jan 2026 17:12:15 +0000
Message-Id: <20260119171215.1076-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <5bflve5fog7jreyjzn4po47t2wzd6vomsmlkd6km44joogcybl@6vd2h5orgwge>
References: <5bflve5fog7jreyjzn4po47t2wzd6vomsmlkd6km44joogcybl@6vd2h5orgwge>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 19 Jan 2026 22:43:26 +0800, Heming Zhao wrote:
> On Sun, Jan 18, 2026 at 07:05:23PM +0000, Jiasheng Jiang wrote:
>> In ocfs2_get_refcount_rec(), the 'rec' pointer is initialized to NULL.
>> If the extent list is empty (el->l_next_free_rec == 0), the loop skips
>> assignment, leaving 'rec' as NULL and 'found' as 0.
>> 
>> Currently, the code skips the 'if (found)' block but proceeds directly to
>> dereference 'rec' at line 767 (le64_to_cpu(rec->e_blkno)), causing a
>> NULL pointer dereference panic.
> 
> Do you have reproduction steps to support your analysis?
> 

Thanks for your review. We found this issue through static analysis and
code review. We do not have a specific reproduction script or a corrupted
filesystem image to trigger this at the moment.

> there are two types of 'rb': leaf or tree.
> the check 'if (!(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL))'
> handles leaf case and returns to the caller.
> the subsequent code handles the 'tree' type, therefore, in theory,
> el->l_next_free_rec should be ">= 1", and the execution should enter the
> for-loop to assign the 'rec'.
> 
> Thanks,
> Heming
> 

You are absolutely correct. Theoretically, if the OCFS2_REFCOUNT_TREE_FL
flag is set, the extent list should not be empty, and el->l_next_free_rec
should be >= 1.

However, if the filesystem metadata is corrupted (e.g., due to bit rot or
software bugs), it is possible that l_next_free_rec reads as 0 even for a
tree root. In the current implementation, such inconsistency leads to a
NULL pointer dereference and panics the system.

This patch is intended as a hardening measure. Instead of crashing the
kernel when encountering such invalid on-disk data, it is safer to report
a filesystem error via ocfs2_error and abort the operation gracefully.

This approach aligns with recent fixes in OCFS2. For example, Commit
44acc46d182f ("ocfs2: avoid NULL pointer dereference in
dx_dir_lookup_rec()") addressed an identical issue where an empty extent
list left the 'rec' pointer NULL.

I will update the commit message in the next version to explicitly state
that this is a hardening measure against on-disk corruption, ensuring the
rationale is accurate.

>> 
>> This patch adds an 'else' branch to the 'if (found)' check. If no valid
>> record is found, it reports a filesystem error and exits, preventing
>> the invalid memory access.
>> 
>> Fixes: e73a819db9c2 ("ocfs2: Add support for incrementing refcount in the tree.")
>> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
>> ---
>> Changelog:
>> 
>> v1 -> v2:
>> 
>> 1. Add a Fixes tag.
>> ---
>>  fs/ocfs2/refcounttree.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>> index c92e0ea85bca..464bdd6e0a8e 100644
>> --- a/fs/ocfs2/refcounttree.c
>> +++ b/fs/ocfs2/refcounttree.c
>> @@ -1122,6 +1122,11 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
>>  
>>  		if (cpos_end < low_cpos + len)
>>  			len = cpos_end - low_cpos;
>> +	} else {
>> +		ret = ocfs2_error(sb, "Refcount tree %llu has no extent record covering cpos %u\n",
>> +				  (unsigned long long)ocfs2_metadata_cache_owner(ci),
>> +				  low_cpos);
>> +		goto out;
>>  	}
>>  
>>  	ret = ocfs2_read_refcount_block(ci, le64_to_cpu(rec->e_blkno),
>> -- 
>> 2.25.1
>> 
>> 
