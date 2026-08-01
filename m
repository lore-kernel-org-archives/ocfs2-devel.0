Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101BB348C77
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621671; cv=none; b=R4Fy1RWzTe6ZMpsBANsXfZ+3C2pHaeIX+Ont5zuAcxUvmYMvgCBE5hGOzxt1E1vRizc9vOo+NSGGRbSSNb/8UabPTPCBwpirt0AuQHfqEWfLE7+n+pL9pobEPfudK+Y/dqxyNW4LOQaOPpvFVLRqBfgrRGCxq+V4WznSNdTTVzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621671; c=relaxed/simple;
	bh=fQPgfXMhlq+1VG0MRuQEzdSC7q5vWTQFKVnCNqnuFvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sur+xfrFKYP0Mm0zrmuXXDZ/A/t7QjXa8GvTbgk0YO63BgvIgo5Z90NBz1qx3afv0/lX2JuBai6D/FgVi5QB+WGIgwaWpmWTSZ7qGOuduE0YzIYcgMZdKhi6yEZ3JnX4QDxsjXHOxkCeZTJ/Jtn7LylGmCxYjp/uSEIJM1mpYeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QtM0Lwpi; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtM0Lwpi"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-81f36179d72so31506177b3.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621669; x=1786226469; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=boTJ4NLnnkEUxDYA6Ii16la58dxC2XdEwOIDbV8GTAs=;
        b=QtM0LwpiL4jag1qhtcfhZNmuolHSvtcWHqg+5ZWoNHgYTymr9dxiQvrKfo4eO4Hnpo
         LlpNNkUWwmzgSNVN0ELXRAu54WxGUSgHY8i6uKNPS9ylRd6gb8XOHUCFuA0fhDBAlnOS
         /2Q5p4Oxc0g+xRzQze4ETQvConyoRHBXeuVSLqSRlbHDVrYhmlRxNAo+qyyu6sH79QpP
         jlbydJSZBRHjjNElZDC038ndt1gBCONFsIEVps8BJF3J246EeZwu76l5VdLnqLZ9eOPV
         SUkX6jgzt3A+NkNaFgHgFOEjX5zxDYRNFJaRPi9Oqn+jXwvWCkYMXFPFIoBkS/PXy0nK
         DQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621669; x=1786226469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=boTJ4NLnnkEUxDYA6Ii16la58dxC2XdEwOIDbV8GTAs=;
        b=c7jbIwggMLUCm2UQammRcU7LYyG+sbpHztAzFmOqhToen4iBYIN2A/8KAj2QaatzPz
         NgKNDI6ch5nAQv4QStchdAUojsFhI5CDsiE824CJZ2eQ60i6oWwVMQE99yg+T3t/2mZW
         sTjpt4O4iGLRJU4V1HYyUozpOdHjiIvOHSJo1eDCshxKtZMq4p7WKwJEHCEhRjfGJShS
         UQYirYrQ/hLK5QgeBkcGYeenFAkcAqZIZ6skOLvGw0sogz7N3Y+CwkKMB/23FBJ/Qp/B
         AlslCYDONBVMrdiNlgUarBgMY2iJVaKE03zzi4xvoXDARwHAEnwCSrH0kk5IbMQDvaCr
         bSGg==
X-Forwarded-Encrypted: i=1; AHgh+Rq0nU0bPbVQPwWJTf0tWh/p+dfZPli6TyfsfMOUFMvHMfjjpxRumG116Y1CpQlHCbz209kCu9lGORHxMw==@lists.linux.dev
X-Gm-Message-State: AOJu0YySLmGQwh93gSa91MxlhrpAmvxu0dJBjofofqFMrLH2qS+wIT3y
	9GHVpiX/IFSTH1pRXkmzEuQlZoTG4qNWxpHLm9Kwk4vU04vABJzUeKZd
X-Gm-Gg: AR+sD13MxeDQasgap5CgztWA4L54XIqhN/VWAM22HUyycOEN1i/NIpwm9+MyruV+/ln
	8/P5WEoBgq5ZtKmdVjKjZN7RU5z6G4AUu++f2HhAT6Hxe5ex75kJDClJlrQ5fwmAO6y+Tg4Z1Yv
	CFejkIaadxIKK1ejDwaA3pDT7CB5P2+OdE1H4VkSheGC/KZ0rIS4HlWcsTD412KyJVE9aHhO8zp
	K8tbBdPcWGoRbrmUWCFsXOlDJngJivwYY5tflwwnXjXvgTZkOkx+1zZPlR63RUYcVeEiX/IXBDP
	3s7+ItTlkZgmzEWXp8db7FpDyzcC7vd68aPAI8IcQIPQqHL8ECeFD4Kx7F7ASlPMVu7K0XGGvKI
	MoSkYDFb5kwvwftBdJJduEbqHRuv5BNTxHUNCHXSBCcAH5cBkg3BrCMrM9hpnhuHGRawK7w1zp+
	8z9Rag2pKX4aSunRFDbLcBwJxpHuNgAB0CnRfmTrMfco6kZdw1lEIgu8TT0vdoRRUCgkIjq67x+
	oQolzQ=
X-Received: by 2002:a05:690c:688e:b0:81e:c998:9c9a with SMTP id 00721157ae682-81fd4bce906mr71495667b3.17.1785621668857;
        Sat, 01 Aug 2026 15:01:08 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:07 -0700 (PDT)
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
Subject: [PATCH 01/19] buffer_head: Remove b_page
Date: Sat,  1 Aug 2026 18:00:45 -0400
Message-ID: <e0780ecfda9137d5755b4ac3e227152bf4c7983c.1785621505.git.coshi036@gmail.com>
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

All users except bh_offset() have been converted to use b_folio instead.
Convert bh_offset() and remove b_page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 include/linux/buffer_head.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index fd2c7115c054..699970b4bbf2 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -59,10 +59,7 @@ struct address_space;
 struct buffer_head {
 	unsigned long b_state;		/* buffer state bitmap (see above) */
 	struct buffer_head *b_this_page;/* circular list of page's buffers */
-	union {
-		struct page *b_page;	/* the page this bh is mapped to */
-		struct folio *b_folio;	/* the folio this bh is mapped to */
-	};
+	struct folio *b_folio;		/* the folio this bh is mapped to */
 
 	sector_t b_blocknr;		/* start block number */
 	size_t b_size;			/* size of mapping */
@@ -172,7 +169,7 @@ static __always_inline int buffer_uptodate(const struct buffer_head *bh)
 
 static inline unsigned long bh_offset(const struct buffer_head *bh)
 {
-	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
+	return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
 }
 
 /* If we *know* page->private refers to buffer_heads */
-- 
2.43.0

