Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19073E495
	for <ocfs2-devel@lists.linux.dev>; Wed, 11 Oct 2023 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IePa1QI6"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-577e62e2adfso4063965a12.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 11 Oct 2023 09:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697041950; x=1697646750; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6TTvG9RsDz513s2F23HaEBE2HWxh0jvH/4VBJj8ZPLk=;
        b=IePa1QI6uViAfAEpA952Z4r/CovdfKOyGoUWrMkVubA/C+bV+tidEpVNoRvAYWr7pm
         8X4uu930DcbSCqcqN5X0JKgEgfjm0F+8GafJRJu+O2mQ7NrQyvfxO1j1QFSLNrgqRW9X
         9czN1Dkuiq+c/ObbVRwczT2PO+JG7fVeESX1fitimBxjJYNeAjdZOBvewNiFcPset32O
         Fl83eD3Xl89OZpgjM0mmT2btgGNyWIwbc7czRkRPQtDH1/o8MfhIBJ3m5Rr50oC95/NU
         5TK/kie2B3Q7KmDOWDgCXbWoBtua93E9S2CZBg5bfvMpJN74aASe3aw2ITfT9ZSq/JbU
         soEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697041950; x=1697646750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6TTvG9RsDz513s2F23HaEBE2HWxh0jvH/4VBJj8ZPLk=;
        b=YxOINW08GyNUB6RSKiLZIWufzrSmDFBlocUGsiKyMf4bE1ESI0oggi9JptGB/m5F8i
         Pws0+yO8MUlobF+ELCQwk2DVwcvMkGKc+EUijxL0KEXxhFyFdDQ7w65KiLx1jkJ0Oeb1
         Rlz+7t55bILiMheRuhsB/igrH8ZQm7TWsObTqR7DzWvRCDzV8lFND7dm4QTRtjH5sxY5
         T2hC7xrxEdUt4U6k1txl7tKgOiiYiyLrIfbv1AEBHm9Il+MRk1bio+OuH6v4LwaIA5Cg
         DAFXmqqb50rLQJ5WGrI+V/75q+Agar+EbE4mp7D/9xT8ZyAf2A3A+Xraf0MpLk0hlzGt
         6BpA==
X-Gm-Message-State: AOJu0YwNRy64rNjTZv/UNxzcVklCidLYelT8eCLK4RuKWmCOvCtLMGc3
	Mxh3osU3e8K8GMwdGYTqczQ=
X-Google-Smtp-Source: AGHT+IE6gWwlpkkkq0U3s9MJSP7t8t3BKkfZpXp1GtQIDHyRgnCdCpGHP8sMs+lo9xh+IAW6Ajldhw==
X-Received: by 2002:a17:90b:3143:b0:268:b682:23da with SMTP id ip3-20020a17090b314300b00268b68223damr18583581pjb.34.1697041949845;
        Wed, 11 Oct 2023 09:32:29 -0700 (PDT)
Received: from vm.. (ip141.ip-148-113-3.net. [148.113.3.141])
        by smtp.gmail.com with ESMTPSA id z9-20020a17090acb0900b00274262bcf8dsm117869pjt.41.2023.10.11.09.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 09:32:29 -0700 (PDT)
From: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
To: mark@fasheh.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yuanheng Zhang <yuanhengzhang1214@gmail.com>
Subject: [PATCH] ocfs2: fix a typo in a comment
Date: Thu, 12 Oct 2023 00:32:16 +0800
Message-Id: <20231011163216.29446-1-yuanhengzhang1214@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix spelling typo in comment.

Signed-off-by: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
---
 fs/ocfs2/buffer_head_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 196638a22b48..6cb919f60011 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -158,7 +158,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 			if (new_bh && bh) {
 				/* If middle bh fails, let previous bh
 				 * finish its read and then put it to
-				 * aovoid bh leak
+				 * avoid bh leak
 				 */
 				if (!buffer_jbd(bh))
 					wait_on_buffer(bh);
-- 
2.34.1

