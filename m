Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B5817C8
	for <ocfs2-devel@lists.linux.dev>; Sat, 30 Sep 2023 05:02:06 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1c5ff5f858dso87314145ad.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 29 Sep 2023 22:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696050126; x=1696654926; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERTq1h2JUPIQir/rEk+r3r2PZJ52vm7XhnYInCUG6b0=;
        b=XX7Aex8AOU+78QtDt+d+3T6TR0TjHlJyECcf5hZv9v3IKQfAj7rBKpm2aM0oWYkvrS
         CIqf/qu2ovQCNAAOyXN9akwPV7RwlPeIjU5rkBlqOmpgJ/4tpx07qzLNZvgG3hITL7Wc
         tzSaVEVg7EgPYtt8ZoOdxrth5H1HEsHvDnJged3SdrXINyouB3zMJEjuK56dJM+KP/lw
         Dz3fwEeH5ySKzl9w7pxg3Y2yq9FB3EQ+oy6D7nsWkh9lHpar+NAGZZaG+9SyyLXnZ/N7
         NIlGbQWeqapI7xxQ6ukPwXXA45GVCTRXn+zRJvX6tYg20yK6EmtZM9MlmnbG2ZApNBrF
         JEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696050126; x=1696654926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ERTq1h2JUPIQir/rEk+r3r2PZJ52vm7XhnYInCUG6b0=;
        b=ayfRE+f7XPg7ron7kaYI0T5OI0M7YKS4fntysBjqfXePV1legi34SdaBrpg+6NFimr
         bdWftD/biotrBOn9gLRjEls/4xl1ZLqBYIkYCT39m2tjeWO6VfUuiMB1Q0Vl1MfFAlYW
         rYbaPFqDltW5VBzM3GLyrSzLLh9OICY3X7FXX5oibWrsOXLLOlo75iblaujbHJoVPVEM
         TCeXpCg6kAKZf1QiHsMPSbUq30dofqC21dLCUv+w5ffPIfgC2UVV/MVFlWl2e4F14rqg
         urX51R7BY8xMOyZlgT1AIaoIcwh8Zkt5DJ8xgi5dm2aoZVNlAZ/FnniS3E2pjhpruU2r
         gI/w==
X-Gm-Message-State: AOJu0YyZpq920kMgZ+eNRtJj2vtYJ06hZbepzbHvsVUGVEy/ugGDrf4g
	gzgZOjPQ8PTPCykgz9G1+AA=
X-Google-Smtp-Source: AGHT+IE93Nz+CTn1eMCxHn42HhU5uqXNXT05Y4Weq1sWMG/m1tkqHDxA4tUzrKL70aU/jJiOIdVMlw==
X-Received: by 2002:a17:902:f7c6:b0:1c3:a4f2:7c92 with SMTP id h6-20020a170902f7c600b001c3a4f27c92mr4959184plw.65.1696050125757;
        Fri, 29 Sep 2023 22:02:05 -0700 (PDT)
Received: from wedsonaf-dev.home.lan ([189.124.190.154])
        by smtp.googlemail.com with ESMTPSA id y10-20020a17090322ca00b001c322a41188sm392136plg.117.2023.09.29.22.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Sep 2023 22:02:05 -0700 (PDT)
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Wedson Almeida Filho <walmeida@microsoft.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH 20/29] ocfs2: move ocfs2_xattr_handlers and ocfs2_xattr_handler_map to .rodata
Date: Sat, 30 Sep 2023 02:00:24 -0300
Message-Id: <20230930050033.41174-21-wedsonaf@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230930050033.41174-1-wedsonaf@gmail.com>
References: <20230930050033.41174-1-wedsonaf@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wedson Almeida Filho <walmeida@microsoft.com>

This makes it harder for accidental or malicious changes to
ocfs2_xattr_handlers or ocfs2_xattr_handler_map at runtime.

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
---
 fs/ocfs2/xattr.c | 4 ++--
 fs/ocfs2/xattr.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4ac77ff6e676..1c54adac1e50 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -87,14 +87,14 @@ static struct ocfs2_xattr_def_value_root def_xv = {
 	.xv.xr_list.l_count = cpu_to_le16(1),
 };
 
-const struct xattr_handler *ocfs2_xattr_handlers[] = {
+const struct xattr_handler * const ocfs2_xattr_handlers[] = {
 	&ocfs2_xattr_user_handler,
 	&ocfs2_xattr_trusted_handler,
 	&ocfs2_xattr_security_handler,
 	NULL
 };
 
-static const struct xattr_handler *ocfs2_xattr_handler_map[OCFS2_XATTR_MAX] = {
+static const struct xattr_handler * const ocfs2_xattr_handler_map[OCFS2_XATTR_MAX] = {
 	[OCFS2_XATTR_INDEX_USER]		= &ocfs2_xattr_user_handler,
 	[OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS]	= &nop_posix_acl_access,
 	[OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT]	= &nop_posix_acl_default,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 00308b57f64f..65e9aa743919 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -30,7 +30,7 @@ struct ocfs2_security_xattr_info {
 extern const struct xattr_handler ocfs2_xattr_user_handler;
 extern const struct xattr_handler ocfs2_xattr_trusted_handler;
 extern const struct xattr_handler ocfs2_xattr_security_handler;
-extern const struct xattr_handler *ocfs2_xattr_handlers[];
+extern const struct xattr_handler * const ocfs2_xattr_handlers[];
 
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
 int ocfs2_xattr_get_nolock(struct inode *, struct buffer_head *, int,
-- 
2.34.1

