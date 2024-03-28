Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F707EEE2
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 12:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711630339; cv=none; b=rvMXEW3n3HmDQydytgopbcPuAwoBNjepMHwWjgvEOTFZZEr+bksU6yXOXu1go74r4Yj9lh1gMRTUx7bCdNnlGcsQOhONHzeffwro9aPkQaVuxpeHRiHZvNbU20osg/5NeIl0oOp4VmDyAAewMycOSw7I9XRIA09btvgjb9DXuEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711630339; c=relaxed/simple;
	bh=c2OcaMlBTf0OpwNL6uBEN13ipPiBvZxZhbmMHP7c7OQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FI122Zk2/Y+623H+QXuNsrYAUTudgCEpsYSQgy7ZDb0a7AD4wz3QmD/LS9/lg6CRLQaMi+c1WZPZgqVLj/0kZLssciCntuIzqGQJikWZLPoupkDxBLgMRw0xVN8TbEykNW9isMeTNabtXwifX1bxvffoKHTR4iIwl4YoyvCBfJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xuo2ASdK; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xuo2ASdK"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-33ed6078884so1099604f8f.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 05:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711630336; x=1712235136; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyQzkJYm6B+aiFDUTwEwfL8v6xKkMoU1AHOq5tAxH4k=;
        b=Xuo2ASdK5ypI0qBh3r/4zU9x6U99QLtUE57nz2sDQtBftiefrIUi0N9Isphm1dIuIV
         LRvqv537SagAYQl2z0tmcysxyFRWtbdqzcqqGhnOyEmSzFsQGJTG7TsAg9oN49EySxay
         jZ4d5bP1CJC0A/yItWczhb7t+x5nOaPk8aomsSo+WJPhEaqqrah5JetRDwnBXpRwTgp4
         B1UQzbcbpt291kLLBqTSt4eZP2eiUE+9sFxWO2GgPhkaZzYxdk8LPqQgtmK2wnQZUY3+
         Q2PkWqhdqv1mUH4QeLo7dI1ckBglmf8kmpEc+eroFZl/SQKvrXwHWN88DWnJ+PEKghp0
         hHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711630336; x=1712235136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OyQzkJYm6B+aiFDUTwEwfL8v6xKkMoU1AHOq5tAxH4k=;
        b=Kfi1T96iOk9j5Yrf6v9DTxOrjyWmYEv2BNovnepGtHoxMBBbZIjEa1jhaswhT+gG2H
         WHCncW/CTTI97kP0h7Uufo2W32ixTcbIXOVpq3V8R4v5CWqaqmsMcBHP7+LzK906sMSU
         t6GaR1OBCCB2vzRrhU+C76Hl4zUPgtX5Q3mCtae6/ohytBtnQXV1evFs8b1YlUU5TPIh
         c1fUzGOSmY6t3JYI6FFtss9NSQ5vHjodbwtBHWO840xXId4VxouWQJd14DafIohmSADr
         1WbumhPfkQQZ1LzliyPVbCAL2DuGuYZacPiIudvegZY6Vb3W9Ob0LZo/GwwfCKs63PK/
         ZNZw==
X-Forwarded-Encrypted: i=1; AJvYcCVAtn8IuemhGyTby6bgm+neEn40omoBDGpWUwQAdEv6q8lpYf67G9VtHJHW1Fji13scGDi0Bxif8t+PaIbaM1DZUXIoIxNgzKBJW0I=
X-Gm-Message-State: AOJu0YxgQFbB1+CtV2EyUBK6KGQOP3XXbvMnGt1Zj0o4HCCF7PHwjjbP
	nMypsAPPa5wTeJvJS50Sc1Co6NPm0Wc5pHS2j0p93lCEnZBWCx5PbhW0DUe3JjU=
X-Google-Smtp-Source: AGHT+IEty9VmNVcMJSzanveCr0ncnFa6Cb/bK/F4wJBOrKVCKarHhj8N5hXtxY1pzEViTKidHgL4HA==
X-Received: by 2002:a5d:6d4c:0:b0:33e:aead:af07 with SMTP id k12-20020a5d6d4c000000b0033eaeadaf07mr2032440wri.27.1711630336015;
        Thu, 28 Mar 2024 05:52:16 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id mo4-20020a1709030a8400b001dd8d298693sm1485010plb.23.2024.03.28.05.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 05:52:15 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v6 3/4] ocfs2: speed up chain-list searching
Date: Thu, 28 Mar 2024 20:52:02 +0800
Message-Id: <20240328125203.20892-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240328125203.20892-1-heming.zhao@suse.com>
References: <20240328125203.20892-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add short-circuit code to speed up searching

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
v5: 
- split 'sparse warnings' fix to a separate patch
- amend the commit log according to patch change

v4: first version
---
 fs/ocfs2/suballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index fc80cb3dbcd1..823e2ec38b2d 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2008,7 +2008,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
 		if (i == victim)
 			continue;
-		if (!cl->cl_recs[i].c_free)
+		if (le32_to_cpu(cl->cl_recs[i].c_free) < bits_wanted)
 			continue;
 
 		ac->ac_chain = i;
-- 
2.35.3

