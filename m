Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4815749B
	for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 21:55:13 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-34ca1aadce9so870365ab.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 14:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693432512; x=1694037312; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tw4l7vffGQ7DFvoP/Hb8EaSev5ofO+RAhmjDHMGDV2o=;
        b=aQHhDTL1qsOyCeJQwVvEXScOjOa8VcTLrMyLWkvS5KqBJlLIDWxI1dcg2qbPRGaVx5
         brmlNpXpDgh/BITrU1aAZq/NAQWl1FOZMKFlUtz82HCmsNObe00jCzxfklKZCfwlglZk
         1rWTt7b1m313hoQT58EBk+F4eu2u8Uf+jc8tbIOZsrmeE7w7P9+0OeWs1QPBUPzcfJEG
         sZC4pOlYVbER7rtRAD05JkX8mX3xLaY1Oa6NHXbntUghtRNR8QJocNX6mvEtgLlboalX
         s8uoprU2Kwu7f7x9lFCUq/WG/CnLQLRkrnDYPjuDEEOGNpbUGBRsipSRrXaN+kk+R4G5
         mwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693432512; x=1694037312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tw4l7vffGQ7DFvoP/Hb8EaSev5ofO+RAhmjDHMGDV2o=;
        b=FvIyUO1KfxEmqnn9/H3u1VljxIsWWBzz9s22YarKuTd5PO/MY8wjDgmVn6/1U+pdmp
         U2mNrECTz4Y+3gmFS4IQnqH2tVSA3x5FscTS4jFyJ/+ISATMFBVLJ1qm9GziRZNn5dZQ
         KcmrTSzGeYTNOASEYYlP3hxw6UdYcaS6tcKBxSwsxNsvGKxRixIAPUu+ShtYWdfUmxoB
         2xWAe7QYNop0GoC8D5YchgCTLARzhEx0WquCzWNYWx1hPlrrCFATJQG4SGIanBC+rnff
         Ko+yMZkPNsycnasS5a5mmxpM3shwFRPoIh/KmEinfE/5ERTE5lWwDSjhPqBKxL8ddnjw
         cOOw==
X-Gm-Message-State: AOJu0YxPlY8hQjItf+tfGwijW5Is0tWZMjlVs3vcpHwUsuCU0WLsSOFJ
	JpHXa4vZXs0Ki1uDKiqfRySLupamc2L9XGzY
X-Google-Smtp-Source: AGHT+IEZOM0oFGMV4UO92u8JK/496OKYhdek1cjlp4iV8zcc+Cb4xipD2vv/A1r3IBGt/odAlh5h4g==
X-Received: by 2002:a92:da4e:0:b0:34d:ed6e:ca5b with SMTP id p14-20020a92da4e000000b0034ded6eca5bmr3568492ilq.20.1693432512573;
        Wed, 30 Aug 2023 14:55:12 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (161.74.123.34.bc.googleusercontent.com. [34.123.74.161])
        by smtp.gmail.com with ESMTPSA id v8-20020a92c6c8000000b0034ab6f53e23sm50527ilm.28.2023.08.30.14.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 14:55:12 -0700 (PDT)
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
Subject: [PATCH 1/2] ocfs2: Replace module_param_call with module_param_cb
Date: Wed, 30 Aug 2023 21:54:25 +0000
Message-ID: <20230830215426.4181755-2-azeemshaikh38@gmail.com>
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

module_param_call has been marked obsolete [1], so replacing its usage with
module_param_cb instead.

[1] https://elixir.bootlin.com/linux/v6.5/source/include/linux/moduleparam.h#L296

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
 fs/ocfs2/dlmfs/dlmfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 81265123ce6c..33e529de93b2 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -83,8 +83,11 @@ static int param_get_dlmfs_capabilities(char *buffer,
 	return strlcpy(buffer, DLMFS_CAPABILITIES,
 		       strlen(DLMFS_CAPABILITIES) + 1);
 }
-module_param_call(capabilities, param_set_dlmfs_capabilities,
-		  param_get_dlmfs_capabilities, NULL, 0444);
+static const struct kernel_param_ops dlmfs_capabilities_ops = {
+	.set = param_set_dlmfs_capabilities,
+	.get = param_get_dlmfs_capabilities,
+};
+module_param_cb(capabilities, &dlmfs_capabilities_ops, NULL, 0444);
 MODULE_PARM_DESC(capabilities, DLMFS_CAPABILITIES);


--
2.42.0.283.g2d96d420d3-goog

