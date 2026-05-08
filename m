Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E33E378D64
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 May 2026 08:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230798; cv=none; b=bGxs8aewFiQ6HZZZ3Yr7ypYpUQT3FNYvmkOjRGN7C6DbfhSwBzS9jyso3+v1D92lsjGKMtIzAsBnWsRNBw95j/xxSfBYvxHhB7z5ooqIl+jYz8N9NcNk8BJxRjIYgM1QssXZmcRmm924fe98ADOBqDDtuYnlPhs3G68pJgyEJ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230798; c=relaxed/simple;
	bh=hbI4rz8zLPtORw9Xhzfq5UmS+KdGwinToZ5pmJNgdLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzmuhgaye+MGpbgdvVvso6F2qFp0PupdMeulrqtrDI6lwZX1PP740Vv52T/yxZrPtbUpqYO5VzBVLPJftTUAAse7ljg1Mb6nCcbKhEBcYlW18utKiVj9ehS31oviCmVBpci7dEtKA5xj3aRiTrDODgx+1ItsnRH+dX06YdfR3zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DkCMaKaE; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DkCMaKaE"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3665a90bcd3so218903a91.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 08 May 2026 01:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778230796; x=1778835596; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7VsT9AqjcyF6s6LYKeTQGzKfn0YABtziNfSDMtnBzw=;
        b=DkCMaKaEYvW2yE2NLZqycQa7RHK1a9fDv7dd2zAfRDLAnXSJv6FOZ4ZizKVHHd4xlG
         1SLUmKjGYLFXLg9NSDgwCiCiijlgvygPdh+/QeemlN3eoxFHZrVeDhiB9w52nOB0noXC
         NKGjQy0jo04ob38SLgHTEUPKpxgHOA00jtJWuz5+5Ti72H0vyXljbxhOXV4u01F7DbXT
         KHUEjsesjgGIRtcnN+EYX6bcBvoQFQiMaB5swA5wESFQgihngWSQuCrBJkLifEVkB2KC
         lto1kFf/wlVKJgo9273C6S+7e9gsZGxq3UFutwbRtq0hizZFC0aMyFhEOZJiZKBtlsBp
         XPng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778230796; x=1778835596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z7VsT9AqjcyF6s6LYKeTQGzKfn0YABtziNfSDMtnBzw=;
        b=SfhVmpNBOTeYQtCvV0wrHlXwk0vaCqyTE0Fb2LhbB6CUZqyN8dEbnsRM4BRAbLWndi
         ev/2wYMlcSGlNVdGWznf8A+cQWs7fGueXC4qKoQX9aiX2jYvnYuuqAyVve8hgxG2I0OM
         +t0O/EodNsjlNGkuSnsIOFAc1DSwkRsReVxkpmhy777BaaqzQo+sPZ2lqJwpth4Trooq
         HqfHqtIWZkQXYgVutX+1maLSAG5AupB6fDXhqLWK1VnfBFYQdS7cbE0Ml2m5j7xfEXVs
         HwRTE/fu2rHdRa0xmmVzSAUbp+qPLmTvQSCyb6fY3hsf81En3t+0zMeufZd55CwkojjQ
         VImw==
X-Gm-Message-State: AOJu0YzmIyVpE3TuUNMkqzrWVh/qPnBi9vwrm+CN/AXc+k1mizz7Oi6b
	mJc5avbkwgljBAlcHbGCBuswN4ADR5wrxENTW//MZOgUONKbnOBGDmNx
X-Gm-Gg: Acq92OEq14U3ZgtUa844JjO2Nlrkd82KIhAhdR3dato6EaNgd83Fwxs8YHdhAgRF23a
	UF5qONk49D6fDyIVbhKz3av5/8BzpjSOlCc3EVdrutCysthNcKS9qeHtKPi5y+kcH/EkPN5Ax7k
	qLtak6hclcgtJsJmiS9XLix3F7hBb7ypPOJQ65oGXB8p3yDvmD3g6KrodPaijG6a71NQZvQA+dL
	NUVshmCwTD6vT/60wBpGnvz9nwtGpJBpfl+LS57mVL/VD+yFjB6VPRlrhN+KEVLVRD5Ik3gd1kD
	mV99FIzhyz1eMhMX4U5jwJCYHf1Q7kR282809QwVPYsk0ilkst9s++Qw7XOysvseX1WXbXVRDlU
	YO6TCb4jrEDtgTK1+37Q4+DPSrglNYzj4XZ6RNWrg6pjKamLMfnvnIGdp5p9+mMV8vOBUzARTrX
	pzI1fNNa0hz4ZuiBbsHSdyN1L0Por4jhHXycLkK6JYS2kDJSUIgWpfvwJUUT3CEpjBQurMw7MAD
	2YZL19OcpFNK+J+FAw7mDvI+HP5gIMINAqh
X-Received: by 2002:a17:90b:4d11:b0:366:5c38:fd61 with SMTP id 98e67ed59e1d1-3665c390b32mr637639a91.12.1778230796370;
        Fri, 08 May 2026 01:59:56 -0700 (PDT)
Received: from localhost.localdomain ([111.202.175.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm15526795ad.5.2026.05.08.01.59.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 08 May 2026 01:59:55 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH 3/5] ocfs2: validate inline xattr header before ibody remove
Date: Fri,  8 May 2026 16:59:12 +0800
Message-ID: <20260508085914.61647-4-gality369@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260508085914.61647-1-gality369@gmail.com>
References: <20260508085914.61647-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupt inline xattr header can make ocfs2_xattr_ibody_remove() pass an
unchecked header into ocfs2_remove_value_outside() during inode xattr
teardown.

[CAUSE]
ocfs2_xattr_ibody_remove() still rebuilt the ibody xattr header directly
from di->i_xattr_inline_size and then handed it to code that iterates
xh_count and entry geometry.

[FIX]
Validate the inline xattr header with the shared helper before handing it
to the outside-value removal path, and propagate -EFSCORRUPTED on bad
metadata instead of traversing the unchecked header.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/xattr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 05f6f0a886cf..bbb25a01b097 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2476,9 +2476,9 @@ static int ocfs2_xattr_ibody_remove(struct inode *inode,
 		.vb_access = ocfs2_journal_access_di,
 	};
 
-	header = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize -
-		 le16_to_cpu(di->i_xattr_inline_size));
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
+	if (ret)
+		return ret;
 
 	ret = ocfs2_remove_value_outside(inode, &vb, header,
 					 ref_ci, ref_root_bh);
-- 
2.43.0

