Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265253A5E7A
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035541; cv=none; b=a6EqRvyCirqiQwuLVozgd6/5y5gxff/Aol2kOtupERiv63BKnKGrpRcugp3MbTHXms0xnK8fauyfJS+77akKHdvbdGt3wDUC6gZuUiczVQCs0Eyx8FHHw2pJ5J5EdaHNI+r+lKfk4eHXbyXOEbEO3QQDwrGEHUyGhGOaJgKJkx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035541; c=relaxed/simple;
	bh=lzP4aegwZTPCQw0cJ3VVWrrvdN+pa1Cx+PvabTKZT/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlIefpwoimzVpwkf+/xUaSeo9fIbUJ7f171ReNlACMo6GA1+VxUSXY1fHCKWNRfqdMyT6+2aT4SzUFV6dO5qB47VRfkNgXtsAwTnAiihokVGGpDk7FyEt3d35fHoeWgxVHeBhLdT944nF0DLS8cVNTkl48kLr8jZIktgXn+Z8AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJzDELcI; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJzDELcI"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-59b074ec7ceso898934e0c.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035539; x=1786640339; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l4wawGSh1ayASvpYyyNUW0xG9j87AeVkrycNAPRNAqw=;
        b=XJzDELcI4pug1LxySpab90YPd69esyVfLAO4wCMgQvZDB3PmPaSmBt4JSlEsl7IGxx
         546OPzAFUIX1DFoRJbqRJohihg5gNTth3hk5NtkXgJYcelSJHh1OZgdR9Y1b4a2D8+hs
         CS9nsJTCLuceqX7IlIalmK1Q7wZTgZXewHwJzN2I3NYncRQIMQ/ZfsUWG6x0bjQhCPq+
         W0VBKwb9ooawFRANHRUxPkxsj5/Htrm/37SPpFpR7K5+DlBRaGJ60zVd2oU0HSwWdVXN
         UuwRG+6jWOyZEkGDdN9m6Isl4QikZHt4V1I9BQoyZKP/3q4TOBQv4NmpHjeZMv5hTCuD
         PXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035539; x=1786640339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l4wawGSh1ayASvpYyyNUW0xG9j87AeVkrycNAPRNAqw=;
        b=K9b3+RXwnrPJTEcjrJcIhGS7K3/RK0+tyBpfcDbdp2q5EJxpkrdEqdBAbodAY6/kfV
         RNDNrw902qjR3iHi/L3gg07C1L+sTHgPVaPq1Cq94irkV9TR7N9bYopjpH8dmaNNNqZ3
         ryCI8zsMNCQi09vC+HGAnje/TXqfJFHqp6yqGhkU8qtKu6/I5aGsh/Jgh1HJB8vcyRWS
         F3TeS9y5Tk0yrfY+ncxAa8dYvI5FEAcAzE5zSnd1dMGoHtyfyC9rsLt1HuNiJ2K7ahHa
         3IRAoGSGjAZ6fiDAxXxJyW7+eQJf+kuXmFdOBY7H/fpQTT2uQ+hbfz43K3W/GjTrNyeI
         eT7g==
X-Forwarded-Encrypted: i=1; AHgh+RpBmRAr8eTKs0W0A0TGXvNNT3atrB2QYHsRiLnV+4CsHa0cmSI++DVNuXTyohqcMLnM+0IOE1oNEIl0Jw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+Q1/7offJ6QzDDUoPDC8x4tEv/0fY8BRjb3Q9mrLpyv3SVwEY
	6mNxNbMuasCVcdnHk/aYeo8Jqeg3tSoW7HS3By4EVxtxySVfBz35g/t9
X-Gm-Gg: AR+sD13TNlZJiAEH+MoX7dWO2qTACQSQ42gPe68STNqkMYXpIxjWTLvzTerJrlMoWed
	kR9LKa87q/Qrg8STR1X6MnE++8UD7B2nSfPQKOpQRzkvpgVcNhMCzNXnHzeix9KdCFMW/kFREac
	H0opdcSipMbOfxVGHwf3BPHoURegy5zEYyhD3URfs6ptkJ20fncOKQDMD3MXy2i+3rE2E7lbX4B
	1C5naS+xUBaoOe4KTX9AcymwZh3mC2v0QNZpNAXW2N6HlPOQ1CAXS8syRNHqEr0mARAbCW6A0EU
	GeWWt1A79fe9pK9MWnWWeoVDNoa4TlK9ziOfcJ/wn0o9t23DHx03RmDN5KnsBMDs0gis+P8dNTW
	S0dgRUPy0GLki/v0Dm/wxPYO8077G4NNCd5Xbdu/8mKrNbT/CdKHMcoiBzHDKoQcz6Qpl0w8N2h
	8ktQWhXeTV/hjXwuvZKX4M0bRc8hokTRaLllpkPF8Zqh73UfCUANtR6KuMw6LL5AOUOBdJnAWiO
	WOmAJY=
X-Received: by 2002:a05:6123:2c7:b0:5bd:faa8:74e1 with SMTP id 71dfb90a1353d-5c3d92900f0mr2224979e0c.13.1786035539083;
        Thu, 06 Aug 2026 09:58:59 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:58:58 -0700 (PDT)
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
	Zhang Yi <yi.zhang@huaweicloud.com>,
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
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 01/21] buffer_head: Remove b_page
Date: Thu,  6 Aug 2026 12:58:24 -0400
Message-ID: <e9d168901578902bffe78ac8b5dfaf1210ee7fb3.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
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
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
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

