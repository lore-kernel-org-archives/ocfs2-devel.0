Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792467839;
	b=3h/Tg5VgJ3qyw5IrxMQVIyOCZWWjaaLxZJU74b0NWccOv1DGGwaZHSCsKhRQ4E0167Ty
	 8sHMoccML8Sfy0RbjH4ikxfSzIPwvr3Krv5vn+nsRvjeF0Q64ZIYoL2icMs0a2e3ikMTC
	 H4lQwINw+prQ7UHi6wVummsGLftpo94cFiJKYdSQgAU0YxXNRag3+1Z0T6noGBwS1rbnp
	 8qWU1h8Z2ChgbfNEwJh/6e2ulYD8WbeE2NmHMK//xSC665vYgEv5XlcHZfTVOi55LcfGs
	 7sOo5VhM+Y0IrbXJJMNmRWLT87tVQ0aTNKKtwfK1s9yyu3/HlPrfFQohIbWnaUNtKag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792467839;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6AmciestcwpfVwikDIiE2zDRFZ72F9LqkNUf023WPXQ=;
	b=z0pGqqfoi0fv1h8mL6pU/8jDtNCHzzz5CsRjv8Kx1S0Qbw/hoDD5pBK1PWDuc03EiBYs
	 u6faXH+eepYmxTuD4MyWqGW5S5FDpZiEXUiXvwABMpEP9ywN9CUd+f/Iljahn9Y+GgfUI
	 3DXrmE3qD9HMsTaaCjuyD4UsbH3ZMpflulKgM8H1ecKMwu0WfT7+AVlyTa8HCpUuDM6aF
	 aQrEB++SllJzetRG+g52ATsuXFK1DGsjcNWYK94MxW+qLp0iTAgCc1zIjrW6cw3F6S3z0
	 BsOnl4dZx0AxcgAlDBdIfdg4AvFoNCKSQiR8RtLE9D2jG2ftBdlwCZDUe7ijxrDzRxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="DNj8/ms7";
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F2B606A31A
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 03:43:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77F2B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DNj8/ms7
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2db80fcdf8bso16132305ad.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 20:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792467839; x=1793072639; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6AmciestcwpfVwikDIiE2zDRFZ72F9LqkNUf023WPXQ=;
        b=DNj8/ms7o0r4FW4KfwbXPtPy0St0f8nkV2VSDO6mWdkMYDuonohSxRNicIIizph/8f
         XlChBoibume+AmC72hiQtbu4T7JdLQE2WysFj3nMaJeaS1TJOxnxlxjt4+lEXVuytf/N
         At4IkaVVIYPJ8vhQ8gXEdqD2kTNr8WT62CEkmKb3bHnVmwF2poOgmq884QaKoaBnnhgH
         QQSCa2NOi1rJrkzcRox96d9JwQ8+gDNfzq7yjnp25MxRb8FJxeshmJciXCTDPxBg0PwW
         7XSWYiorJncyxvJF9RUXupcaZxrdyGpnjxiijH/qKLwDifLZwoeZgcrj8heHlljnF0v3
         11lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792467839; x=1793072639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6AmciestcwpfVwikDIiE2zDRFZ72F9LqkNUf023WPXQ=;
        b=JcA9YHWMTh0kwlIfTRqKbExefDUMwLWkI+1Ww+LVG4hCW0gOsb6VuoFEt0XlrOXpcT
         F+wL69JBrpT3+GPZr+3glIIkSRQ97tlwhsj2GmH4vYhCABkkoFBEcZ0lGYUlKJNZErM/
         sqmUOHD4FalwxLmBn10PgJqPyjeNUcN4T+kDLIJB7BNexU7byS43DbfgHRQMeM+AlCe2
         4kc+3GiXjI96jnigDeBrtMdH2n1YodkI96q8ih6WqB9whupysYJYszuLQAn63klHdeyh
         bVjr7HHFlceL6uZHiWX0Ykv516rtNDiT5gxuSOfPhlkdKDB/oOd676RICsQFr+EXfoeG
         VNIw==
X-Forwarded-Encrypted: i=1; AKwUvBxCCMQ3nwhZCVEuvSRmhATRup9Jf6XMKGfKNTMkvVs18qT5NY0U1rIvxVKTmPkFSgtGgmyFcwURpBI2Bw==@lists.linux.dev
X-Gm-Message-State: AFq9FYJk58PYeaBQjYuTfas8YSZlgA8sOLyDldl3lXvCVoty6kbJ1k4w
	/hWSSU2FFx4hW+CtJZDf2F9arX+il0CZQhNBcS4h8EQd29iX4gZDIaU7
X-Gm-Gg: AYBFou3qQkPzU/9nGeo2XHbSVSUZPHlv+wRiruc0a1o9Z53XWwAD8/sfqJ8gpVGcg1m
	ycSoEuR6zBjFKrY9QZI5aUxXwp6+Kd/dCA/K29o2gk95e4PaczP4ES1G6RYAb8Obycm42/N1euQ
	zTxnuSO0OfubiXslY4M02VKwZO59Q0m9IqGYHN/WVZtlmGuxoMcuJLHm2/z9XoBJB77yB6hLSuo
	gmNhZ7TW0WfCcIQlyvpEG6lIrydG/y8rNOeHUfvAmJw1S3Si5Qjl/oqcBrGC7zwfLu6VY8FQv2S
	/s04ciNtRawYKd/vECHhutHquJ7DDMw5+dRWGCFKPtUzODjEJ4kNf/vv79n9xMi3gG/qrakkJFH
	lnawgfTHXiIrKaahtE8K70E883QdNLGldckCeWWGU83uLay+depq7ROzN6Ek5azEFaebiHiVL0j
	fOasEjZCidTeQPqPpYFlUq+W15hj5NDlyEPShxAO34hWtq5FzQpJWZR1fC8kPqo3S36A==
X-Received: by 2002:a17:902:e844:b0:2e9:9a19:c5b with SMTP id d9443c01a7336-2e9a6e558admr80578225ad.47.1792467838712;
        Mon, 19 Oct 2026 20:43:58 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea14caa857sm8143885ad.12.2026.10.19.20.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 20:43:58 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v3 0/2] ocfs2: stabilize dentry names in file-operation trace events
Date: Tue, 20 Oct 2026 11:43:50 +0800
Message-Id: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-0@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All six users of ocfs2__file_ops pass a dentry name to its shared
__string field. A file reference keeps the dentry alive while rename
can still change the name being recorded.

Use name snapshots at all six call sites, as Joseph requested. The
first patch handles the five callers that take no inode spinlock
around their trace call. The second handles file release separately
to preserve its locked open-count sample while taking and releasing
the snapshot outside that critical section.

The patches are independent and leave the event class and trace format
unchanged.

Cen Zhang (2):
  ocfs2: snapshot dentry names in file-operation traces
  ocfs2: snapshot the dentry name while tracing file release

 fs/ocfs2/file.c | 97 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 68 insertions(+), 29 deletions(-)

---
Changes in v3:
- Cover all six ocfs2__file_ops call sites with two patches, grouping open,
  fsync, read, write and splice-read and handling release separately.
- For release, keep the trace and open-count sample under oi->ip_lock while
  taking and releasing the snapshot outside that lock; cache the
  event-enabled check.

Changes in v2:
- Replace d_lock around the tracepoint with a dentry name snapshot so trace
  callbacks run without the caller holding the dentry lock.
- Pass both the name and its length from the snapshot; keep the event
  enabled check and release the snapshot after the trace call.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0088-v3-d628f98bfcb6784a0bfb@gmail.com
Link to v2: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0088-v4-a9a0df898afb4fc65fa0@gmail.com
