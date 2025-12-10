Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6702823B612
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 01:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331857; cv=none; b=vD9jrepZJJIB6xO+zrU+aAVsPsXDrlrHF03HWiv79JBfAPezpigmvG0rotSWWZYqF4r646KNLt7LNKuO6qVLU/hgTyGaoOXIHyhB5dTePDtJLTdnBnW8UtaL2kJzksfZEGbmvdi/FAJVX6WjLNK5jGfV4qyifVwSpkL8tIG7Dto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331857; c=relaxed/simple;
	bh=rIjBSk8W9vHLkEVzp7rPU63DurUszuJ0brbQFnUC4kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+07DdKlbMzPULwdus7Im+dKpmp78vAiRuEUiYZaKtBZpjDdszgQtHaYJHESVYyEwWLvvBdg4G7K7B2Vz/tvRUMwnYYEH2UNeebhACTY1+iDMIZKTAq8t4+wg4KBMnvoYh0np9SrBlG48HXavltdbuSQh7f5T4cQRA/J8N5a/s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qi9dWiNF; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qi9dWiNF"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47928022b93so13950295e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Dec 2025 17:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765331854; x=1765936654; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqN1NKbSsmoO7F1QrFMDpSGOC06IfLpd/c1+vjKbvBI=;
        b=Qi9dWiNFE+rhiSrM8QWohTmOxgYgk7p7oUJWI9gQqETPDLQ94HiMNUm0KoHly0HEQg
         nnpmEi0s0Af3pR1rXqOSMNr927GbH0ygBmhTqrdivet7L7HGKv2M8ZiXRY9R+WbiLfek
         EAGCOlmpHEcvZSyLUfWtwG1lKZ/uEuGiDZXUOJvd6gj+KjJMpcsUflExMZuHACm+HiRf
         Xz3W0aCeG9z/9rGhU/RB9nVNHBxhoVqfKwOSw7p1DzHjFE18zAqJ7yJdunopFrTLrnXn
         swfc6Qv1dyy+CQcrtX6qLb+zk+MgvsrDa1hKVz600Bo4FP5cnxmNg0sOANPXB7bXwwhD
         9Bbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331854; x=1765936654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vqN1NKbSsmoO7F1QrFMDpSGOC06IfLpd/c1+vjKbvBI=;
        b=Og6YaO8vsjE2fosZwIUF7N4W3rK2JlwEeoYrGMtgUEWkk3fw/kvcU886HEqCEx8207
         TpOT/oEv/qQ31WyWz7Y2IDiJv81zJ400QulsNy0yTKpazuK6nLRtRpYHwc0wUwyF5I+r
         X7MVV3pQS17uXGIYeSuKLeBpVSQgFQiBedq5lVUgtjFqn1N6attzGLwsFeurZ7HIxcOG
         p6FjX4/AHD0WY4o/gyHY9A70yJlQ+bySnGxSVQksiHSZ6Svy/w26OzeEmnllioOWx81w
         3TPhZZNwGriIDqKGuMYRRGk8CUh2Ox2mMAJFIq70GFa3ez9yPKJdzu/0oZXBjbkSk32z
         5EQQ==
X-Forwarded-Encrypted: i=1; AJvYcCViFQ1mDe13u8f/MkN6+mkr+jO5AptSbOhOhwvke3nutINFxrG75fvFj1fWCZMg3JAxCfNyYpliDsGQSg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxSE3R3vvV8u4Yxc8DG+GmNboFMtvfXdL++tePwaBkWsbbCpOEF
	K9ToZBq/X4P1M+YXXLBgBpxWRbVSvMS2LGx08j67Mj7cNAtr5CEJs085cuGdbYaXfsM=
X-Gm-Gg: ASbGncuhWnIDCOfwtnNnF6WQBrEwy1iyLwciDuxgFTLRBPngyi32ETb+P2s7LXc2S0J
	Vl4rNtzoMqPHAuh0AyvyQAufbwJHkXHmEMTiJ8hc58D/sK8NyTiUHSlf39I2xf5xo6np6tr3Duo
	guzL2C5oFKmezNxT5GF6UAE8kGR56RrMed6OfH1k47BnDJ7J4srdydz6wmKUdutNw/buRGEaS4s
	aAwxHaNbZKj7JrEHr7qdIEqnIRcVDB0be5nJo1pozmNAc2Zmo2uBUmkz/HuDFnFbNasMrYik0zG
	yq7gyaHQv83E7YKdEb/8vB8Nqzksv6WWvZtMGPuvBIWFjSzqelDVARzK7ha9fbUz6U81qyNmstq
	vULmX5PTis9MD6Di96LiXNeRdqxMIlRi8aOMasReJCo+kWgWwbw8ehNQsSwrIGuyT2p2IcclD7j
	WFUka3ZMGQdQcXNTGZHAgdh4lm
X-Google-Smtp-Source: AGHT+IEVfsY1W3wTrb83B3sGRGtfJ0RinkE70SwJcnOVRx5VTrUkcJQHazTErgFY0aEpk2xNg8265A==
X-Received: by 2002:a05:600c:45d5:b0:477:7b16:5f97 with SMTP id 5b1f17b1804b1-47a8360681dmr4671435e9.0.1765331853748;
        Tue, 09 Dec 2025 17:57:33 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae49ca1esm164755985ad.2.2025.12.09.17.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:57:33 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/1] ocfs2: fix reflink preserve cleanup issue
Date: Wed, 10 Dec 2025 09:57:24 +0800
Message-ID: <20251210015725.8409-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251210015725.8409-1-heming.zhao@suse.com>
References: <20251210015725.8409-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by error")
doesn't handle all cases and the cleanup job for preserved xattr
entries still has bug:
- the 'last' pointer should be shifted by one unit after cleanup
  an array entry.
- current code logic doesn't cleanup the first entry when xh_count is 1.

Note, commit c06c303832ec is also a bug fix for 0fe9b66c65f3.

Fixes: 0fe9b66c65f3 ("ocfs2: Add preserve to reflink.")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/xattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dc1761e84814..31d023f9e2ed 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6364,6 +6364,10 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
 					(void *)last - (void *)xe);
 				memset(last, 0,
 				       sizeof(struct ocfs2_xattr_entry));
+				last = &new_xh->xh_entries[le16_to_cpu(new_xh->xh_count)] - 1;
+			} else {
+				memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
+				last = NULL;
 			}
 
 			/*
-- 
2.43.0

