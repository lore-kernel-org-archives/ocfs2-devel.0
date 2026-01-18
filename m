Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C7723C512
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Jan 2026 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768763128; cv=none; b=j5It494n28YN30pWhUnFNQSIPpNvWPWA+o9oBPJRJCnTMtqWDoozQRK6V7FlG8eIldsvDP4QTznCFo3gRYfuYvpnPpj4g5rQF5kfSwqdXDEle7TBmAowEUF7gTE0mMz7psEh8RC1fI6dZPC+YAAb8K60DmmT4j0ROnD08Te13wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768763128; c=relaxed/simple;
	bh=S8kEIvQIwdZFXzIF8ztDvmPcfyBILoy9bD1nB3RaMDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UsWNRYSKHIvR0pmpojCwqFWkJDuaybPMt4lUQrTsZOoVS3eTmxw26Pu0voaROmXJgDK1GvR+OpOD8gNC9XqJmj6K03dQ8Wz4rGdS5AISe7uNNvZDgkD+pn1SylOrgA0jwxEzTckiN/BpH7SGi5jowjvvb91I4IMzrnevm6nB9F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I5Ihmy0I; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I5Ihmy0I"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7cfd57f0bf7so2274438a34.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Jan 2026 11:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768763126; x=1769367926; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G1v8LCOXMXHNC92zsw7ixC/eJfK8qg6Eg2mhXIIp5gk=;
        b=I5Ihmy0IvXXjFBVsImvm5BlpQ/xyBG0dW6pw7xSf5znABE9fh7z8JHtQvENwe3vBa1
         IuRYvmdnt3xZbfcsiCM4eccli3XosIWkSIMcCeoT9I205oCMweB4mWEijJ1qDRljmIth
         6/BVLx/Zw3HArenawtlExWowLqpsuE3Zvg1Q5K6pYszbA0ej4H/i9NO6xh1WGSifXn0W
         xPKvTx4ul4umaV9W/pyrgugwXjZn/5UE/HrP3zVcmlIuuUyaPLS9jMfVgWyV6PuHsLBm
         C7rUUrtAVt99cHhcuvfL96qkIzivIJ9iFi2ZPG2pQv2GJu4sQj7P7+5mOj79DWCrvWVr
         /37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768763126; x=1769367926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G1v8LCOXMXHNC92zsw7ixC/eJfK8qg6Eg2mhXIIp5gk=;
        b=TYB1NoQf8LGpN9p31BxRuKqpLnFkAbZUT7B+jC36gExBj+LXnP+tVBe41sZh590Cam
         ZbvgTtNd2nhNzkyuGUoYShtEnGdM8RK7Vbg0I+y/7/4ENCoSfnGSeD8mlQ+sjBMNUWxk
         U1+HZpCSyero/LbeAAk1NYIdzXjgKMg8teCHT61Ph0DkVgu9lKG9640JIqPThDpMBctE
         0aBi32zdSeGU9Bk0RRw2plgjMeDh1tFzw88AAomkQ9HS22UKeP5Q/y4rVn19/VgAVqiF
         ja+hmcw8nNPcnUTz6yu7TGNjhpsEd45c6GhqSTtVh6fy3ARnYGOOIdQp1m2xdb4l1SxJ
         np8w==
X-Forwarded-Encrypted: i=1; AJvYcCWvVwHDb4M/YtOJWn8bXDWmvud4xldxkKr6Yn7ruGD9Q4HdnSNMTMX5vogQSgs26++HYSCQvtvbL+weJA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxRAHFqnziRQEQBDD8m73fhcS6Q5WbgvDI9oIss+nQ5Icr2vYBN
	CWZAtw663t0jJN7DFNgqVwzoPYzEf74olKorkRvgftMHWiuuZCqWZoLq
X-Gm-Gg: AY/fxX6WDoVjpXQq9OupY9HvYo7XFbGOd4NHwpJdjUl5Xsw12B8JeCQg6kBcWpyBOuJ
	9bccnHsjznveV8ELFnz8bsBnJgkEtDv8C41g7PN0u65KGQZ3WxRK6DG5CbDs3xutlx/KP4Anj+x
	ivkIp+IzeZMq/7FtvUjJJjtTqiPLAOOOLQF6xd7woMn7C+RDEDRfxrpXBCDM0Bk/Kjy8tdQZS2N
	Ng/vVzT3G6k6sivUkQWeIB2uSMxGTUS/Dp9BOQfQaZQwZupzJjif3xwgWfTLEQ0vu3Q+AnRNWEx
	dfEnrohs1pzSf3XqOQigg4Xko82V3oGBxZHlNd47/vFUva1iwuNXbH5zrkJ6YLZ+gLKfpIdZqqq
	FkZLQg/Xlbm2P6Ns9Uc/wEGXWk/irwvfn1hO65PO3doeYJdJgXAHxObByz+R5GHolrdPBltyOqX
	jJmd5LhOEYYBJFKaMbYFGcwHbKS/Qz2D0D
X-Received: by 2002:a05:6830:2a91:b0:771:5ae2:fce0 with SMTP id 46e09a7af769-7cfdee132fcmr4813328a34.20.1768763126190;
        Sun, 18 Jan 2026 11:05:26 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0db2c1sm5540750a34.5.2026.01.18.11.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 11:05:25 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: jiashengjiangcool@gmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v2] ocfs2: fix NULL pointer dereference in ocfs2_get_refcount_rec
Date: Sun, 18 Jan 2026 19:05:23 +0000
Message-Id: <20260118190523.42581-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cfd0e0eb-894e-48c7-948e-9300a19b9db7@web.de>
References: <cfd0e0eb-894e-48c7-948e-9300a19b9db7@web.de>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ocfs2_get_refcount_rec(), the 'rec' pointer is initialized to NULL.
If the extent list is empty (el->l_next_free_rec == 0), the loop skips
assignment, leaving 'rec' as NULL and 'found' as 0.

Currently, the code skips the 'if (found)' block but proceeds directly to
dereference 'rec' at line 767 (le64_to_cpu(rec->e_blkno)), causing a
NULL pointer dereference panic.

This patch adds an 'else' branch to the 'if (found)' check. If no valid
record is found, it reports a filesystem error and exits, preventing
the invalid memory access.

Fixes: e73a819db9c2 ("ocfs2: Add support for incrementing refcount in the tree.")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changelog:

v1 -> v2:

1. Add a Fixes tag.
---
 fs/ocfs2/refcounttree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index c92e0ea85bca..464bdd6e0a8e 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1122,6 +1122,11 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
 
 		if (cpos_end < low_cpos + len)
 			len = cpos_end - low_cpos;
+	} else {
+		ret = ocfs2_error(sb, "Refcount tree %llu has no extent record covering cpos %u\n",
+				  (unsigned long long)ocfs2_metadata_cache_owner(ci),
+				  low_cpos);
+		goto out;
 	}
 
 	ret = ocfs2_read_refcount_block(ci, le64_to_cpu(rec->e_blkno),
-- 
2.25.1

