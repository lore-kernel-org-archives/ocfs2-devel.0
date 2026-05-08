Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B3B3128DF
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 May 2026 09:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230812; cv=none; b=T8bo1EbB30HIkqJ1YiSi1Ib8Ktpa4EoaH/JF840887Aoz28bzOAZAztRpjQ4pBvnkjN/t6L7y385aremp+0/arH38itxqpTuiEzNxE29v35kZIPJyw1G83CdFTtgtbWV8XrNAIKs6BbX3kLoVERr8EE+65TpF4bppW/h6pccRVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230812; c=relaxed/simple;
	bh=+3eeuhMFHiZpEQg2KROqb6kAg440DvMXMgb6MfwVrE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvU5F2u0T/xLjkzMFelQ4L5ZWjGB+lPnrNHTetg6zHZKaPQnFmiPVhfD02do6C58VJf6hGFbbLH3PKBbDszt5uAOYdIG0OhlHE18gjMIWnf3xkAt7QVvMGc3GIOIuoxDx9qvRjwaVFJLSkShxjCEy7uwWHDNUxnI3RDKol7vkUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nV93gM6g; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nV93gM6g"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-366089e42eeso1092021a91.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 08 May 2026 02:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778230811; x=1778835611; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hICkrsufTPcAiO+G0L5Bnkf3gB8EUfqghx2E/DerwaM=;
        b=nV93gM6gdrVaE53M6+b0pT+i5UTUYh7H+nUpIKTctFrdq2PdszwuQ2iQMgfWbQZXPb
         90qu+anrFXgHvOREnrfT8cP5i0/6Rx8iqm2BhKx6ISnn8mDTKIOHdJr30BSYVWVWRQ4H
         hcV2+FBbl1lG+HO4QrY/hlrYoANsfh2H//16hbUGUSnk/0P1bgbilPNTkLXtoDLcD5hY
         OkTRRpqVeUD/KHJl1VsmXxWnAyFGY2veK5n9HL6CWHI1BUS4v9m5ljLgPtXJKiVKBKjO
         lRknFjvwgFP8GDyRCzBzg5tvG1eHhEHIx53/dtUeQTI65QUiMsKjPb0qwWvLqMFTeHIZ
         aq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778230811; x=1778835611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hICkrsufTPcAiO+G0L5Bnkf3gB8EUfqghx2E/DerwaM=;
        b=QzNwyj50SXwsfc6KHWmQpMsXak7eSGR9zDLeHhB1yw1rpP66uAZKZlgwgADu5RnQ7w
         lM/qYOXfPLlPubnYoLImZ4XRJncPz6lrKuquDhWf1clun5qIkoellX1M4Ox1XQSNwEOj
         93finNu0Bff6Euoc7AAHSbqxDHJJnfhWptyjnmX0t+QGDsi9a+fpCdgJGKSRq4lH5rYn
         UTzrPYutjPfIS9DQVvJC3k2aNGcAWaaibTO6+D/YlqIenjKs2ICa/8Q1hkmQ6AMkOF5M
         rg4D0cbWnzotwu0s9UARUJpeU53xoWI2ldrasidl7/7XDL1lFC8+2QBh7va40XijLaJi
         V5ug==
X-Gm-Message-State: AOJu0Yx1kY4PUI+VGBLgzNgOJNlCBHumm7UUR2YvQ8diSbjEhT2FlXek
	Bl1u7k4HIEZSE2TcbhGk+NLmIq/sNnMIO6f1cuvUpqnK1yPHTEd+AGdA
X-Gm-Gg: Acq92OEkaS+DLbB90YRMhw4cP5B49v74MI+HyCx0Cvfv1NrmV7Dc4S1paxJtbApK5p/
	CjxzUIEhuRJPoSIp5JuHaR7Zwo8D4Tdo+AP09yXmpVTCMcNp4+4NkXOaVzMP21elwZFiMNzDoAA
	nytAXf4KM53byj2gieBm+S1W9qf99ky5knzHv1itUaIFOqg/JUm4dUgTjYgbyGDcjtVRLA4vF4D
	LpcRiZoZ4Gcc7wQdKy71/00CuLLg/vSvwoVR/8ueoTjr1mdKKAXucIZrugFIS4u/apG0oSXUCuO
	HBmVR3x0uIecRNDoes+bvX7oGXPwJ3wGZFzdBnm31LxuIfGwvWpp9xUHtxY9yCofCWmSxpOIZnA
	EWq6I8zjEEP5aNAFJ01vMhymoC/miRixryRmEihxVGlHZqEF0CcKtoSSby3l5yDjZSAgnDBWjH9
	f4tBvcF6W3GDxpplNArnY5cNXDcFoBLmtohMFFLHUnRLoSM4OHUR7tSm1T74DpivIxLK2eofoUR
	VQUNu7RtqhYA6OyvWEWtDUaEQ==
X-Received: by 2002:a17:903:1a2c:b0:2b4:6470:760d with SMTP id d9443c01a7336-2ba78f473a2mr128246185ad.14.1778230810627;
        Fri, 08 May 2026 02:00:10 -0700 (PDT)
Received: from localhost.localdomain ([111.202.175.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm15526795ad.5.2026.05.08.02.00.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 08 May 2026 02:00:10 -0700 (PDT)
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
Subject: [PATCH 5/5] ocfs2: validate inline xattr header before reflinking inline xattrs
Date: Fri,  8 May 2026 16:59:14 +0800
Message-ID: <20260508085914.61647-6-gality369@gmail.com>
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
A corrupt inline xattr header can make ocfs2_reflink_xattr_inline() lock,
copy, and reflink xattr state from an unchecked ibody xattr header.

[CAUSE]
The inline reflink path still trusted di->i_xattr_inline_size to compute
header_off, xh, and new_xh before handing the source header to the reflink
allocator and copy logic.

[FIX]
Validate the source inode's inline xattr header with the shared helper
first, then derive the reflink copy offsets from the validated inline
size/header. This keeps the reflink path from traversing corrupt ibody
xattr geometry.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/xattr.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4877406a83ce..fcddd3c13acd 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6511,12 +6511,10 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
 	handle_t *handle;
 	struct ocfs2_super *osb = OCFS2_SB(args->old_inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)args->old_bh->b_data;
-	int inline_size = le16_to_cpu(di->i_xattr_inline_size);
-	int header_off = osb->sb->s_blocksize - inline_size;
-	struct ocfs2_xattr_header *xh = (struct ocfs2_xattr_header *)
-					(args->old_bh->b_data + header_off);
-	struct ocfs2_xattr_header *new_xh = (struct ocfs2_xattr_header *)
-					(args->new_bh->b_data + header_off);
+	int inline_size;
+	int header_off;
+	struct ocfs2_xattr_header *xh;
+	struct ocfs2_xattr_header *new_xh;
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct ocfs2_inode_info *new_oi;
 	struct ocfs2_dinode *new_di;
@@ -6525,6 +6523,15 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
 		.vb_access = ocfs2_journal_access_di,
 	};
 
+	ret = ocfs2_xattr_ibody_lookup_header(args->old_inode, di, &xh);
+	if (ret)
+		goto out;
+
+	inline_size = le16_to_cpu(di->i_xattr_inline_size);
+	header_off = osb->sb->s_blocksize - inline_size;
+	new_xh = (struct ocfs2_xattr_header *)
+		(args->new_bh->b_data + header_off);
+
 	ret = ocfs2_reflink_lock_xattr_allocators(osb, xh, args->ref_root_bh,
 						  &credits, &meta_ac);
 	if (ret) {
-- 
2.43.0

