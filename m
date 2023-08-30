Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EF1749B
	for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 21:55:17 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-34de98e01d4so857845ab.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 14:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693432517; x=1694037317; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZEwMbaCVyaLIfxuj5Unnl9VhZcfo9P9ZpGHH411u8s=;
        b=E55cM2XwpInGZumbGRZFf+IGpFtL8KXebOiuw5auP+qHdZzn2LKIkHGz6EIOxM3lz4
         puZgerWYzfNhxl/aoT1NNe/ia1HTUBlncPzedbPAZkuKLZaPEg7/qoUjrHTYrSdZ10Dy
         ymAbkKIhfo1jcr0AphoHxPIfP2TwrSp4PXdSy1yAvqv71jNbLGHi0VcVxzfenp6dQuqv
         5BKTy9IwbLzCJpL6TwCite/UuzbSZ5+KcJGA+mkAgCq+8Wvaul5DraR/y6X3LJ/7DMYH
         UxthungVqRPhZ/IU52+xHoSwBiiwOBIDd7svBxF+PSZ0zeHnw+OpKYj3C7DjEPpOO2H3
         JIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693432517; x=1694037317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EZEwMbaCVyaLIfxuj5Unnl9VhZcfo9P9ZpGHH411u8s=;
        b=CXbRTxWLg80VK8EU1X3b9OzcGHtLiKtFQLhgr1SX+HtnEjiSPGkoaTLkGwDvrYb7qa
         J5iM11l8ef51TKf1EB+BMzvcp/8iQOGJpQE0FrVOUCh+Rkc7cctDAGAaw5lQ6+lJXuCb
         cZPyLjQkMa2rQi5tsCVdEh2Gjvq8mSGiWxQ2XtFDITNqSoMpyBFXBi5BUHn0d7fI+Xa1
         5A1+pNDCFYoJiEffIZv0xR2hIazwDuOq5qdPSRIvWZIBC1CEjS9jErj6E2HSDk/csfiK
         ZNDoceZPbyXQsI/bEAg8TOjX6/wXu8GPTDvndb7DAxjY7wDDsEtNDv7NSj22TlVSijGX
         +asw==
X-Gm-Message-State: AOJu0Yz6SFtPzyQDpATZcknyMfFmpCgFUzs8FG88TSCj0u2N8m8mMpG8
	HMT2OmlLDbgDN9tbpaXYobYR+E+ICu7kCR9W
X-Google-Smtp-Source: AGHT+IEuh4ZymI9ePYmxpZ+Ps4CAcxYRzl8D4tGfNtuA8+ZCoskmH6nx/RuzghiJJQSuWfb+mrfE+w==
X-Received: by 2002:a05:6e02:df2:b0:34d:f32c:1d8f with SMTP id m18-20020a056e020df200b0034df32c1d8fmr3693713ilj.17.1693432516637;
        Wed, 30 Aug 2023 14:55:16 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (161.74.123.34.bc.googleusercontent.com. [34.123.74.161])
        by smtp.gmail.com with ESMTPSA id v8-20020a92c6c8000000b0034ab6f53e23sm50527ilm.28.2023.08.30.14.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 14:55:16 -0700 (PDT)
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
Subject: [PATCH 2/2] ocfs2: Replace strlcpy with strscpy
Date: Wed, 30 Aug 2023 21:54:26 +0000
Message-ID: <20230830215426.4181755-3-azeemshaikh38@gmail.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230830215426.4181755-1-azeemshaikh38@gmail.com>
References: <20230830215426.4181755-1-azeemshaikh38@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().

Direct replacement is assumed to be safe here since
it's ok for `kernel_param_ops.get()` to return -errno [3].
This changes the behavior such that instead of silently ignoring the
case when sizeof(@buffer) < DLMFS_CAPABILITIES, we now return error.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89
[3] https://elixir.bootlin.com/linux/v6.5/source/include/linux/moduleparam.h#L52

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
 fs/ocfs2/dlmfs/dlmfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 33e529de93b2..b001eccdd2f3 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -80,7 +80,7 @@ static int param_set_dlmfs_capabilities(const char *val,
 static int param_get_dlmfs_capabilities(char *buffer,
 					const struct kernel_param *kp)
 {
-	return strlcpy(buffer, DLMFS_CAPABILITIES,
+	return strscpy(buffer, DLMFS_CAPABILITIES,
 		       strlen(DLMFS_CAPABILITIES) + 1);
 }
 static const struct kernel_param_ops dlmfs_capabilities_ops = {
--
2.42.0.283.g2d96d420d3-goog

