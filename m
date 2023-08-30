Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CB0749B
	for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 21:54:46 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-792726d3aeeso10485839f.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 14:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693432486; x=1694037286; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KUNPpkTqaf/lW9ABpvSuRweB/pjWZbf+kRWJm858Ocg=;
        b=n6I/UY5ZjciIrdQUl/zqN9ily5RRcE58ORzy16xwxWVYbk7DvfVQ3MKr/maeqWYch/
         iJYr5f4AUI3XaPZSkiLbL3Ls9pMN5RpYgGIx8H/0DEo/gjf4XLBHVEuD/VcdxFYGdzc7
         WUnv1tovisEDcZP2A1WCnufdP5D/WnHPFwfX6k8iwJA54xAwGUgPjlI3P3f84mJ8XEuC
         P0v+jhN8uA6/Ltg+4ptfVqNlxDaHRMg3EqKxvGffRzbJbE75BFkloqlpaHBKyhkbR66c
         D5UiI02FCWTnlr5v14mJqLDa1Pv5XirA/5NyWMu1tkf+h4WsaKyD0dcse91PsIUhVwRa
         39Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693432486; x=1694037286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KUNPpkTqaf/lW9ABpvSuRweB/pjWZbf+kRWJm858Ocg=;
        b=aqns54Pwo2KP6KWtbs6ZJC+zfg0W9Bnd6qAdDf8kcFA6ASTXIG+NyurZvf9mXWbOrL
         gyKiWZ+EQr3dZDCiWr/ewS1FsD/P1ryrWsYuHffOAIXaTgT4D4CI8/d4YAL3l6tYBvkR
         SIyGJsLtHILaWlCYRqk6INhoTwvPrLInyS7e02HcY8/qSXSKOGoacHVQOwsnqr4t35TW
         CuJZxm6WHRfx7PuU861j09Ty1k/WzYtfBnzoJXZ22fwous3+8OPh2UdFFR1EGPqO/Ffb
         8W7PXi88i/X4S4XX3kekVS/sNcAstcw8bzJ74nu/euwZMD5gqk2ziCEiJmZj7Yu1FAUt
         bUfg==
X-Gm-Message-State: AOJu0YxiHKoQmmhvsbqlO7Re51wZo5ycIjXwos4Rk0lppSoxuciMWLTv
	iC4qqfnv/DcGSZvuQvo2JU8=
X-Google-Smtp-Source: AGHT+IFFEt5A8+6W+g3EPKz1PjqQ+1HYln0EKu3eVvMd/FDUfOeH6MT6dPUbNlIKc68i/uwtuIFSEQ==
X-Received: by 2002:a92:cf47:0:b0:345:d4da:41d with SMTP id c7-20020a92cf47000000b00345d4da041dmr4015621ilr.8.1693432485985;
        Wed, 30 Aug 2023 14:54:45 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (161.74.123.34.bc.googleusercontent.com. [34.123.74.161])
        by smtp.gmail.com with ESMTPSA id v8-20020a92c6c8000000b0034ab6f53e23sm50527ilm.28.2023.08.30.14.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 14:54:45 -0700 (PDT)
From: Azeem Shaikh <azeemshaikh38@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: linux-hardening@vger.kernel.org,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 0/2] ocfs2: Replace strlcpy with strscpy
Date: Wed, 30 Aug 2023 21:54:24 +0000
Message-ID: <20230830215426.4181755-1-azeemshaikh38@gmail.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The main patch this series is targeting is [PATCH 2] which replaces
strlcpy() call with strscpy(). However, while I was tinkering through
the code I noticed that `module_param_call` is marked obsolete and
`module_param_cb` is preferred instead. So I have included [PATCH 1]
which does that.

A crucial thing in [PATCH 2] I would like to bring to reviewer's
attention is that it changes behavior for the case where
sizeof(@buffer) < DLMFS_CAPABILITIES. Currently, this is silently ignored
but with the current change it returns -errno.

Thanks,
Azeem

Azeem Shaikh (2):
  Replace module_param_call with module_param_cb
  Replace strlcpy with strscpy

 fs/ocfs2/dlmfs/dlmfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--
2.42.0.283.g2d96d420d3-goog

