Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE271BF09
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jul 2023 21:59:30 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-686c06b806cso276605b3a.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jul 2023 14:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1690408770; x=1691013570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iUoFgr64KB2UpVOFBQdb3fXLboqR0/gHMpW4+RbUqpk=;
        b=Z8HPE4tqux9CyxPkz0DHpPIV7emD+YjrccBOGvQagV7m7zeQd2XhmCtleXsSrXP10+
         CJ8CgHxSFMBDD23UH3Cy+teLhQOyLyPCtRuFjm9xCfYTqmd97r+/lQau0sibEkb9El5z
         U5+fhSKGcuRphkEJC1usPgP3Jwjq73Y8LJJxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690408770; x=1691013570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iUoFgr64KB2UpVOFBQdb3fXLboqR0/gHMpW4+RbUqpk=;
        b=KoZZ8gt27sG4mddkXVtWetCkiDLDUALxC1z1FPffj6S4I/3ID539bca/Sqvz/bbbs4
         VSxe383uggc1V8v7aQrGs2blXLjgazG0jqvsXeNejJul8BPeUEcM14WS+s+rx9z1HMAQ
         HK1a2m1mVS1N8WLJjeRm0uLVcgwBUQvyt0lxuA1KwomjR+BncCo+dpA9HqfCeP2kg6z1
         qExOTL4H+mesZm8vsj2HzhFwp+7aEV2iYitI0z2oWkLzWbwehmHD1f4tNsyzR4hgBtCp
         H2JCqmD2Ci6wzsksuuNwO+bmxvNmsefAqhXgh8/UF4FKUXkVMh5U96SgHEV+QvtdRWUZ
         HbnQ==
X-Gm-Message-State: ABy/qLaTobQe/B6HmXP8ZayV7MZbztMXDLZ9lvgHqX7AwROd4+Slh4zE
	msZZ1YNQ3Ti5nFoLVaPL6+bXcw==
X-Google-Smtp-Source: APBJJlGMtsTkQRl3Q1kEtlVd9gtXD6S3B4tZ440ZJALLEHm9Mb0ucbFdNihZsWC4Nc83LlcQbiyrmQ==
X-Received: by 2002:a05:6a00:1591:b0:66c:9e97:aece with SMTP id u17-20020a056a00159100b0066c9e97aecemr3488579pfk.10.1690408769927;
        Wed, 26 Jul 2023 14:59:29 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id c25-20020aa78c19000000b0064d57ecaa1dsm94401pfd.28.2023.07.26.14.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 14:59:29 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Mark Fasheh <mark@fasheh.com>
Cc: Kees Cook <keescook@chromium.org>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] ocfs2: Use regular seq_show_option for osb_cluster_stack
Date: Wed, 26 Jul 2023 14:59:22 -0700
Message-Id: <20230726215919.never.127-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1193; i=keescook@chromium.org;
 h=from:subject:message-id; bh=QIxFftlsiJNNbEL1xf2v27ZfHLWZozkFWk4Q3E+r9mM=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBkwZc6HYN97c9dpESG5p2eAapuOSApu4iE/Li50
 W9KrMtx9X6JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZMGXOgAKCRCJcvTf3G3A
 JisRD/968M7Y3iHPE7qmqIHWJy71IXr+3Ge8eIMJRB84Sid3S2QsPFDA9ACIx7IBLLbNKGSEUyj
 j94Tsb6DnhkiwlfUiuwZriheWyE/JB7th/vMT0kWogUaGnGdzewknJ0V18LbRh2pL9W6/5d7I16
 zI2JEg7hsPb2OexXnUIWn9LbF81I5LbO4vY3/Ht2haYNwD3ZBZbA52LfGK58uSUcdZ/7yvAVjOq
 5wOxIlqep3pUzsav9fHzPMicAN2E8vBYcueDmLVQlLhqZv3jaXOL4ebzQMoTM8noevWmdM2P2eV
 9Lne391jiQ9U8JWyEte+d1UBkNP4CH3eYvBHiHxeX4LufJZfrZi0YsJvTlTD6R8TjU6+Q9qA7y9
 Xcms//Uf4lqBrXWjtMDGqKazEW7167S6AxiQU3RVVWgu24msDJvPLlDLjeFVMVG+1QcqswUkodH
 Qq2KjDGO3ZEnlFtw8aAPPPxt0p9x9Vm3Psqf1B5OOfLuvxpJVAcXCzxc2nSZTDx53nbPaft/ho7
 Nsqg3p6kViO+OCDCYXFoELhGkNnK1QbTUcWivcuSE9WqeS8lXDWdwHZ80AUHPI1Z8S1rpTOqDQC
 e8sNn+41gfUjWobfsTXhXlyQdh4PyXLGYjubbq1Y86vFVOFdHhVAiI1wZ8mMsKuL1r2P0sVM+IG
 ZJcx0ti m3+rCGBw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

While cleaning up seq_show_option_n()'s use of strncpy, it was noticed
that the osb_cluster_stack member is always NUL-terminated, so there is
no need to use the special seq_show_option_n() routine. Replace it with
the standard seq_show_option() routine.

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: ocfs2-devel@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
---
---
 fs/ocfs2/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 988d1c076861..6b906424902b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1517,8 +1517,7 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",localflocks,");
 
 	if (osb->osb_cluster_stack[0])
-		seq_show_option_n(s, "cluster_stack", osb->osb_cluster_stack,
-				  OCFS2_STACK_LABEL_LEN);
+		seq_show_option(s, "cluster_stack", osb->osb_cluster_stack);
 	if (opts & OCFS2_MOUNT_USRQUOTA)
 		seq_printf(s, ",usrquota");
 	if (opts & OCFS2_MOUNT_GRPQUOTA)
-- 
2.34.1

