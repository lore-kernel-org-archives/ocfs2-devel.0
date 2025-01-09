Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA49A2D
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jan 2025 07:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736408817; cv=none; b=m0tWb6K7J966yn1TY30f/5gek34Mfqsl8TXjz9QebjwHvxr5skIHn4GYduKXRWfZFKEVelbsihuYQp9c9fVhKpD8crFMcyqez4+INSlqlR3pjRM8ozv0fF5dlZPR8Rb0nFmSV54kNwBgr6X055FhLt5Ix+QTPyvVbFHcsfaBNe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736408817; c=relaxed/simple;
	bh=Ot3qim3A2laNIULME6YDt9tEnYc9OB0HMXCcNYw3M08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UFZHsAs6CHIez9+ct99WSuTSgDQ0fzvPdvehtfM6+haVhUtI7KIH4t/JQwzGJiLMK1nZvRdyzKffOnaAHTkfYjY9epkzKLeEu2vKklAkjT64lY6mY5C+HipcLlwS0iUdS59yRQVwTQrIsUmeH6lSzXIKEWJRL6YSS1FZn9Y9bKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P61wWgtt; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P61wWgtt"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d0bf4ec53fso89663a12.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 08 Jan 2025 23:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736408813; x=1737013613; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z3/6/IjkHTDIKY/xECzBbnKDJIOrNGttPS37ykEhaIM=;
        b=P61wWgttPPkKMAMBYbrl8qXvvrUvMjFV7Au4uSsZOHaMDKKGa9c9AdUvm4TG3l2cry
         AvOcUjYMYRugvkU8i6EihFHVhtXFqFJWm7NCI3iu6UkZxImsmvwdfwunUJnUXrFVEG16
         Qb+Eml2wO8GQo4kzgZuitalkAdSFQZWWyKOFcZdg+qHms8tsNrhLbh8aQUt7zhjJEmus
         LZ89oKqkDIzi/zLSXIbBe649kbTkSAuTO0+qTPuXgdWcHVB1WOB3txiXiuWKRj7FZnBX
         wYo/ZQcQeZ5uWCS37hK1NaWDqG31PmfMfhNU70iuMiqd7hxFvZJn7OAYDz9ZtVspZVeN
         rXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736408813; x=1737013613;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z3/6/IjkHTDIKY/xECzBbnKDJIOrNGttPS37ykEhaIM=;
        b=j4loGzqzs0tF+vLBkC4LdIB4akUZ0m88hNSSj60KPghGjR66SeA6bmZq4CsVAWQdIX
         FQ6VSVLWLVrW34kFRjoYypql0ZKsgXa9Km8KQFuKHtwtqHIpZLURg9BXC62r3G/Ak6Nd
         iWpU4ssH0rEU/jg0rSE9E1pxqBjuOlmRjA7anNMWIQyr362E1ZwZ3e6RbbW4TXkNAryl
         Ble/4pbiKFkFyODQ8GPZGew7a4qyA81UKOPixx6X1lh9K5azXsPfBqKNay7RvJ1413N0
         sPslbOgSuZmCIS153nq3+XlHxMgSI8QN/3K+xKJ29UHQPNtV/oGysujwrkQ+Ddqu1UyI
         ng0w==
X-Forwarded-Encrypted: i=1; AJvYcCWiCrtr9RUMGAmXIoHw+CTXnKBT0Nt6GOWCC6n28oHNDbJrfk+tB+Ouusnd+M3hoSsqcrWsqetUwzxr+Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2kmkXV9cjXY+swQUXY+caRvfHWe/dGKG/bYWUwB0oMXW1GyMj
	yAjNXB3lMjoVAwUpalSlMXr+hGkaNQxkFwE65kTSiLOIxg/XjayRIATVlsyYH3M=
X-Gm-Gg: ASbGncsikyOYKDkCIyE9bP6zocswv6tn7PJ8JfqacMnnfbYdZiIt1Al7ND9YKAl+D7G
	fGUwAoWqI6q00glZtbVtxTv7B+j1TiA44iBPdkrOjGO9dWpfAA6Jkw+goizprKJce5vPxW5evK2
	5n57IFWe2NkvMjbVtJs9QwYNZikX3db1oDs7pyBvY4k+UYa2x0RE4cwPujLosPxLYUnfNoA5LXO
	3IPKGroZSoyHPXWHcsODOPBx7vzUF3QmVxk0T+lrt4MAaSgOMzWGCIrPlzC
X-Google-Smtp-Source: AGHT+IFeUOGyYWEC1UGZd5b62iM+JDHdu2YUTJuyESXGXaRzSC1OkT/XrywbbTO+cKIY1Zu3fKBB8Q==
X-Received: by 2002:a05:6402:2692:b0:5d0:bf79:e92e with SMTP id 4fb4d7f45d1cf-5d972e4cdf1mr1746977a12.6.1736408813261;
        Wed, 08 Jan 2025 23:46:53 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8dbc01sm37565742b3a.125.2025.01.08.23.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 23:46:52 -0800 (PST)
Message-ID: <76f6c583-50ce-40f9-a1c8-f1c1155d94a2@suse.com>
Date: Thu, 9 Jan 2025 15:46:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: check dir i_size in ocfs2_find_entry
To: Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com, Jiacheng Xu <stitch@zju.edu.cn>,
 syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
References: <20250106140640.92260-1-glass.su@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20250106140640.92260-1-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 22:06, Su Yue wrote:
> syz reports an out of bounds read:
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in ocfs2_match fs/ocfs2/dir.c:334
> [inline]
> BUG: KASAN: slab-out-of-bounds in ocfs2_search_dirblock+0x283/0x6e0
> fs/ocfs2/dir.c:367
> Read of size 1 at addr ffff88804d8b9982 by task syz-executor.2/14802
> 
> ... ...
> 
> The two reports are all caused invalid negative i_size of dir inode.
> For ocfs2, dir_inode can't be negative or zero.
> 
> Here add a check in which is called by ocfs2_check_dir_for_entry().
> It fixes the second report as ocfs2_check_dir_for_entry() must
> be called before ocfs2_prepare_dir_for_insert().
> Also set a up limit for dir with OCFS2_INLINE_DATA_FL. The i_size
> can't be great than blocksize.
> 
> Reported-by: Jiacheng Xu <stitch@zju.edu.cn>
> Link: https://lore.kernel.org/ocfs2-devel/17a04f01.1ae74.19436d003fc.Coremail.stitch@zju.edu.cn/T/#u
> Reported-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/0000000000005894f3062018caf1@google.com/T/
> Fixes: 9b7895efac90 ("ocfs2: Add a name indexed b-tree to directory inodes")
> Signed-off-by: Su Yue <glass.su@suse.com>

This patch code looks good to me.

Only one place is above 'Fixes:'. 9b7895efac90 refers to the initial
ocfs2 code. From the patch code, we can see that the code lacks sanity
checks and this bug is triggered by a specifically crafted fs image.
So, it's not a very important issue. In my view, it's better to avoid
tagging 'Fixes:' and backport to the legacy kernel, which creates
extra work for the downstream maintainers.

Thanks,
- Heming

> ---
>   fs/ocfs2/dir.c | 25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)


