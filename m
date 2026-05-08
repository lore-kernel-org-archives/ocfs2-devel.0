Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FE831BCAE
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 May 2026 09:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230805; cv=none; b=GCeS9vfcmiW06xf7+/WBb4vVV1YFrUv0EApedirw3D6ZUNIajBESkbUnBqeceDNmc/zJ6I5kmUcNnUXGUYA/RNpVHyDCwtk7c9GmF+m/q8StCN6PG3SIx8r/1udVAJZmQCvPetBtXjiJ3dd3pAXEwmBJAute2hM4DUhSdwpEeF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230805; c=relaxed/simple;
	bh=oQ8dke2rWFaSskvr2FsQetdBTXzOiYOJMNp/wJLjeTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4Rn6MfazmyOkbL9Z2wUvWKgWbKTRCkjHV89wkeVjJWsJJHtDChFdY/DhxNqk3sItCALiO08WjPMsJLVjurA84lqdHg9r68kACn40oX6wn6CFA+eMz0fuGNjuIT+5fW+8Rx8ri/AQ2EcByJMV5S99xLsPHY/OZJzTnWrRvcz9Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TbrnpfIt; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TbrnpfIt"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ba21d32776so12654275ad.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 08 May 2026 02:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778230804; x=1778835604; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93r39cWo69bIErRsaiSDOdIu+drnExlfendQTTfQlzc=;
        b=TbrnpfItJVfYgVqxCZrS5Vz9/eaSDJdqOsfnslqpFaNSeN+CIg386hHmynK8Y3h0CJ
         HZz+ZN1vLkAV2rKdAsa0xjF/708nJ2rv7WvLdccV40guW71rhngJp2iP8WrQnMf5dCK7
         z/ko357u5z0RV1cbO/eSBq0Z0hv0EZSMwCBt1jPQalrGVT9JXyPMYeJcTzHVqzMl+7Uq
         a6ySZ7Ucb864rfS6F1FZs62dZE4wucJTykjFu/1GNsy93jJcDDuPacx8G+j3mzeqSv0R
         /2pc+NuJJg+i7v68jrwouyqwU8C6Y6wJ3tL8J1KmByJOz+Hlchcp+qA03GMUfJ+pTuds
         aksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778230804; x=1778835604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=93r39cWo69bIErRsaiSDOdIu+drnExlfendQTTfQlzc=;
        b=LgxCGF0G4Rgcxr8O8uk3KRonDikSBkEwk6Nr3EValZL7lIvkgYqY3h21758IkrTUQ1
         aA+RKaL5Al2bMC48GeciPs8g6ULNe/xTE5/c5VKnz7i8vWUgkZp8ooc0u7A6MzIwq7eQ
         GlcQrhpKLDgogyf9mFS2WiRQMrSBgRQA1dULcXOYNUR3X+zkU9mIoS5bJkhQgU/xetfi
         v+Ui3F1WriLx60PjNpIG6yE89tFgKbMFx2zOBlMH6/dm7/nuNxW3Rw1GZtJ9jtGi044Q
         C4uLBoGCh8Ff5sXEpOTrwVZFCXtJKIAit6NH9YZZ0HEwlkJA6GjNpjjqHNteh7o9dSRD
         x/kw==
X-Gm-Message-State: AOJu0YxM8dMf3chp9IVuTbAjgl9vTsp7kzgwYxL6cIdi0E3syA0RGttA
	tZ1QxK9uAZU0u0Ewvz3JU2jGQDmT4zjPlbLUsZmeKI8n4fx30ef4UiY0
X-Gm-Gg: Acq92OHu9TbseSpcg5RAOdLVRrynfMJhhWMYw70FpxnoWAdirRA4o2jKdCKu3wk/Dn8
	ALunmqvSngmkiLjuKTz4XFTYv0oZz2ys/Ryi6HcHn51Bf2xxjAEUMN4BpsiwX3HpppSUN6UMfDb
	sbM4YDssa5rBj618zKny8v+PPX3RWF3QYiQmX8Ed3wrL08fOJy+VlEro/XxpW8phCyFkLXl+cot
	RDbEGQeXWmASzUZnUzjBWj9tjUZmfDgzpw1szgxwZv1+Blfgsl/u3BlPICK/BPLGxL+uKQUlR2d
	FjvEk6aprIZw1ZJq9loqDOVi8d6GU/aHFd+OCAm7TVp6Io6OwuXA37kE1l2gHUxfGzbo66yuKhQ
	iEqsW+Kbs/6j4x6MrHmFTVpn5TT/pPnmYdO2zve1qYwklhhAwHSXDs4E8JHOjl1BQPFuSC6YwnV
	wB7jWVt9PMpIpXsBqwrQNS0deHDyPqi7u68Ebkbo4zsjEBv/7TKzBvWqsEuvQ9Uq0okgiBMZDsv
	dDpjHBT7wRN+PsvOaSOJgzj5A==
X-Received: by 2002:a17:903:228c:b0:2b2:4194:9521 with SMTP id d9443c01a7336-2ba79287606mr123764565ad.25.1778230803336;
        Fri, 08 May 2026 02:00:03 -0700 (PDT)
Received: from localhost.localdomain ([111.202.175.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm15526795ad.5.2026.05.08.01.59.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 08 May 2026 02:00:02 -0700 (PDT)
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
Subject: [PATCH 4/5] ocfs2: validate inline xattr header before inline refcount attach
Date: Fri,  8 May 2026 16:59:13 +0800
Message-ID: <20260508085914.61647-5-gality369@gmail.com>
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
A corrupt inline xattr header can make ocfs2_xattr_inline_attach_refcount()
feed an unchecked header into the refcount-attachment walk for inline
xattr values.

[CAUSE]
The inline refcount-attach path still derived the header directly from
di->i_xattr_inline_size and then passed it to code that iterates xh_count
and xattr entries.

[FIX]
Use the shared ibody header helper before attaching refcounts to inline
xattr values so corrupt header geometry is rejected with -EFSCORRUPTED
instead of being traversed.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/xattr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index bbb25a01b097..4877406a83ce 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6016,14 +6016,17 @@ static int ocfs2_xattr_inline_attach_refcount(struct inode *inode,
 				struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
-	struct ocfs2_xattr_header *header = (struct ocfs2_xattr_header *)
-				(fe_bh->b_data + inode->i_sb->s_blocksize -
-				le16_to_cpu(di->i_xattr_inline_size));
+	struct ocfs2_xattr_header *header;
+	int ret;
 	struct ocfs2_xattr_value_buf vb = {
 		.vb_bh = fe_bh,
 		.vb_access = ocfs2_journal_access_di,
 	};
 
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
+	if (ret)
+		return ret;
+
 	return ocfs2_xattr_attach_refcount_normal(inode, &vb, header,
 						  ref_ci, ref_root_bh, dealloc);
 }
-- 
2.43.0

