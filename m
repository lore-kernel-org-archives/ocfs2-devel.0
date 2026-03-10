Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A8F379EC1
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Mar 2026 10:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773138264; cv=none; b=BlKwQUULKg3QzWZq1GR1Zt6K3J+pFXkqzdSpluwchhTxa7ra4XalLFtsS0yFVexnVEZB6V7HYpbuzdZke/PYOBT1wUzKkIKjp5lu3Szv8iGmzdnqEwt4RhL0Z6y/uOYGPT4Ilgw4AXzsOffWUO2ASil9GUULcWUkNM1Z5GbP4rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773138264; c=relaxed/simple;
	bh=WooeCMHirdkWlS89DfPv/fNcppwDIVb8ACPiR41XBXA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OtLB9E5hOk7GicaOUB/fsdxBHMtflfdtsinNLJkjKdIKk/jcb68rVXfCEN/crbhwKSJ+1XImuoZ/PC+rf5OGCYeSFnD1UE90ANBrkiQ+mLbp8vrlW/CyfzVcpM7ZYxdd4uxyexsDEDvNiSz+04udL21KZyK48fXtFWaIJLi/6zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PtC1fQXy; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PtC1fQXy"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-485350d142fso737305e9.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Mar 2026 03:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773138261; x=1773743061; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YUTeIjWqA9567VJRLb/li7dsN/vpMHlxaubesGM5Cxs=;
        b=PtC1fQXyyMxQZxiXIa8aXa6fKjRMCE9AYVoqdq5ezJ3xwdUAXXpvD2xrSHw8oOx1/X
         6xqCwJg1qtLMuk4GrDkbsYI6dZZkztRD2HKGwQH0j8NFq1WgpZOildQqQAxy9U0PH4PY
         UIKDitp0efrzX8tzWiQW9/lQEiYT9uIdeD9Cb6eKWN/9a2/e+tAOnNsBFjB/6eErkEyV
         kFIqzF7tdJldrnnPvi9qrxke19Ye3LG6Dvazc1xh1WxmHZane4f7HKsnh76P6jk8VLTY
         KOVkb7Ckyp3FjjtkcWrcARCcwCU8+qVN2QoJ4oItweT1XIuJ8sYgDknJVvzmn8SBe9+K
         SpGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773138261; x=1773743061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUTeIjWqA9567VJRLb/li7dsN/vpMHlxaubesGM5Cxs=;
        b=sekCEc4/WKYjH5Mtc2YGlga/rA2n+RS8JeNVbEyWsFr9vY926+1haF1bCRVGysCBCA
         cSZy1XQQ4xh3kJFtEEE3/lWKavkBSrIusY3o11c79qtGHvdD3BGjWV6sORC29ekL1B1B
         sFX3BzFO5w3IFtmc22WSCTBAQlBf9R2I2EP5Dla04dlY/wOg7EwuWZU8NItXbk9g1DLf
         hvjDnkEi45Les1BMYcqQyjcoN7G++lmD59cSUadmC1lreq2UWjtI7AoV77RXz9vPGFhF
         VvaJlATJRcwSDR4G9O3rXdwUiYVO9+TtxT+CPvPhhIXeh4YqeqShXLzXsEmZDocw76Zg
         QDbw==
X-Forwarded-Encrypted: i=1; AJvYcCUpcpeTskpUNrLoKjcn4NbH0hlHW8CLTmeAxk+aU3J7IGWzAcHEUDC12+kv5u8+SlRUbGtA0HVqOTN5Pg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyn2BZ7gXRZ71NbipiNvDZqDGrmi0lZI0WPgYPxbWCu7tY5Cyl+
	XaGj89ev3oVLsgrQ25yztc3AM0VjQ1ca5PdStZrs1UGHlO5UshAe0zhTRwXawDniRqQ=
X-Gm-Gg: ATEYQzwFIoLfjxrYZ41QxR0CLZDypjgLUwF7Q/h+f0I2wfjSPOlR+dFocVlp7oStZjl
	wcm1Q66X49f42uzadfk/HCqpTBrOyq/DvYh7aceReVAs0es13jz8x8UREu7IDE0DHg2QMZ7tVi7
	/X4z/HNKg0ZUBeSlrpEgwh0iWJ8GiWHBm5+vzz1apZYxUwh+scI03ZFFg9t4Jpl0FmMRtzIwG9x
	jhN6Q6INe4vxQwzf6zVvtixvWnPwbBR+NWpqSPPfY0iTWJvABJeWNF6bTS9BZ7MGHlFa66DUzt4
	vBNn2gCxqLewHjs0LyNKfd4mp//Sm95t9jnXUqr32F9TslphCLPr23nUzwpWUMtkYlUZbpy3cjm
	zW/eQX8UpAf0dtZ94a1RgrwA0l6nkM9PT7UdPmw9F/jXXxduPO0pZAa8ZT1h3Ma7CJpSSvk0FpM
	G9BhBy40UG3OMFJ41Tqv1n2XyUVxbbKiOvOO8W
X-Received: by 2002:a05:600c:3588:b0:485:385f:674f with SMTP id 5b1f17b1804b1-485385f693dmr85765955e9.6.1773138260876;
        Tue, 10 Mar 2026 03:24:20 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e9c965sm150251325ad.32.2026.03.10.03.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 03:24:19 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ocfs2: split transactions in dio completion to avoid
Date: Tue, 10 Mar 2026 18:24:09 +0800
Message-ID: <20260310102413.12501-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For easier merging, this patch is based on Joseph's patch [1].

[1]:
https://lore.kernel.org/ocfs2-devel/46yilbaq5z5x6gdfdpoa6lprf6sf3gbxriuku2odje4kx4bovf@jd735cphfutz/T/#t 

Heming Zhao (1):
  ocfs2: split transactions in dio completion to avoid credit exhaustion

 fs/ocfs2/aops.c | 56 ++++++++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

-- 
2.43.0

