Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27331A316E
	for <ocfs2-devel@lists.linux.dev>; Sun,  5 Jul 2026 02:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783219999; cv=none; b=WMAY5vL5vOVoC1OQka2S1gwyPQJQo6fs37rkLtGho/b9TWy8ZC/Y4pDP8WPAnlgW5yyBJ9UndT6jdU/GJqRjTEGsCgwzZlK7GLdm8YT2gGpz/IswU9jy+oVSsN2abkiV9gBUJCjAW+DJ09asOKUongpF78EXLcHKV3THkGj1mXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783219999; c=relaxed/simple;
	bh=pyx/79FhtvTLGN4J55OZsGUaNqqP1dzxXF+c06E8A0U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bXMufO/IWFfIASAqwf5OWNwaTzW9VHCHLEzGN+dXTX3TVbihvIupaI7ABnEE7gx0KRgCC2tEhBYYJMX2W88hCZeNgXe8XNh7/BcjTJUi+By4rEZ8zkApS+fedhfftPg0Mr/zlwd1G2M2CV0w0Ga07I5C7CLTXUnYtUrLunvMQ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9ynMJ1K; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9ynMJ1K"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8471013fac2so1960784b3a.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 04 Jul 2026 19:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783219997; x=1783824797; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DCDVv54Ie1lgNDH1K5byCo9c0pHxpB0DY98GerjqU9M=;
        b=A9ynMJ1KwRBVi+5eOyyJzt3qeEd/H68RK3nNexO1mPU3UUwBOF/9c7G2Qhp2Cjjl9+
         khRKZVearwq+/b18c+Ct96gHyEaRN88RmWPPBf4AhJ9FCEE8YMM8b2pPGJgm7302uwmk
         9IDNz+W46RCD0l7W5LME/fqrR0VGxhhjYT3G9IPVfYHlafhQn9cj/Ws0USrHwMIcc5Y9
         Fb9Ik1fyeAKtr1N+1kiKZ/mpmA3+y/lSub+z+turBb+YhRlbVy6XKoQZ2FZqwzISvYUR
         4fDRTjgFN7zfwVdcMFeUoIaWo4hh1GDGddrpEA5yMGFCxWm+zjiXc3vE/rA82uq+g51s
         IloQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783219997; x=1783824797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DCDVv54Ie1lgNDH1K5byCo9c0pHxpB0DY98GerjqU9M=;
        b=r9PEjmvgwGrgogfW4AH0yzMyMtZ5yJmVnHJDJlhVr5+3vtB/BLdZ9xlS8/Hb5pxh/p
         zogAtZ6cMGFD1cOAzNNPpAZQMmqiT8cz4rVCBsDheJssl+LjUSVyj1zL19rFQdM99E/4
         bklFcEQu/nV1T6nkWpFamcUOAYwg0kigBXn1NTHUQ4dY1LIBfsB8qyoiEOv44yAddPsT
         O2TRSPHrqVyRsr1SQ1v364NdHdFLgTiL+DgZLgFM1HNxStXwro6JwkD8AqJt7mu7VNDS
         BN6g73VLW471GDuVn/Bnz9m+/YYGArGW+yI9CBaMlDnPjQT5MVgwlIJAJXHb8lhRBNE5
         aXSA==
X-Gm-Message-State: AOJu0Yxs7UqIqsOPyiseoLJO+b1z+KQvce/okcNpMoRBN1axkit7FwIB
	3X3HnQTtigiYlLn6RXEtrSwOpDE5r7HMQsr8fAcu/fKIWvOpAfjexnQ6KJLc71sMM5I=
X-Gm-Gg: AfdE7cmJCBbP/ymmAkk+arptuQ3kkZTEvYPKMOOJ56edS5fmQAUwenHxtzdVpgX+v9V
	JEvnQFRqfgX8t7x7qGLt+HvOd6AjTyqdr4EPtQBIDbyNQHdkYhcbVxHC20hGcgcJk9bln6WBW5q
	zo+UzJIt3hmOJ5/O+T7eo91MYB6xoWytLcw/4OG2dIzm17o4wq4+TXJoiPeo/gBAQRc2GZ5e154
	eQnWCpwcNeNQB6Yb8sI4F7cO+7YPxIVeMY3AC03qDv8cpbNks9TMl8eqq5bHZcUcVZEdXS5qy2j
	fo+1zbypBlU+7OjJXFCeyxx6xdCN4hwYv15QspOWPN+s23Rg3lkSdjAGh3+UHY1jFLpH2NYMvjn
	R4FgBNWdfrzuO4MCLo1o8ZSM7LjiJ1HOEbimB9btCFrwjGKy4UeVueGaBrU95moouKGdhYrR6KV
	jGdi53m2o=
X-Received: by 2002:a05:6a00:2304:b0:845:4126:222b with SMTP id d2e1a72fcca58-847f6f10664mr5054118b3a.28.1783219997045;
        Sat, 04 Jul 2026 19:53:17 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8bd30ca5sm4253679a12.0.2026.07.04.19.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 19:53:16 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zzzccc427@gmail.com
Subject: [PATCH v7 0/2] ocfs2: validate xattr entry bounds
Date: Sun,  5 Jul 2026 10:53:09 +0800
Message-Id: <20260705025311.3429854-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series validates OCFS2 xattr entry name/value bounds when xattr
metadata is read and validated, before getxattr() or listxattr() can
walk out-of-range entry arrays or offsets from corrupted metadata.

Patch 1 validates inline xattrs from ocfs2_validate_inode_block().
Patch 2 validates non-indexed xattr blocks from ocfs2_validate_xattr_block()
and indexed xattr buckets after bucket ECC validation.

Cen Zhang (2):
  ocfs2: validate inline xattrs during inode block validation
  ocfs2: validate external xattr entries when reading metadata

 fs/ocfs2/inode.c |   4 +
 fs/ocfs2/xattr.c | 215 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/xattr.h |   2 +
 3 files changed, 208 insertions(+), 13 deletions(-)

-- 
2.43.0

