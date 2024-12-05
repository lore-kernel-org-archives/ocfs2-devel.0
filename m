Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36FC1D8E01
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 10:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733395727; cv=none; b=erQdkRI8fE3OAWxhQPnfuWRRTW/v49zHU55bEu9TDA2DjGkOJ7BPCk6FjLn5A89b8MO4X2txcm3uM6e2qVjP49YC0HOul972Q8YwLJ2G8b4fenL5i+MhzDXufDcuBaCXr7uGVSX4VOnPYkBHsYji0aggE03oarQdENA8xwgAD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733395727; c=relaxed/simple;
	bh=MmgDZLSQtID9mT3Je11M6/sbF7asAJmRXqbPI1UO6rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdTCsGL9UU5AB3kkGwEG6Ye6AaSFVTgtNsFyu3J2VbSLNdTLrZMmNRPljm1D5ij+yA0H7xVEnTHm+2rTAUqJQv6DEWooDaNWASAtF81/BO75Dg+O4TWYKdv3RwfEF6HQu3/jMmru6eD9AApYYrvYVgj3J1CAaZRv2NOIj894Z2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=W5ACArpT; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="W5ACArpT"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-385e971a2a0so84218f8f.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 05 Dec 2024 02:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733395724; x=1734000524; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tzuw/zLX0WQJcc9n8LmQ2bz/aCPLkYLRBmSSAzg1cgo=;
        b=W5ACArpTdYmVRC8PeLiJZrck1axA3+OmPhrvIwLiprHQjZXbquNVB+IngFFXjJLSBo
         JGSDpRBz3ne7t1q8ZlwUq0D0wAxEnyzDb/BPyab8w4tauMMeC/ZvViMNRvwmvawvQIYw
         10yH0ya4xzaSezHI7CpVG2Ae1vHd4jwoWNZ5h7Y+M2V550f1eYqwPIC24iJVvGnYZ/1a
         DMGCQ906k8fHh1PVNsvc5/iOarQOzQv8rA0O9yUekG2MCKZt/6JStCk64Rt91uihw4vs
         nLynVF5rLQnZ0PSbtzXWmh8DyX5vSsEcO59j1EDFC+80Vv7AbFo9DNWBRRrehy8H8GBj
         lwgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733395724; x=1734000524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tzuw/zLX0WQJcc9n8LmQ2bz/aCPLkYLRBmSSAzg1cgo=;
        b=EfS9H8kwl4zsCrjYYF7EkKW808hHERcZY972Tzq6sfRdilYXoUAhqp0FkLan1HTKCr
         Y+C0eBrCH99yuFJ2UDNoZ4zhjqEzEdcsuJno/F8ReplwqXWc2ZqKwNDIjCtm3Hyo/EOI
         A34hN82ox+1UOsfEGGZ3SiyN6lyEmxAnFHEVC6VerRNgwKPx9pK47BorLpS5VWF1YwQ4
         0y2JoQeEWUP+qMu3h88RzAJSqsmi8CpkEOSbUf+oclcgPXkyZwse26pBBnWUOxEQK8iu
         SQkvQSENS8/xV2ws07LthNm8BrfwsvesFo8yyKaxFflTLc+idcB/48JxHjLphcHfLv4u
         6uNA==
X-Forwarded-Encrypted: i=1; AJvYcCV2K6TuXLbJFNtV59xAp/yBNwziraQTFJMBxslkV7d+7a9XFAQ2/AgysTasLSrzjrn+RIVcVG6N6NDIrA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6H0IKIWeceePxqK4IldhN0Is/Bp0jwifEktbP815PK3dPTZL8
	bBNRVGWwdfZAwURXNT3yo9l8usQvitJajz21r652xZ2fQI5M/RReMT5jPJtIBAlTT0B2E6RffAR
	4vfU=
X-Gm-Gg: ASbGncs9p8HHEvWPzbDAMKzc468O1Mg7J1uxIOdoezZkGnt7Hzi1Hj/4tYlBH/wyrtE
	48AVR5OqFuXh4TbyKx3tZsHVVvILYlKx9hMy+fKwNmh17FoRvd3J6WF01MxE3E/H+joytr54YTx
	FWeHA7ABwWxp/m3Wlj+wd3J3wAj4LXts+5iqSO+Zx7sU99meVib5KeIEk98Gt74/OTC7knpzC3I
	OW1MPYsc58Hlj0WuP9h9J4svgeiSvaNRbKYMxnL+aUqgHq1MLYlKw78O4nxc8tw
X-Google-Smtp-Source: AGHT+IGOivLgwrbcfAxI55SOIo7GYAysOTEQKhOrkf3R1BczYe6WFuJe7SnaKy0jMJc7mQC4v9gOSA==
X-Received: by 2002:a5d:5988:0:b0:385:e30a:e0ee with SMTP id ffacd0b85a97d-385fd3f26c2mr3542670f8f.8.1733395723996;
        Thu, 05 Dec 2024 02:48:43 -0800 (PST)
Received: from localhost.localdomain ([114.254.73.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef4600d14fsm1081629a91.45.2024.12.05.02.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 02:48:43 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Cc: Heming Zhao <heming.zhao@suse.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"
Date: Thu,  5 Dec 2024 18:48:32 +0800
Message-ID: <20241205104835.18223-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241205104835.18223-1-heming.zhao@suse.com>
References: <20241205104835.18223-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
unmounting an ocfs2 volume").

In commit dfe6c5692fb5, the commit log "This bug has existed since the
initial OCFS2 code." is wrong. The correct introduction commit is
30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").

The influence of commit dfe6c5692fb5 is that it provides a correct
fix for the latest kernel. however, it shouldn't be pushed to stable
branches. Let's use this commit to revert all branches that include
dfe6c5692fb5 and use a new fix method to fix commit 30dd3478c3cd.

Fixes: dfe6c5692fb5 ("ocfs2: fix the la space leak when unmounting an ocfs2 volume")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/localalloc.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 8ac42ea81a17..5df34561c551 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1002,25 +1002,6 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 		start = bit_off + 1;
 	}
 
-	/* clear the contiguous bits until the end boundary */
-	if (count) {
-		blkno = la_start_blk +
-			ocfs2_clusters_to_blocks(osb->sb,
-					start - count);
-
-		trace_ocfs2_sync_local_to_main_free(
-				count, start - count,
-				(unsigned long long)la_start_blk,
-				(unsigned long long)blkno);
-
-		status = ocfs2_release_clusters(handle,
-				main_bm_inode,
-				main_bm_bh, blkno,
-				count);
-		if (status < 0)
-			mlog_errno(status);
-	}
-
 bail:
 	if (status)
 		mlog_errno(status);
-- 
2.43.0

