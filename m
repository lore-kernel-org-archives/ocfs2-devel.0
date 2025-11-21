Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A479733E34D
	for <ocfs2-devel@lists.linux.dev>; Fri, 21 Nov 2025 09:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763718646; cv=none; b=caOVs5sThdzSEEFLe/VsfjDshXCXYSe67m6r+x0SxPjNzmwRyHtTspxRn3c+IBLfTDb2FXZ/uU8Zf3/nC0m+wC65CuSwOclk1Tzy4SLSMVJE9lpbL6nJBv9Oz69fMCS8n3C84u0yKf7cIUu6odW19GKOVCF0UnRo5yrZH0Y3avc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763718646; c=relaxed/simple;
	bh=+F4++NQwI9Qqxp9RRcw7h0dseR97ghrNoC10ctabKpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZ4HEB7ySJGN7PAxtwWSr1vmvzJu6aAi67ZAuySt7xQcplCbeppcYYeLtNfAex7j/q4przIFpJOz0jUG9Z7hESv40zbdTd18SU2xyDAkdNsW87BZPT4oDq9Uqz/q0ZL3mSkvI+mqoDc8WnM0DMHzs+PjW4UtrtWl036VabKLq7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=emQyt7x0; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="emQyt7x0"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b54f690b0so147212f8f.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 21 Nov 2025 01:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763718642; x=1764323442; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y5H2iD7RzzVbfF7fOcC3pockGgTav+2QpkUAWVUjpok=;
        b=emQyt7x0TZgzDgEEtBcCFF4ljBpuQNoXVAoEe+tb2kZMDimP0Ld/ItbR3diMBSMzak
         CVBrGuqIMbMgCMz2JwK71cwDl4c1wCrXDyybsj0hkgzkbiY0G3ZDdyA04uxBAbIRZT0e
         IDsYWiTORVPr+kNlEccq4Q2hZLy4weTOsicy/IGK0Qx39G5445SIOzaGrFK6cIJUvfws
         YNIuh17uY/6Oo0Dl5EZHaNCg9o+ojrIuem00/yTTN/S2WkdNiOfCknn0qAK2PnCp1wb5
         zW88Wn41YcKltvF8O2gJySetFH8lzpPFSacBGPpXcXKbIchblWiSWAmMe5/sfK+61c03
         +vKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763718642; x=1764323442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5H2iD7RzzVbfF7fOcC3pockGgTav+2QpkUAWVUjpok=;
        b=jH2SAkY0fy0DUC3KpPSaQir3yo1sFpWXZ/y623o871i42oMWLvD8J627oY7XVkW9fn
         Y9TmBINdt7D7ZGNUzbpb6OoISKdyygeZvNol97C3mrELO+PtL4ifolzo38Gbp81Ly37n
         p8A1xq/B2aEx9+f/GD1fl4FsQAgQa22w4vymmnmkatqWBmTdKGZgRC13rWWMaMwwc5JI
         6XXQqFoSWdNUkLCv70/t88gv3EHyCyM6+FPnPvlIETs1XRbNGQNiYZrEWBe2hKjv6X2Z
         DOK9RiGd52ajOPjcAvV0A73mAqF0/dyT6CD7rDeoH+vi+3YSaXBpG4rISEiGxTd3NGjg
         KP4g==
X-Gm-Message-State: AOJu0YyzC/g+W0idCpkpkE0xR+OzNVkKPmgMnbutyGmkiwh0t8k7ztOn
	ShVHr7LE/Kxr7icxVqSFt7W5P3reNAL0a9tu7uFf8wrkQwTqx1Uzl6KFbZxrPMMS46LbRq/lGTX
	CxWAORJ4=
X-Gm-Gg: ASbGncudBbK4xotG/v4S5YvLQ6HSSyHyCkHGTxOGkciInlRPuDZ/Dc0Fal/1JPpqNaA
	9SkF4OcA2LozX4PcL9JHYUCJ6Z4Ro8CBQwQF/+B4zMhwGGrLtrY8qr6wMRwFA4iP3FF9mzcRJGJ
	j//oQKTUrAQOCOAZsIYYQUEnxGfE4b/QoWDLPof5ZqmqNydWHHwFl5j4RhA8IUkgi0XWFF0Dr98
	TJ0F44glTnI4AZSswAES7c3wgacBWwC7lWJpjaG37BhB/L9uJflJf1RaUKFoI7KxkBRPhlm/oMX
	JuRwXp8adHGnVKG7NgM2zwqOchMgmfNEiY6Xvng+0ZjB8mysyWCcQ8+cKuASK4h+LJDIfD3kKVd
	9733j9ljPa4z+PCJ7iFaZYBYZZQVsTLL7odAbhACikq3MSTLoNw75KotwUYV17cpbvtBwmSu6sz
	8EGQSvAvqc2g==
X-Google-Smtp-Source: AGHT+IHBNyg05iCCBZGyX2S4q2z7F4FwKnLh11ejMXrbnSz/baJz6B0N5nqb9W+1igFZpbLOAdxc2w==
X-Received: by 2002:a05:600c:46c3:b0:477:aed0:f402 with SMTP id 5b1f17b1804b1-477c020242cmr9351005e9.8.1763718641884;
        Fri, 21 Nov 2025 01:50:41 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f155d053sm5466051b3a.62.2025.11.21.01.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 01:50:41 -0800 (PST)
Date: Fri, 21 Nov 2025 17:50:38 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	glass.su@suse.com
Subject: Re: [PATCH v4 0/2] ocfs2: give ocfs2 the ability to reclaim
 suballocator free bg
Message-ID: <camafp7tjdpccfoc6uq27lriybna4kjajqzscy6lx6774mq63u@w76yzblpemxw>
References: <20251121074030.12014-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121074030.12014-1-heming.zhao@suse.com>

On Fri, Nov 21, 2025 at 03:40:23PM +0800, Heming Zhao wrote:
> v4:
> 
> First of all, there is no code change in v4.

Aha, That's not accurate.
Most of the changes involve revising comments. For the code itself, there are
function renames and parameter usage adjustments, but no changes to the code
logic.

- Heming
> 
> For patch [1/2]:
> - Based on Joseph's v3 review comments:
>   1. Modify the caller to initialize the ocfs2_read_hint_group_descriptor()
>      input parameter '*released'.
>   2. Rename the _reclaim_to_main_bm() to _ocfs2_reclaim_suballoc_to_main()
>   3. Change the text "not empty rec" to "non empty rec"
> 
> - Revise the comments preceding the function _ocfs2_reclaim_suballoc_to_main().
> 
> - For the question: "How to distinguish the release case or a bug?"
>   I write a comment before ocfs2_read_hint_group_descriptor().
> 
> - Revise the commit log to make it clearer.
> 
> For patch [2/2]:
> - Revise the commit log to make it clearer.
> 
> Remove the v3 patch: "ocfs2: adjust spinlock_t ip_lock protection scope"
> - Reason: This patch belongs to a different topic/job and should be
>           handled separately.
> 
> v3:
> 
> For patch [1/3]:
> - Factor out the reclaim code into a new function '_reclaim_to_main_bm'.
> - The function ocfs2_read_hint_group_descriptor doesn't return -EIDRM
>   when the group descriptor is invalid. The new code logic returns 0,
>   and the input parameter '*released' is set to 1.
> 
> For patch [2/3]:
> - Modify the code to follow the new logic of ocfs2_read_hint_group_descriptor
>   as introduced in patch [1/3].
> 
> For patch [3/3]:
> - No new changes.
> 
> v3 patch has passed the xfstests:
> ./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 \
> -e generic/081 -e generic/266 -e generic/272 -e generic/281 \
> -e generic/331 -e generic/338 -e generic/347 -e generic/361 \
> -e generic/479 -e generic/480 -e generic/628 -e generic/629 \
> -e generic/648 -e generic/650
> 
> v2:
> 
> Create 2 new patches:
> - ocfs2: detect released suballocator bg for fh_to_[dentry|parent]
> - ocfs2: adjust spinlock_t ip_lock protection scope
> 
> In ocfs2_read_hint_group_descriptor()
> - bypass the validation of GD when the BH is already managed by jbd2.
> 
> In _ocfs2_free_suballoc_bits()
> - Move up the position of the vars 'idx' & 'rec'.
> - Move up the position of the ocfs2_journal_dirty.
> - Use le[16|32]_to_cpu() to access cl/fe/rec vars.
> - Add error handling for calling ocfs2_extend_trans().
> - adjust spin_lock ->ip_lock protection scope.
> - Follow Glass's review comments, add 'comment' & 'else-break' for the
>   'for-loop'.
> 
> v1:
> 
> Only create patch:
> - ocfs2: give ocfs2 the ability to reclaim suballoc free bg
> 
> Heming Zhao (2):
>   ocfs2: give ocfs2 the ability to reclaim suballoc free bg
>   ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
> 
>  fs/ocfs2/suballoc.c | 336 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 317 insertions(+), 19 deletions(-)
> 
> -- 
> 2.43.0
> 
