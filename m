Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B015B23BD01
	for <ocfs2-devel@lists.linux.dev>; Sat, 29 Nov 2025 19:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764443627; cv=none; b=mDsssezfzckDp/MEctGx7brFrU10LDey5snq1w/sskjNKtArY+LRBW3qhGYvHTa7vN+t2syOwu3RUivI/kWxPW/EYndlu3H5xmD01BbWljslQz5CE49WgpERtFuFyxrQyjbtop6UuFPhrVuF6IuqqgYFXOMrovf2GKqKkcsvAlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764443627; c=relaxed/simple;
	bh=6PduEZHtDoyfi/j6RY6Z5HWxa4pjjLC4+VZY8Kc+i9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dIpqDJW65hYMyEZSd49qkyv9K0IarfBsdQYETQV1KgaSBf743+eHBBxzbJhmzZAUZnEkONIqiQ1pk3NgQOWrSL92626ilG8MYvnFnvKgXhtBNYIEP1Hj5uwbItqwdWDfWYgUqgyLVkGRk54/VQdI/7W0OsWl+lA/BdKx/iOEUvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RpC+GSiZ; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpC+GSiZ"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3438231df5fso3408689a91.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 29 Nov 2025 11:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764443625; x=1765048425; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OdjwNiGIrnIxWmeUPDnAaaorwfoimjeDrP1Y2u1MFng=;
        b=RpC+GSiZ450tYSqQYjCy54q77hBtfSiAsqs9BZsBlJX5lnvpisqVX0VZ0ux3N5RARo
         eTtRSrky1zpIkZl6+64ycX9P8FcrvCstxeS8ZqKm5H8FcQL2yGF2iLlZPbCZVmhbxDVW
         8R6j5jjvGcQfohnkpkQI6U5zxWu6c1frAYrNENfvvI/xk891aHYt1lgtdSWHH1O1ci7G
         cSrmUaeRMrSvr8HB2BRqTTGuVurifkdp04DZvlwo9eoLNQtqNYe8ajuh5gJt+QY7mScA
         dq2Rij4avzLv0XirfO7sBSd29HLbZj3xo0ZfraHq5VIGWmnBnxsHUV2eDsXnaWoYxmKa
         MRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764443625; x=1765048425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OdjwNiGIrnIxWmeUPDnAaaorwfoimjeDrP1Y2u1MFng=;
        b=rGjtBmBpHpPE29C4oRiltK9vnnaiUys4Rd8RRcAhrFgIY38WogPPsvALXwirqArhMS
         fhvLdUFvjf4zTzfqjFwVhlM0jPKXB1zvsJKnTaRKweaEjaX8qGcJ92RDQjpF+ew2KvlT
         4KXAgJ+Aa+J27hjUHQYjcXpKIzoswwtpkfoCRpFxxJWVVl0Hn4WrJ9nmbfbb69cO2qaS
         v0dC6W54F5iFuNmlY9MrqLLCQIiEwaDr4XHRU2TNjqh3fLBP48eJAEdtjqBBMe8l2NbG
         epXYC0Z1scXmZ3GQWUrSpQKRWhAqeWr/LBUYCZVAYMai8jUly0hbHEfpEa/0m3Sxorw0
         fg5Q==
X-Forwarded-Encrypted: i=1; AJvYcCURmOOy0hvW10mI0b+whXTsSKga9zca1Ae9BF7fGYgYWs5Kog/AlFIjchbX9N3p+aslLErHvB81740zTw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5AW9c3j3E/IujBFNaOmC2Et5GmCOVNExNxPiFaMGMmwkAaeJO
	j7x3uX3EuPf0XJfpnQoWYO+Ifq1/6kU5IoZi9LiKLttdoIlvrnm2uQrx
X-Gm-Gg: ASbGncvHFq0gKS5Yuh4D2Ch8Jo1CIiQLGNiJzLnR9wtkSSTW3yM+8WemL6QfJyjzON6
	zXBT+woDDdmxhowEIbaRplcc1ZA4MHQLZms35t/16+PSPLpu+mFMm7pSWq7MC/TkCNOY3cG0zjA
	B7xuM3Ink0FTHa3JFJB8P2QvAN0WF0kOpQOL/BiE415X/ZFbtZwP7kkQfuYw4LeiIE9fGxHA82J
	Su3ul9AqmPpU92GRHso7GrECB9+BclxpNw7jbmxiJa0NGOT368nQrxMasCo3GHmac4Jsa+Nk8jv
	TCGC0u6QAWO0VSm1XbVLbZ9Pe5JAilN8U6ij/xNNINwRg6TDLr4Lf1petcuuut+wUjace4glG+F
	EZuR5uaRr6pFApXnNrCEiY3RbpA1jkOihI9lRc92l4jXW4JzO4Vk1/esCZxte+WswbGkGiZXdH+
	eRTNAGnpdYalQB4UDcE7NmejZ8XHk=
X-Google-Smtp-Source: AGHT+IEnc7jRPWN+4pjTVInT6mtgQCpsiQiDLfCpFb9CjkocgbvSfSUpr8yChmnn3p4Cl1Q9t28fuw==
X-Received: by 2002:a17:90b:2f85:b0:33b:ba55:f5eb with SMTP id 98e67ed59e1d1-3475ebd2f36mr17444636a91.1.1764443624939;
        Sat, 29 Nov 2025 11:13:44 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3476a547483sm12270546a91.4.2025.11.29.11.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 11:13:44 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Re: Syzbot test for fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Sun, 30 Nov 2025 00:43:36 +0530
Message-Id: <20251129191336.546692-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <000000000000560ff106204134d2@google.com>
References: <000000000000560ff106204134d2@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 939f15e640f193616691d3bcde0089760e75b0d3

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/suballoc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..c7eb6efc00b4 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1993,6 +1993,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
 
+	if( le16_to_cpu(cl->cl_next_free_rec) == 0) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has 0 chains\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno));
+		goto bail;
+	}
+
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
 

base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
-- 
2.34.1

