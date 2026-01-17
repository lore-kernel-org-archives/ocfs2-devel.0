Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DA31862A
	for <ocfs2-devel@lists.linux.dev>; Sat, 17 Jan 2026 17:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768671363; cv=none; b=YQgZWGqAhzs0QeoKC5WKyfMpTKTF59jcp2wJuQPn2vAuUXQSjYZFJHJ3PPFE23Kqokwv6NLH9XBNp+UKGsts7cHK7PPxZgN/WQ0FQZjpvIBndNLEejWjzkKdb19qdOTXQP980dGRrJ0XGcRMCcH24zvbjvdMgML696NFHq6DLRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768671363; c=relaxed/simple;
	bh=d/Xd8lbIJpxHEMR70GtdDaBnejP2zuAYSUDriC4pb9o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mIynbNISM7ylEnNPuabq3+sTPYs1avI5HmmZkK56MnyrPi6hPgRAiG/RyF75Z7m/h1qeMk617Dd7gTEateOYSlVdTfexvkdgUFSn0C0D6ZEliNq9zDye9W369eNoUaS6Z6YMIqrKwtAgFPn7pwEt7y9QWg80509Ll34WSKOAxZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iunZYAFn; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iunZYAFn"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4044854464fso1435810fac.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 17 Jan 2026 09:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768671361; x=1769276161; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8aJZk2D2mGu5fro1JihtBVNptIdoq1xXV928GNF5024=;
        b=iunZYAFn9kPs7z8FIPMdhv8Jur79BrOmo4ID2/Ek24OGWNS29iN74tjpb/5ZeChB7J
         d7lEE5+6NXbjW23vOwHhM172SG4e29SfgW3z7B9S3r5l03/ilyks7JG6QgP+xANwoh2A
         CizrfhJgnkOveD2/TmJS9inubjSQdtmhMvtEr1he71B/rRkwlq0DbAybloJM+TMvjj5Z
         NGZ5F/UGDoMBZKcD4J2ZIe8x4fjTGIYJoUYme8XPKAEK/+Ss1XP9YC3HztW7LhEdDGtR
         KOTdIBI7XAxBVDtQGDNRk49zezy4+b/5tMSKp3sSXrNUl5WhfQd8vt+aaYcns8IKi13f
         kCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768671361; x=1769276161;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aJZk2D2mGu5fro1JihtBVNptIdoq1xXV928GNF5024=;
        b=mdGq05IS6riTA8CnzGtq0+TAds7eeRBxNzr/xdG9B4GJmLSs9XJjLJ9kBYA1Zh1QZ8
         xy/I5ekwMGxnuC/UvuAQSw1vC/bJKsmLZBbriFu+tWyV8BTEnCSzHC/OT3i4Yu6y/EsI
         Bha+Vwl3aJ1DlA7Vq3a902/xpOFWxyjmh4VC49b8NpTOadDuJqTm2sFrM3fzO/H9XOF0
         TU9Rw2/8M0P8jPzyHdH3k0gZ03fjmGUgBC5S96+f6mfhTjKxuDZm36XmCmmLwdBrCb4D
         UMN4+vgksZILim0O6am5Sd0jnz/Q+GS6ojnTwRc5ypNHhk9tuD5HJrCt693JU53LCJG9
         53lQ==
X-Gm-Message-State: AOJu0YzXYZBNc8ACYHTLNmybLNFY2lK1JxojvXjYq7A5HkruIOHXU6yx
	JhXB48eacPTQDJhAujYnKh8DxQugK9kjsXw9bKVJfbJvkd7731vRcfxO
X-Gm-Gg: AY/fxX41Y69UaVtWI22EFALjr0dnMr8m0KLSuf/km3XyV7L99Z8tdQa6oBKcj0tLpkt
	TBLaKJ9jn4GTxi2IhhefNiG+nG2VyJnvJMRqWi6+wUfbNyz0+h8oH38+mg8upLl4tTftmXdP0sO
	iO61w5w1Ow5xyYKNsTj2ovKQPJlv1T+7GeN9G7Br4RknsJGGFgtCvRxlQcNfmbWGMD51TneJObn
	Fww9FR9U1YaJHiV8qba+MW5yJlKQ0UoqgTvFJ2KirnAL4+nRubPaqK10SWXwnzMhVa8JYlx/zpE
	pf8QELnZhgA04UziFmvNda3KbV6eALgwhNUgJ2qvOFgh4HOyNA93t5D9COIC+PGAr4iQCf4noQL
	gCqYq62H1p1+GeWJ8agj8/peVrHE07mCxJ+MpnvKPtqJcEETmvytmYoqVcuWIJ/Fu1iLf34hGF1
	3tazLvtLItVDYwMMycF3hCp2vLsmtwEBKd
X-Received: by 2002:a05:6870:4785:b0:404:3569:59ef with SMTP id 586e51a60fabf-4044c4460ecmr3261476fac.36.1768671359836;
        Sat, 17 Jan 2026 09:35:59 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044b5c11e4sm3863140fac.0.2026.01.17.09.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 09:35:59 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] ocfs2: fix NULL pointer dereference in ocfs2_xattr_get_rec
Date: Sat, 17 Jan 2026 17:35:56 +0000
Message-Id: <20260117173556.36601-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ocfs2_xattr_get_rec, the variable 'rec' is initialized to NULL.
If the extent list 'el' is empty (l_next_free_rec == 0), the loop
iterating over the records is skipped, leaving 'rec' as NULL.

Since 'e_blkno' is initialized to 0, the function enters the error
handling block 'if (!e_blkno)'. Inside this block, the function calls
ocfs2_error() and attempts to dereference 'rec' via
'le32_to_cpu(rec->e_cpos)' and 'ocfs2_rec_clusters(el, rec)'. This
results in a NULL pointer dereference and a kernel panic.

Fix this by ensuring 'rec' is not NULL before accessing its members
within the error handling path, or by checking for an empty list
explicitly.

Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 fs/ocfs2/xattr.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1b21fbc16d73..b018c84dbc05 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3757,10 +3757,16 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 	}
 
 	if (!e_blkno) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
-				  inode->i_ino,
-				  le32_to_cpu(rec->e_cpos),
-				  ocfs2_rec_clusters(el, rec));
+		if (rec)
+			ret = ocfs2_error(inode->i_sb,
+					  "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
+					  inode->i_ino,
+					  le32_to_cpu(rec->e_cpos),
+					  ocfs2_rec_clusters(el, rec));
+		else
+			ret = ocfs2_error(inode->i_sb,
+					  "Inode %lu has bad extent record (NULL) in xattr\n",
+					  inode->i_ino);
 		goto out;
 	}
 
-- 
2.25.1

