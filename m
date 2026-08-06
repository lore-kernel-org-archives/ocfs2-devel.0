Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B65481FCA
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035572; cv=none; b=Q9GJ4RIbOYpu6pd5ReCM0do0nh5yaKBTFruklrsoL+S+mRAqND2WwekKrMnQ6cvGVP7BK5lvgbm3kNC1js1UBS2cxZ1s900qeBGkXKxQUO/frSTfZPEmQ8zQMZZMNMvQN9QPzHTJCGKN6cJDaWqHQ9z8oTwxBOH2K6/IXdmkSlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035572; c=relaxed/simple;
	bh=XCQvARYs03Jg6cCkHO2H308pJ7dd7LthVfdbsY3TGbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrjv7jsXMbK9zHS65qlgtTwSoP672hdP4LKqyTrMm08knp5XTuZLnW/PQ+v+KPjvlcLzNS+8Ixg7yLLnM3MzoL9kaC/jlxRu4pp0c3Xcnm9XqY0YrM1Zf8uK+x3Kc7olJbPTxez2zJu3Vug3fmN0Te+XwWGJL2AWL5TR1AaT694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=neTsUu6+; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="neTsUu6+"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5c3163a88a1so677761e0c.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035570; x=1786640370; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W/UkvZ9btqQ9UcKZM3gfiOG/tPkCxSDzu5UxeQemPOo=;
        b=neTsUu6+8y2GVc5zjdzRU8MBj9g4jerbpD+I6DGhRi4KBXg6RwVexAGu2/cq0R4G5W
         2acY5UxhyLQacOUeWJFL8s7A+DEuw0bQ0d/giM2TxKGXh/SXpLhO0DM8MPwlTdm74mAW
         NyqoSRJOaZbVmCjNyxwfuJWWkElk8YT5jSUkCRj1HV1ZIx4X4iaRxbJiyaqh22PQc7sb
         YjeTm7DNmCM4nxD2aKyJCIOINOdRjfybhKB73HT59NC6ISI8N3FEi+qPPaPnrS8lImBO
         bHIk43luPbGjZrfPlNGzjakb8iTVzj8gmprxBKYsLhGQ9C0fjGWChLVmacJUPTe9JWRw
         5cUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035570; x=1786640370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W/UkvZ9btqQ9UcKZM3gfiOG/tPkCxSDzu5UxeQemPOo=;
        b=fZ7cKHrUBg5zxfNiha9fwX/eEd9hfGXmF3JAzqV4heFOHpf/yIgrsLaaoOAw/ipLAs
         YdxahgdG138vAXoT9Je5foUyyYFHlNd74xXeikMbb0ZxSRvSmK1tEDgsu0LOYIWFZVe8
         AMNGctnz5PB2sF6LlOSfQ/TIJs2TWoEAJ9XdBiUAvifaQpNUnAb1axncFwyjns1onv3F
         6Rgar39r78j+mPDcdxwAhJuwANoMDciHZoVgIV82SPg5Ntb2aLqzvajY6/s99D4iX5/e
         QJjXyQJOoHpYSI71vbjeA6UjRL8EwkC9QP4lKNrh2bABYRAXNpbfYVNYO0URcuhIyNRK
         qW4w==
X-Forwarded-Encrypted: i=1; AHgh+Rpy6Rby5T2L82jDXOIBDiZy0lf7kLGNpHbpEOgUPA2eaPWH0eMcpP7Hsiw4mGNOacvfw7pxRKHgQQ8tQQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyt46GrDjCqC2wF0i0glfhKRybhfhSbJfSwADG8huRn77+U6UAX
	cZmWv2cvr0VTFXhM2sA1cILi/tH7B34ojV6FA4ZC7sUvmOuKVLeTA4ct
X-Gm-Gg: AR+sD117Ovz/Vv7fuwyV37+1Ua+PyGqIMuhI0in2GsCmZ01s41gnEBQvgLdc8XZo5FX
	9RF/8KsFl7rKvSg4m0ABrh8xQmtSCOpGN2wd2llkp1el9mUGYmjs5mxrGPAgwxnM1+sIgXZOuIi
	DaVv3r9HxlCGjqnhHLdLVXd7yhQR97H77+6/J6nMOkzYqgN4BvxOw+VAtqMxyis6TRmwgUbhUIW
	5fm3Phm/4NLzBCr9Ds7Eg9P4SJyWRdPWC5MmaD3+P9mDWU2pddjyn6eIfKWw/Z8wGWMovCVCwzI
	UdgeVBIkNrJDV0qMSI6KwWRGM9ye7KmF1P8DdsvJARE6+VfFVwVkN3uirFR+1BBIwNSOPMhx7AK
	TyS1fv2MuGcHtTIKPBxPBLzsOg+Z4GeF4F44Eth9r4+glYYKj+AZbNWMV91tk2h6XsM9WqbIEch
	TYImET3xhG1GUW2vxty34Zjrf2vn8WLSYWBanWp0Aw2Xv7BxtBVEjx2dHTSHsOCQPTzgjfIGyXe
	AnJRrPY2/QDxXrojw==
X-Received: by 2002:a05:6122:e248:b0:5bf:9bd1:791 with SMTP id 71dfb90a1353d-5c3d912095cmr2047468e0c.1.1786035569648;
        Thu, 06 Aug 2026 09:59:29 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:29 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 08/21] adfs: check for a directory write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:31 -0400
Message-ID: <05cf8ad911ad7a6eb68f42e38f1eea39c38e246b.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

adfs_dir_sync() spots a failed write by testing BH_Req together with
!BH_Uptodate.  That relies on the write completion handler clearing
BH_Uptodate on error, which this series removes: a buffer whose write
failed still holds the data the filesystem asked to be written, so
declaring it not up to date is wrong and makes callers re-read it.

BH_Write_EIO says exactly what this code wants to know, and it implies
BH_Req, so the pair collapses into one test.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/adfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
index 11afa9e157aa..b8cc6a697a05 100644
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -191,7 +191,7 @@ static int adfs_dir_sync(struct adfs_dir *dir)
 	for (i = dir->nr_buffers - 1; i >= 0; i--) {
 		struct buffer_head *bh = dir->bhs[i];
 		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			err = -EIO;
 	}
 
-- 
2.43.0

