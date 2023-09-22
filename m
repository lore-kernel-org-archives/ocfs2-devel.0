Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A796436B1
	for <ocfs2-devel@lists.linux.dev>; Fri, 22 Sep 2023 17:49:33 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-690bc3f82a7so2360483b3a.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 22 Sep 2023 10:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1695404973; x=1696009773; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6o8rcy2kYsMziijJ+HwTfBhFIINOkXf/UXn4gSYDrRE=;
        b=SluoaczvyekfSgwxmU6b2nvCnV7DiwFEQEnVIn65cu9AODEdfBQjsew1PMWP6ZhO9A
         2boVznnpCZu5KXI21OhJ9AAjdXSbpWErYm+lRV1kJI8/eEA+uEUwgEPHdddE9FeHR/0j
         4LN750O/6VKjBO1+gRL4ndEE3tzK3eR006ZZc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695404973; x=1696009773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6o8rcy2kYsMziijJ+HwTfBhFIINOkXf/UXn4gSYDrRE=;
        b=wxIGjWWRTdKpZE1JEYYDf0zTa/h79EOqhkp1kK5QB1PsQArrJwg+JQYePWSiL27PNN
         9QoYsrSZKyNrYyLnE7FikDI2JKC1p6/EO7hbIRxjdq2eY2dOFrmWtOzyDZQdE1dT/Ua8
         wK0VsMrQt2FkNX3xjCJjwbZVXATdpoJSyhdsTKa1CDbjuK17D0PwBT9nxGRdc3AU9O0N
         1ljiYX5njJzuD6tlHbHOuox7tZ9BXTIYPOrl9VvsH3ekJ4RKLwJgjCynVo9nxixvOx/P
         ViTvLxQPyAQHp53zXTuilvzYgxrcZmi3bV4iLF7XAhAAhIWFuCfd7Gh88x5YqbXvrujQ
         3oTA==
X-Gm-Message-State: AOJu0YyesM6OZxjat5/XQMhmiz/BJD5+GYuNDNGHvAs22A8boNUBrc71
	fmPhSMh42uoXDxgONdR5mSXZ/A==
X-Google-Smtp-Source: AGHT+IGBbYRZZj6iJdxISWqR0rCjwyvcEffe3apxgZbJGOfRTRyOM9w1AParWKjksC8mYeC8yyxppQ==
X-Received: by 2002:a05:6a20:12cf:b0:15d:c40e:5cb3 with SMTP id v15-20020a056a2012cf00b0015dc40e5cb3mr241613pzg.56.1695404973361;
        Fri, 22 Sep 2023 10:49:33 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id t24-20020a62ea18000000b0068a0922b1f0sm3451624pfh.137.2023.09.22.10.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 10:49:32 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Mark Fasheh <mark@fasheh.com>
Cc: Kees Cook <keescook@chromium.org>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	ocfs2-devel@lists.linux.dev,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] ocfs2: Annotate struct ocfs2_replay_map with __counted_by
Date: Fri, 22 Sep 2023 10:49:30 -0700
Message-Id: <20230922174925.work.293-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1391; i=keescook@chromium.org;
 h=from:subject:message-id; bh=EI/V/Mukp/n4kMrskYWItkkDhXixF2aSgcv9kFKrUtA=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlDdOp4GqjAOXqDf2PKH6lUrCfLTSmb8x0bIiGt
 qKfvxpE3mmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZQ3TqQAKCRCJcvTf3G3A
 Jsg0D/9sEXbcZd5+u7yKxlCfUg5etMGyF3yjv1d7pHxhN/kLC0sHVcgzTmfkviwXpI4gZPgOLLK
 kh8dMVV6/OBBlVK2lBf9Z3nNlVj1chGDYuoREQRDbDJWyQjVbAhpOeVDZpB0M8JZHFmlkHxRlr3
 GATMiBdaIp/xl7jC27Qug/Gy0fVqWf95G5/ZR9Xx9Hc5Sd/Q+E4tD6SKN7zGXx3GMuVflLhJ3ZA
 CAIY1VDHpLcDWNwdTt4srhnMe5paJjbCgQVbhYlrF1ZL0QjdXvXRts537gqeBZzCxr1Rlrsnx5e
 3ZYNCsrZkaWEJxr3N+WoOsdtD7LFW8e/Htc6FXhCHKDwucfrgI8UJqTGe+LnpK5uOJpqkZWQapy
 N8Is6s+kthMpzwHCUWDwvEwugrQhV1J4lKfQu2eEfSNh/WQZelpyZZZreyEw4Y7duL40VHw4jHk
 u9vZ5VhGVi600kCOwoGgNC1pvLE4yj/o2Tfh89HkJtmfTFqApZEatrd0pjroRWFHXaiSWH1GKwk
 IkD9aaI69iQeRx8t+fS/aCQ/hpnlCDSRVgrWsINZN2QGrVAkuyQZvYOAj9G2JEiZotO7g1R8BX+
 zXAJmZK5/0wHIsrD1hOFOEROBmWxhasTkAPF8Qvb0WFRakdRTPWkUsNDgeCJiBOh75L4Xjlw3+Y
 gHdgVH1 ISyxNZfA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct ocfs2_replay_map.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: ocfs2-devel@lists.linux.dev
Cc: llvm@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ocfs2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ce215565d061..604fea3a26ff 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -90,7 +90,7 @@ enum ocfs2_replay_state {
 struct ocfs2_replay_map {
 	unsigned int rm_slots;
 	enum ocfs2_replay_state rm_state;
-	unsigned char rm_replay_slots[];
+	unsigned char rm_replay_slots[] __counted_by(rm_slots);
 };
 
 static void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
-- 
2.34.1

