Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567E92B9CD
	for <ocfs2-devel@lists.linux.dev>; Tue, 23 Apr 2024 22:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713911422; cv=none; b=peaf5Sk5HeyZVs31LIdVN/rzoTOyhSllCv/DFCQxRTctG6PSWLvQqqFoxcVvXwXZMWMC0q95PUQHDIEJzwBjjzgp21htuFAKhP2xU8pJFJQ0MD8+B+KhTJ4i/WZrmP8JRT9sr63jQ3mWMggY8sPvMrMh9RQohodiIjmz0LO4VvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713911422; c=relaxed/simple;
	bh=AuQ+SQkDeUgELtorzKrgNQtQFOOdwGtzbtOT14WSWCs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=CBj4xas0EAAyqtdWG/HVfd22k9ZG4Sprq5+30qko/2tLiyYVhRHnhDsdeA8oCkCHo6ER3OcfbfCf36WCrHl1VOOgvahIVLIqQc5Tbl4ljjFhcx2uabf/vKG+QXVW783V07LibiGiIJNUwZi5rJO3TlAqBkyd1OGTp6e/FF1OYDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P5TGVwzL; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5TGVwzL"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-34388753650so3285666f8f.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Apr 2024 15:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713911420; x=1714516220; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=66Uz4GRic3IGdZE7sf+U5tu1ETLXCRIKBepd9JZ9A+U=;
        b=P5TGVwzLD8+fIkAv+4IGqyg8mSZjTEIYJc0jLk6JtKcDI9ZeJ4VkfqUK1kTdGD6eX7
         gQCvroY1vlpHBLj4Z9adYL+jmZIFYUPcW4A3oRn9p8bD5L8fgh99f1pQ0j1636fEwpbL
         vflHMVuqmjF8fGonGw7WY94hBFyLN0BXqwezBz4d9PXZ5b48CmeHBHVEg0DwjA0MaSgw
         gPKhJsOafm5HjX7ooaMwyUgtS5QlgorP+OaW+qSHfMFFhMd1Nkz0iBGuzwSifn4wJCKV
         H28KfRNiwoKCkHJcp9bTyM1xuFIZDUUqAVNX0FsKCuM9Fo0txa5sDsNWE21pOXLYsa4K
         /iRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713911420; x=1714516220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=66Uz4GRic3IGdZE7sf+U5tu1ETLXCRIKBepd9JZ9A+U=;
        b=v4ibc+Z2MCNIyqV9R30JxWxZUyTEw3Z7oks+81RTYi5dpcoNlaE6N/bPrUM09kKsUu
         9aZcWyoLZWdes6qmNK8u/9rMnpcQkPbooWfpHPAxm+LI9R6NG8DNBcSxaq/pXsvlA0Jg
         kBRGAYIeMQMaZt9OJf7eogItvXTQsncYN3U8Zuwi9rvyt7iGhe9UzusfiXAS8e05TvKR
         9lx7NqCK/no5U8Zq4FVootSbcl2us72myEsAzrfnHAtASa2yMUkNAZ3K1CnOOWbuenNH
         MIDta1auMzqsnP7qAoYlmVsXlIJyTAz1ZL+HLHIvaxmQ353nDm9K2V0OnWtiuoKE+ZE6
         ELDA==
X-Forwarded-Encrypted: i=1; AJvYcCWKF/Z3V3k1mQvxG6emk1kS9szOGGJIfa2DNX6lyEtYkaC1/pjoUWfxaFfwz7mkrcYVg39slmdvxnejPtwOOMaBGiB/Y8rR2Jjsm/c=
X-Gm-Message-State: AOJu0Yx+oP9LwxzhOUs3hseQnAJhjAfa8cCwQZ2o0Iv6X08FC7PS/jds
	F2vPpfq/pnQBTTjSli7rPe2c6wxuGBegJ+ylG52bkARHac5b6W3C
X-Google-Smtp-Source: AGHT+IFcYjeSexBiXa/qAM2MmNnEH9f267vXL2TPkUjnoVI7tPI8s28Zm3TvA6aFiqv2VAgFYFiNTw==
X-Received: by 2002:a5d:5691:0:b0:341:72b8:83b9 with SMTP id f17-20020a5d5691000000b0034172b883b9mr368623wrv.68.1713911419577;
        Tue, 23 Apr 2024 15:30:19 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id b4-20020a5d6344000000b00347363b77dasm15466238wrw.33.2024.04.23.15.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 15:30:19 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] ocfs2: remove redundant assignment to variable status
Date: Tue, 23 Apr 2024 23:30:18 +0100
Message-Id: <20240423223018.1573213-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Variable status is being assigned and error code that is never read, it is
being assigned inside of a do-while loop. The assignment is redundant and
can be removed.

Cleans up clang scan build warning:
fs/ocfs2/dlm/dlmdomain.c:1530:2: warning: Value stored to 'status' is never
read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 2e0a2f338282..2018501b2249 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1527,7 +1527,6 @@ static void dlm_send_join_asserts(struct dlm_ctxt *dlm,
 {
 	int status, node, live;
 
-	status = 0;
 	node = -1;
 	while ((node = find_next_bit(node_map, O2NM_MAX_NODES,
 				     node + 1)) < O2NM_MAX_NODES) {
-- 
2.39.2

