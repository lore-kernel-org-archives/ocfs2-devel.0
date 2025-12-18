Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A141D6195
	for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 07:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766044099; cv=none; b=tU6lR0x6Yx4HLwCNPiD5SQRm0qtWxyl8Xdy4SzeZZkyQCJ1MEKpcThLejMKh+iSxlDxSTMJ9YDKBLawPZ/3WXlZ4i3nak8SvFnVi+c2V0tDuWxDNaMxFqX4v3KELL4IAj6HlHYCLv1KSE6ymP4QDcYFfKY5tK+kslcWnloZ5W64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766044099; c=relaxed/simple;
	bh=AuSqBD08QOTAPizj3B0oBskrmKjOOOWRsr8bjnnpDcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rHZSw2KisyUc4WqDU6RW1gEqgumySz3FNDPXaCAbkYtzNucoq/DNDNxihx9WWpXjCH23vxISZuCTTQtYT+VgcxJrMvNWn8inzAoNhQwTSesIUixqFD5J/w/V3LRaRcU3qbJIF++mQBT+spstecOa+TYPCZ6W7ZHYAAK83YSIWRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pqjCHDTy; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pqjCHDTy"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47798ded6fcso1957905e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 17 Dec 2025 23:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1766044096; x=1766648896; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A6da9mL6w7JjucEkm0iVpGrSco7Y4da/s9zyBoyed20=;
        b=pqjCHDTyvlBrw2FpcRj9C3crgHHB/qqDocl9y1KTSVJKV2GPEieY3O5Eb6kC1Iujyc
         WghqXiGnjp9nqt+qHdzzpSfeJSq2taM6oAh+RsM8lQl4K35OgJJsr0qU5U0K1Y4tw7f/
         FNT4meNLNx9pJZqtiPoglDbG/39Dqwbp0i07P9BPYb1LtIdMG5ioL0LEkU7B9hV9PwKA
         bO3yc9SezpzLfYAaiV07eygx2iKSoMZ+ky2ZqDV7u+WG7K+t18YlNQq1m/lCgSvWrSVo
         Adn4uYfJ8+Z5l7WRDbFNsov9Sgd2XHhKXt4yzNJbCwjEQqEZhyjeflJAW5O3KoYuts6j
         tu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766044096; x=1766648896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A6da9mL6w7JjucEkm0iVpGrSco7Y4da/s9zyBoyed20=;
        b=GCryNU2NR95dyTNhllNoGVliRXvWTX93LmbaNUpba92UxHzIDGSn2c3SgEMYd1Hu5u
         Sz5wfQtLi0cqXClHQAtsXhAZZuNa2E/YmmkLhtD7j4guSFWrt9AH+qrMAWaZmVDvIIpZ
         cPI9Ue744GQyV3n8M4Pt0YXAgVunJlqCqTnpkltNttpjPDnTouQ9S5e2QowKEusnuQ8s
         yBLrmodj0KqL40eG2Zz+HMy80GsXOfXuMLhfsyMjph6uRkKCFogKfQzj9/c1qdM1ksMu
         NSW77AJkbzsFe4euUBS7x/k0F04mBgODzJ0WVP02ELJ1+yzeXaS9ZIhzwe3WMCHPHdpL
         X1nw==
X-Forwarded-Encrypted: i=1; AJvYcCXZ6Mo2sZGckoGg59U/HvnzdnZUJa8XtyTS767r9NIjr0d2i2P2wUpe3W2i4vruJld6VCRMxeaV8Wczog==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3hPYhbnOBzjgrUGqqaDczzPY7g6ZjZVBk66Cx5RGTs3TpXdBQ
	GDnAQVz9BGX3wJpPMtPDP4h1u4kKvazggxcZ9utxyiIdDvGWsSgomZc7faoIrveSQXo=
X-Gm-Gg: AY/fxX7Z6KA+faHEQhJYbHlVwqU0G9mQxPO/7UgY2xkL4Y/flAsh6UN8rMrxR+ujPda
	77t4y48MUjehs1/KMeucNTEIKXQ7+GGVZGP4QcADmIjoUa6zKF5wjWZEXw2cv876sN3TlCn3ip7
	7p73EmjdSe8YPvbXyK3iglPFHLfuD3L523hsniO83ERF1K7ZBRe8v2j5jWrAm66SNRYF+TI8aoC
	nCjpR60s57dYPG6Etf9/MAZ9h+qGPB2hDhMlyANEtnsRVfeDROfhDd7lf0bsjw6I95PaELex6W2
	FbSzHPfbzWj32ImerW867aTypc9dfLp0xv9hwsi1BZnTpKngnSJWUo8C+uHN9vFYbK1IGmxq6eL
	l0DQHsasq3qYtNFGGta2DfXVVZGi2bepOZkHXbmFYjccBjwm30Tknpn9AbYSSu+Xuq0FCn45VrY
	GigrRkyU3px9ZqyU7AMa0EIX6IyDE=
X-Google-Smtp-Source: AGHT+IE/DDdSWUmrtB8Kc5Xm2gx32fWPtO7j0RZzZRAv1rZcOu/m28PCN16RJWCQuWzY3KJG+fYPVQ==
X-Received: by 2002:a05:600c:1c2a:b0:477:7ae0:cd6e with SMTP id 5b1f17b1804b1-47d16671bf3mr2227605e9.5.1766044095833;
        Wed, 17 Dec 2025 23:48:15 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3020f25sm28753175e9.6.2025.12.17.23.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 23:48:15 -0800 (PST)
Date: Thu, 18 Dec 2025 10:48:12 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ocfs2: fix uninitialized variable in
 ocfs2_test_suballoc_bit()
Message-ID: <dc37519fd2470909f8c65e26c5131b8b6dde2a5c.1766043917.git.dan.carpenter@linaro.org>
References: <cover.1766043917.git.dan.carpenter@linaro.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1766043917.git.dan.carpenter@linaro.org>

The ocfs2_read_hint_group_descriptor() function sets "*released = 1;"
but nothing ever sets it to zero so it's used without being
initialized.  Initialize it to zero.

Fixes: acb8a8335a64 ("ocfs2: detect released suballocator BG for fh_to_[dentry|parent]")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
These days everyone has CONFIG_INIT_STACK_ALL_ZERO enabled so we never
detect these bugs.  There are a couple distros which don't, I've heard.
But in testing, I always encourage people to use
CONFIG_INIT_STACK_ALL_PATTERN=y

 fs/ocfs2/suballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 72c7559c1a2b..79d1325b2111 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -3163,7 +3163,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	struct ocfs2_group_desc *group;
 	struct buffer_head *group_bh = NULL;
 	u64 bg_blkno;
-	int status, quiet = 0, released;
+	int status, quiet = 0, released = 0;
 
 	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
 				      (unsigned int)bit);
-- 
2.51.0

