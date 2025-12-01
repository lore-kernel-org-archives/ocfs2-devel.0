Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB7C298CA6
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 07:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764574685; cv=none; b=D5TH7M5BPbgNmklj5OBrRt3bbL6tgdOMLdBXAtFggaoTh1X+17XZFjKgQMBd4FRLdEfClBvJRAcVo6jGResF4V2dBSMvPVvVgHD76r/eOXyofugAyXxq2oPonSxhAa3jW9Uf4jEPgXWyEe+TKa2kwbtlMsOjBTVzK0g3f2Mf1pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764574685; c=relaxed/simple;
	bh=nMH63Z56zfzXEplEcwzH05DVa+x++79fLPO4XppCqHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dOpCiQOUQoNzoozZCRI+nHA0WtZ/cKSDIJZTWO0keMBWg/IUtjlEqkGeHzc7xVZYgK4t7j2ysLInjhCyZxhDZaP9GcrorjUfyx85tWHFBsyedfPElz1+cu/HcEfKNetSx0nabQIvm9EwWpUQa2CLvr311HIc/WL0ORSXf5+m/Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gvdZshMr; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gvdZshMr"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-343806688c5so2860558a91.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 23:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764574684; x=1765179484; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLT0pt6hWb2B67LkFiPmXPfIwT4zlZdzrwjY8PVj22Q=;
        b=gvdZshMrrpClsjBaMkWdGjxDCCFicRfP0/vOfDML6n0IBsFnOxtd4mYTKt/8lQT5L9
         4l5Aq9qc4zN7byRM82qxaoCRB35FS8xR0m2elIsJ4WKAGlt7PCnxdogG+17fxO7YeqYa
         kjZnbLsyIwF14sNVZMT37a/atLksIhDel3K/+nEl/Ue2nbFACgRRHg5zmbgvuctTogzO
         db7e2tCRWQCzgYASZB+CjK6bIGqqO3uEz1sNRBuQl9WLgxDmYj0CRNk5YiHAadVa/8op
         86HCvUXxIZ1JeoJ7oqH662KzAoq+0cSHL/kKyPrPqYM5B19xU4Pyn90qcz2OB4xiDPXY
         CZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764574684; x=1765179484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GLT0pt6hWb2B67LkFiPmXPfIwT4zlZdzrwjY8PVj22Q=;
        b=WgeccI9SfdTT/qujikycTQDyux3Ru+7aRg7WBERo2Z2/nL9UFH9hDulfhTtrQb17lL
         Oq0cNEnkdXW3IdDcl2wBuEWUcNvKLMrPpk8UMHvJGUJ5gHw3i3cYRH9pKySqdThTFkJ8
         1HekYEwzG2QdB7IWW94G8waqUvPIPMh8d2gzYLALvhnHvI8Yvm2BESRPOdG/T7ZCp5Uc
         TOoaDuGCVIi7ce7j+0qq9RjldZOOVJmLPCKswv4i2Dfs7zPCef/YLnzs2e2WzRqmTEyp
         pYRan915+X6ZQHw4ZekWjrzrKRzrcgzw1UBhWZ/1cTTcvysPmjgUOtMe4TC95Qzg2zUz
         rBHA==
X-Forwarded-Encrypted: i=1; AJvYcCVXdfb+6FaJxm7A5ElsUidXb2eIBuEOlYkhlBHIR/lxUNudo70N5ezCeFoz0Mve5eBCA+NGHDQRmM32Ow==@lists.linux.dev
X-Gm-Message-State: AOJu0YyFS0tDpCUGDM++EESpen/ZlRVXtazRM2PdLY0sihCdbpzm2Ww+
	Az+MuOBRjPwo0wxv4sllJtYjQrV+FYe8BE5wf3FzSB3XT7BzSZbIHVM5
X-Gm-Gg: ASbGncvZaPb4JTnfVtyuMSa16X4Qhep4ZiVe9N7enF/1zxXUiqFpRF4ZMjUMeFIsIEx
	Qh4mpi+DHjDyK10awZaiJxiyLBlaglQklkx4LpUvA5kL4hKq8asUiE2JiOBs2NdJTej0LnYorvp
	/FbZ/6/gcPPQ/TdoqXgM7l/S95j0or24hEk6ou2uNAIU6nQKU/VehTnNPTNxdmCGi+Q/RuzMMFF
	eJZCiTEqCmbL1jjONmwMFZJ0uayKsejZheEvm+FtmZBsp68Cp2th7V0mspBP2MCtRUkvi4UIxYH
	sbvOQGw8LfvDDoefEJkLH2sCukx3uKQ1z+E3Ed4zVanJ47+KZ8sgFTcEY3btwEujN/MLRd6nN1G
	xbvFGZv4RYw4Y7Q3ZHb+oI/nRlRT7ERLZlOkfZlGeZ+jLoxGq+3n4qXPXSi2bN6bYnVQdI7zvGl
	XjmnDbQVghfphTFD/d77OuiyBHxT0=
X-Google-Smtp-Source: AGHT+IF6luX5e2C03JrOl9oN7hjrwFVRLCL48dCOr6yB2fZi9oXU68ROkbMLhAbha9ayUb2TCMfLhQ==
X-Received: by 2002:a17:90b:1d83:b0:340:bb5c:7dd7 with SMTP id 98e67ed59e1d1-3475ebe7417mr26390169a91.5.1764574683582;
        Sun, 30 Nov 2025 23:38:03 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm12108159a91.11.2025.11.30.23.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 23:38:03 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com,
	joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for v2 for fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Mon,  1 Dec 2025 13:07:53 +0530
Message-Id: <20251201073753.48638-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <000000000000560ff106204134d2@google.com>
References: <000000000000560ff106204134d2@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 939f15e640f193616691d3bcde0089760e75b0d3

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/suballoc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..f4e4ef08e0f9 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1992,6 +1992,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	}
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
+	if (!le16_to_cpu(cl->cl_next_free_rec) ||
+		le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has 0 chains\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno));
+		goto bail;
+	}
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;

base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
-- 
2.34.1

