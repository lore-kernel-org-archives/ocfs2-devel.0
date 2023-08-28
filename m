Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E07ED
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Aug 2023 05:18:17 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-68a3ced3ec6so2234829b3a.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 27 Aug 2023 22:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693199897; x=1693804697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nVrl0kwRfWIHx+sVHv84+qMtSVVK7pEdsXcZRB61X88=;
        b=j42PvIU0LosJj1YuVMu4dQ+rTM19D0TWC2wtKaBRZahCKd/Ufrb5W8/qo+A+ctpynl
         yJL74iBtB007bdz3buPdzwEMBgqkr5Sk98te2CpfOBcemXDSrXQD7DJG1d1xBLai25Xp
         kIHOOasBM6mLPk5yQD2gNrxcdt/NjDhim5ElPBpo51ETMKYPXectayNFhWXOdjkMGBq4
         EJQgFstw/N8b6OeoiNNiPyMADwJ76Yfugvy4TzGJmHC0tzXvpIqBY7ISKcMFV7umZGcO
         1SppT2QfbbWtwFdrMz/NQATuiWeZjzsesC+yOwNanKcgHnI15y1wzT12uPYypWiBkXzA
         jXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693199897; x=1693804697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nVrl0kwRfWIHx+sVHv84+qMtSVVK7pEdsXcZRB61X88=;
        b=SsUT5xbJKZ6IHqbxHWvLsgy2qFtlgydyygScJYEQPYMuzzd2h1nuA1H4EgLOhLZYJw
         YoBTT8IU7oOA5Wlyc7FOswggsg7/tmQoB62HjgiVjkBZuhycItbc2eMWdoFcrPCZplza
         jSbCOINGEI3C5kSG3R5peJTJzeOWnMV0vMXx4jyLJCASYpI5F5OwtfVrEUbevjwv3K1L
         7rOfN/7csGCFIGQlKD5zsmghz4NuF32OLEfRYtRFi1fQVBcywUJysG2RUO9gCbIMcQOa
         x4hjTUqFms6tTqqC4u51bU4nZW681NLVWjL+5BVWz9OGP+ZhDJAefs9pmvtkea8PXxSl
         1KFQ==
X-Gm-Message-State: AOJu0YzHB6KfSBdHReKfYE9OVGsw7C5GgaNjPOBmxLJBWg4eby2VBrNj
	4jJtmXDFpDsltFbPPAvp6o8=
X-Google-Smtp-Source: AGHT+IHJDLh6ZnUudool1Bu9OGIuqJGJVjytyiThv56LlPeCD/a1AenfCnfmYlrLuYKsz8tQpuJGrQ==
X-Received: by 2002:a05:6a20:6d9d:b0:138:5a28:e8cc with SMTP id gl29-20020a056a206d9d00b001385a28e8ccmr21011737pzb.37.1693199896992;
        Sun, 27 Aug 2023 22:18:16 -0700 (PDT)
Received: from vm.. (cm218-252-211-84.hkcable.com.hk. [218.252.211.84])
        by smtp.gmail.com with ESMTPSA id ji18-20020a170903325200b001b8a00d4f7asm6205581plb.9.2023.08.27.22.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Aug 2023 22:18:16 -0700 (PDT)
From: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
To: mark@fasheh.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yuanheng Zhang <yuanhengzhang1214@gmail.com>
Subject: [PATCH] ocfs2: correct range->len in ocfs2_trim_fs()
Date: Mon, 28 Aug 2023 13:17:41 +0800
Message-Id: <20230828051741.204577-1-yuanhengzhang1214@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

global bitmap is a cluster allocator,so after we traverse
the global bitmap and finished the fstrim,the trimmed range
should be 'trimmed * clustersize'.otherwise,the trimmed range
printed by 'fstrim -v' is not as expected.

Signed-off-by: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
---
 fs/ocfs2/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 51c93929a146..bced551240cf 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7642,7 +7642,7 @@ int ocfs2_trim_mainbm(struct super_block *sb, struct fstrim_range *range)
 		goto next_group;
 	}
 out:
-	range->len = trimmed * sb->s_blocksize;
+	range->len = trimmed * osb->s_clustersize;
 	return ret;
 }
 
-- 
2.34.1

