Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453BD3B811F
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 03:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779766853; cv=none; b=fMME9muDXIMt/YuhXznOVcGQRmOg3gZKGuYk0xjausM/3uz8fAozEH/hX2SNqde4eU15aKoxgMAlvaWiAEjo1Qrz4kLyfn5lTRd87o8sJBoKa3l7LgZn2Rq3nNyDhYT6Ax3OFQVuCCwPwtIll3Vi2XRu/0owOXVs/dY2u2Dis98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779766853; c=relaxed/simple;
	bh=xXjxMYnrHUGmLTmfnARK/LvI8u8E8LhHm0o9spT1jME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=grMAeFVEXS8eQTTWg5n/aCdSScV9sQkLNSdrornBuXgdtApG+z/GnfHA/DSO9j9H0+Ger8vpVPSvMAueoN6naJOAbmu10hjEll68P8NTzC8bVHc3Yf07X5OFsx3m094TjnqGtQUggQknSoXjdSUJBPNdIQf3DmUyc56tj9UFuYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h9rN0ZUy; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h9rN0ZUy"
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-841882f8f4bso804020b3a.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 20:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779766851; x=1780371651; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDmkt1tx0tgZlC0QZhaEVh8U5isSSLdrpkDCM16lRfU=;
        b=h9rN0ZUynLSTRdacCzD1rBXyZMPuoPxyl8z9UcUIApJB/mue4CdqVm+v7JmZ7bO+pg
         QXyDX+R6rhSmg7enPQ43M2v2PvzmJNDkKlYW7LK67tLQ9AvJgk1mc7LaMYqETHODupDS
         boZZlDDbMYlmA7NBKz9k32EEbRvp9DkGsUO1l6iVhw/txUrtWfp4/HRyHUpzCMWXn35N
         QjkMqpB8rKaYUhkxLw8UGxJQoZPhX8QJ8RZx9gKO0lqLPR3Mqqbd0To+yFnNai2o/OGR
         7H8ZOxz9yfz5WX2zACkfvc/1xpx+xzulZVvP5Jo7IkFEj89YLjduixzkl80IMSUDgKKT
         Tyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779766851; x=1780371651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uDmkt1tx0tgZlC0QZhaEVh8U5isSSLdrpkDCM16lRfU=;
        b=tPrv1vjaAr6Lr/4uq6ZKbGCfJI8pW8H+kZ+1G+xE+/s4J/CQkHQMaQspschwdvYYE/
         uK1S6ZBvbcPF7xHWwKQ9Us60TNidl37XYVrQxkRkol8mUHJyiaTSr0C/ng3ggY6RXrpP
         sY5OstFNyu6AxnbpoLdLcAWbrkebZjKKWUFJwbncWsdnSbgTVndle/HwHn6y/Udl2rdI
         KQG/HjOyj0cvjUa1KID8H8neD57NlqeduoytBtuAszioJYjbbUbCWeFMWtt7Sb1iDNrl
         nwCr0CzgAKveqYbDc9NoWqF+W92IGngNjFVd9is5m/eXvD4cg5IwZEH/C7zG1I027V4a
         8oGQ==
X-Gm-Message-State: AOJu0YwAP18pPjDAvvlA9nVEv8WMeRoUipx7h7r3/6aQunllCfWFc0dK
	vHcV5tjvRK3jrHUjNc5BzVltEMq5AW+w3BLQBu3N92iBy1PxbnjrN2eo
X-Gm-Gg: Acq92OGxrLqaHbdS2flCT53IEBNqGEgUlYFpeeNYkm9Ps4YT3PjsH31QPnK5vRIFDVA
	gxaPqUBwTlCXq6+sIAwoxHxPSS2EFx9xDlCQZJ+TfUdbKJwqnfFOkpQH6lsFXCez21uJ8rmm5KE
	Jj2pDz5LCh3eLem26hJrxmPGPQ2xzlkBfwdclnCDxEmuDlEVHqdFQxYYnOZzLstVPeWm0SbyIQS
	IWWx6U+UaCngUMnRj6TakRFC7wNnUe+7bd6jFD8M9dDnVlRAIzeiJFTkPOzo+RnJBPvLRCvdYND
	u5GBOWYqdtjr3ZWxeTwq3CtIcrO5Es3he2d4S5gbdl7aF7/nE9RNSTFNAwPVw9Yq3dNrLWj8Eod
	Tnp0/EZE4gUyQBEQqyRY85ck8jPf9xYTdZMUCJ/rsnz4MUfyc/UYx6jL/KlgX0Skf2mNE22c+/7
	DiHsPgRWtNsO97ifnUbrbNUa8Fzd/J/ok=
X-Received: by 2002:aa7:8893:0:b0:837:80a:5abe with SMTP id d2e1a72fcca58-8415f69ead0mr14926092b3a.37.1779766851407;
        Mon, 25 May 2026 20:40:51 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ff3e00sm12368478b3a.54.2026.05.25.20.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 20:40:51 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v2 1/2] ocfs2: validate inline xattr metadata in ocfs2_xattr_ibody_get
Date: Tue, 26 May 2026 11:40:39 +0800
Message-Id: <20260526034040.3602377-2-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526034040.3602377-1-rollkingzzc@gmail.com>
References: <20260526034040.3602377-1-rollkingzzc@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_xattr_ibody_get() derives xs->header from
di->i_xattr_inline_size and then immediately hands that header to
ocfs2_xattr_find_entry(). If a corrupted inode advertises a zero,
too-small, or too-large inline xattr size, the get path can place the
header at the end of the inode block or outside it before reading
xh_count and walking entries.

Reuse the inline xattr size and xh_count validation that the list path
already relies on before parsing the in-inode header on the get path.
Reject corrupted inline metadata with -EFSCORRUPTED instead of walking
past the inline area.

A crafted image can otherwise trigger:
BUG: KASAN: use-after-free in ocfs2_xattr_find_entry+0x5a/0x170

Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
 fs/ocfs2/xattr.c | 51 ++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 86cfd4c2adf9..eabfaa02d8b8 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -967,24 +967,17 @@ int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 	return 0;
 }
 
-static int ocfs2_xattr_ibody_list(struct inode *inode,
-				  struct ocfs2_dinode *di,
-				  char *buffer,
-				  size_t buffer_size)
+static int ocfs2_xattr_check_inline_xh(struct inode *inode,
+				       struct ocfs2_dinode *di,
+				       struct ocfs2_xattr_header **header)
 {
-	struct ocfs2_xattr_header *header = NULL;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	int ret = 0;
-	u16 xattr_count;
+	struct ocfs2_xattr_header *xh;
 	size_t max_entries;
 	u16 inline_size;
-
-	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
-		return ret;
+	u16 xattr_count;
 
 	inline_size = le16_to_cpu(di->i_xattr_inline_size);
 
-	/* Validate inline size is reasonable */
 	if (inline_size > inode->i_sb->s_blocksize ||
 	    inline_size < sizeof(struct ocfs2_xattr_header)) {
 		ocfs2_error(inode->i_sb,
@@ -994,12 +987,11 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
 		return -EFSCORRUPTED;
 	}
 
-	header = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize - inline_size);
-
-	xattr_count = le16_to_cpu(header->xh_count);
+	xh = (struct ocfs2_xattr_header *)
+		((void *)di + inode->i_sb->s_blocksize - inline_size);
+	xattr_count = le16_to_cpu(xh->xh_count);
 	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
-		       sizeof(struct ocfs2_xattr_entry);
+		      sizeof(struct ocfs2_xattr_entry);
 
 	if (xattr_count > max_entries) {
 		ocfs2_error(inode->i_sb,
@@ -1009,6 +1001,26 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
 		return -EFSCORRUPTED;
 	}
 
+	*header = xh;
+	return 0;
+}
+
+static int ocfs2_xattr_ibody_list(struct inode *inode,
+				  struct ocfs2_dinode *di,
+				  char *buffer,
+				  size_t buffer_size)
+{
+	struct ocfs2_xattr_header *header = NULL;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	int ret = 0;
+
+	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
+		return ret;
+
+	ret = ocfs2_xattr_check_inline_xh(inode, di, &header);
+	if (ret)
+		return ret;
+
 	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
 
 	return ret;
@@ -1200,8 +1212,9 @@ static int ocfs2_xattr_ibody_get(struct inode *inode,
 		return -ENODATA;
 
 	xs->end = (void *)di + inode->i_sb->s_blocksize;
-	xs->header = (struct ocfs2_xattr_header *)
-			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
+	ret = ocfs2_xattr_check_inline_xh(inode, di, &xs->header);
+	if (ret)
+		return ret;
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
-- 
2.43.0

