Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635EE348898
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621685; cv=none; b=t4ztSfNZhOPOI2rsgvtPb1Fy2Tvgk+pdbO3kILh41t4SVG6cI7BXKQ0VHtLyyWQEVS2lIp4xAFy9KjIX0kjv6FC49d1GYUXNEMg6o9Eu5+Mwv54jGnT+D7rDzY7BIFZOThBTHMwYR+AfZPwQnzT9EO7aS+6jjaFuOYh/Y6HgtJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621685; c=relaxed/simple;
	bh=C/EU16/I7KCMlmfQlOxCpDa7gi9I5VwIhNBsZBfHyYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1UdWsFZu/GsEJNzWLd25Zs0/34oOFRG0pDnUmIvOyAXnO2NTJmyXi1ylOzMw4jAkKNoqzsuYziF3slJ5mDuHEYfa7WVqAjO4OJJUoG51NmLn60rFnzALkHZueoyU7sFOmPYIs8g6ax6X1NJRUsvTn4rgx27UUh5yowHWynMxBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DET0R1LE; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DET0R1LE"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-81ee41aaec1so29632457b3.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621676; x=1786226476; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RmlziesBf0p1zLY+SBouFO3AuG9bJkIG3U4FWyI9lx8=;
        b=DET0R1LEYaHarB16z0reN0w4x1CXVpY8oA6eapazbw+klgMk9OMRd1BZfzGGqV8dfE
         tfYi1IN9NCOdREpb4UK64jXcXp71U3iQ9XMxcVnNgkdCMEc5/ivdcZ/fFpDJCGAt9IEo
         DNRwmzX+DZm8H2o5iJEGTpk9Dq/G5tiO9TcF/JIKHtTxJg1tJAO2tv+32ccXGytqUH/2
         kDlBJfS8IVJS1etEw3b5V1SkkfShD1mzVwOPXcYB7bOYGIWPtdBwZzK8tcfGOnBV6J4r
         MD9cFH5W065pNZJey9KUcssvsxAHCS5OjWQEMJclPEnWQ2A5sZs8x/y+UqUgg/5RXitS
         h4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621676; x=1786226476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RmlziesBf0p1zLY+SBouFO3AuG9bJkIG3U4FWyI9lx8=;
        b=lEg1EOI/CsXs/nFa+B2NuliScQAMNsPTP8joJpvWQVqzu/pakOJ6So8HTLLnGOtV+j
         h2aDfwKYK344cMm3NVtpo29XaRbR2kT9lzC4Y8NPd64AemQ1A41jcDLViSVaGbMpxHTZ
         tRSCMBzAdT9QObgHdevBGO+5c/L7ebKmbizbqRNQ6WudOEMjO8xqInUUL6FTdOOb2+gX
         2O7C8mRqAEdK1kFAK7SbLpjlbJviFrT8hykEOCRYmZYJNAj8UTXGOoGc6VUYW8Tt6HLX
         uHiOCgYBa+K6vNGncJcatZufGlTS80eFtqia7TMvZN88pIEND9G+YHdKtkIdgfPSDAPO
         pEAg==
X-Forwarded-Encrypted: i=1; AHgh+RpL8FyYKgT6KZVXNVKpGGWPfMy9aVJPpubMPGBCNUacwCVlLQUxz7mvApzJOMzE721DkyfE8b01KbFQxw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/h1RQ/qFY8SRTkeGclEl1GTTa4vMHk6RDkW7B0Cg3weXUMFKC
	PO8wOqaEK4mfnCXMSava31jZM80Kjv6Swfoo3yJ4UrBAhSeryCf16WkH
X-Gm-Gg: AR+sD12mctS6BHEyth8m5dmpo4o7ub/ThqcmTH/zKYaDE45SAbnqxz6FQMwdak159s9
	xS+VwhOZ9J47cG6G5x1oqIbgM1ZQexSMfm+dSAgYPEelmektZAXlgbBKHDIvTxfWpINjokEB0zR
	GTf/cqEkHAzjs0R+5zSsk4FEUITvxt8ea41E2HRGkXqjF2rK4cdD5fwJzvfe/KNtTLR8SwAHQtN
	YqLSXupbvonpRtJstsoPQhWdzTJX65KTlHzP/chUn/vRn++MvNm04NzvNu/7b4trHDXHPpoIeAq
	xu6s3cV6+r+YQ57CUemgz3RbWCO65ZTX6IsACe51jpa5+KdJQjxezUl4f38fWgcVmqiten1cO6y
	dQ6ZEpR79Z/0CVJPLrdX/oytSfn/YPI78uG+OuPRCtCJeqrC5cy6qwLbn8U54MZ0qbXEW4uoMxw
	o94posdJrALxfLjMpoWsm8cmwjjNiESqfFh30ZH/V+jcUhmP+1IEHAApOukC84mwAsEdA8Wj7MW
	yB8A28=
X-Received: by 2002:a05:690c:6286:b0:80c:8d09:3880 with SMTP id 00721157ae682-81fd4a86754mr73431087b3.15.1785621676098;
        Sat, 01 Aug 2026 15:01:16 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:15 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 05/19] buffer: discard BH_Write_EIO along with the rest of the buffer state
Date: Sat,  1 Aug 2026 18:00:49 -0400
Message-ID: <cc452f95db52e33ec00270b7e3a3dab892261014.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

discard_buffer() strips the state that describes where a buffer lives and
what has happened to it, because after an invalidate none of it applies any
more.  BH_Write_EIO belongs in that set for the same reason: it describes a
write of the data that is being thrown away.

Leaving it set means a buffer_head reused for a different block starts life
carrying somebody else's write error.  Like the bforget() change, this is
mostly theoretical today and becomes load bearing once the rest of the
series makes BH_Write_EIO the report of a failed metadata write.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7889c30d8715..50a63d964815 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1518,7 +1518,7 @@ EXPORT_SYMBOL(folio_set_bh);
 /* Bits that are cleared during an invalidate */
 #define BUFFER_FLAGS_DISCARD \
 	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
-	 1 << BH_Delay | 1 << BH_Unwritten)
+	 1 << BH_Delay | 1 << BH_Unwritten | 1 << BH_Write_EIO)
 
 static void discard_buffer(struct buffer_head * bh)
 {
-- 
2.43.0

