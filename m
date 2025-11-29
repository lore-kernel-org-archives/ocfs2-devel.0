Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E808199D8
	for <ocfs2-devel@lists.linux.dev>; Sat, 29 Nov 2025 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764443138; cv=none; b=QVq3lcu6sft+7rKizuEoyxBU7bwP6kgMrkMRTIWlpIdYMX8OUBeSoJ8Gy+JtMGbtnpvWqf2xVvu2I5TNnfoKFdrq3aKCKPpcBoic/wcXLDmBYH0GeRSF6IK9csSXGqunN5OWkahyYJyBZrTKtmIXUVX5uHy3NoVE0vn3+Q2s4SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764443138; c=relaxed/simple;
	bh=6PduEZHtDoyfi/j6RY6Z5HWxa4pjjLC4+VZY8Kc+i9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gxftYy7pBNKKarXDM/64RDo/JSd2+Y7R+oXKr9qMJ4lN1Vd1WPossznew15TNzQG5EiVUo51yJERl31cuPczKetoheOt4l5wqEN7Jph6douReGihfU/kw0eaELZquNifOyFjvmnPQ8iDNWk7ucydJT6QPNpFqnLRj8wIDYualwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DbjWn9C/; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DbjWn9C/"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bcfd82f55ebso1643362a12.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 29 Nov 2025 11:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764443136; x=1765047936; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OdjwNiGIrnIxWmeUPDnAaaorwfoimjeDrP1Y2u1MFng=;
        b=DbjWn9C/CE6Qt7t37nUwv5kbqPU7N9EhFl8Gizb/kO/qB9E7jPkrERlvjlPzAHCeFh
         xTbFLaum+0hCpd4F4OmIR/abciv/oN9aLey2W5DW2iTVzCLWq2msekqqlpNuvGjM19aK
         i7Oxfc0Lxeu6sNp0vlOUiQkL1cC4guPT3IrHFGYvUG3sYROo+VMxObkLK8DVP2e/ryyr
         c53dXwvGtMt+jCXyy3MQJ/v+nO6GWpduzsG5h60o4UWRZ+guRaX4OkmQfZnEMHB1BIJl
         ToveL4P+nFqa5fUg2kUjNlLAGyxYMxQf78mdFQ8L/bXomExftwnQpbX03MsE4c2dEpqK
         +BxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764443136; x=1765047936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OdjwNiGIrnIxWmeUPDnAaaorwfoimjeDrP1Y2u1MFng=;
        b=K0r3JWHiJf8ixYKLzHgwtMtpHrg0Kl4yICfc2k+W5QJfvWoAxSMG3+QFseGo4RIDx9
         8FACJG1Nwysvf2BS2a6UIY9ooOLjCDGGfKOx5DqGwWrxuf0G0J++WA0o+gJmHHxua8zm
         BSmsKxmkUcNne/QuEqRbCvMMwpIAqGKAGAb1ZjZRQGHmzJsYVfjhjpZwhe0paVk9Nuki
         a0CWiKa6r04CyajvqGvkuAz2ZejcNYd/AS7L4bzMvvtFCyvwP65oo3kBik3GrAlbTg1v
         yrSmWjmTmI2wU0ozLHkpB30+YKpvQKKCuVhd73Gel6+63JnjYnVpJmTGs6FJfPi1O4Rv
         VQ/w==
X-Forwarded-Encrypted: i=1; AJvYcCVA01X+V3+0cm5pfEqjpTFksPf6ADHcNhY+3BtqYipg0BARD4gHdfC+dpeq9AypOv9e4SSIl0mW723OTw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxnbXg1TP7gbTL1zf2RKe2Tmf6f0zeeCP5mp8sZn+LPQ0ktADTE
	OtS5aNG43imQJ2RT7fBAJaeUWYogloJQD07GjI8Xv1Ovqs14kIxAYkOXzcIDb/pMoe0=
X-Gm-Gg: ASbGncuqDSimLAf0ep1awqunKw34RTy2b0ivmMCzIezaA01+sOEhHgIDwGR+cIkBrGI
	KHn6j1kjuJwa4oiTu/Vx/npLt2iIov+npUFT2Zw2bVU3aPY08hk0zrdmK26z+ACC+rkzXBml1Ku
	GUjhvCWEzboIwEP9IuP+89tWb/1uJVHzr1n7BtBw6zoYmeZqQxANzGyJ7IbkaS0kgix3B/sUZgK
	+T2P0+HIX/VJSfZYEoj4UtKE3Wge2YMRkr6NWyVe8qkVQSIDgWgOWfsyTnsdoqkGCAgQoI3sG9n
	1gHwQV/hYrItKCJFew58fCGZNGp7SR5GpDmlk1WgsswehCYqdvnkUUeamarHod2Oy+qfCRt37vF
	6/wtmaIiMZgvF0N9FQ6JcBia4zXzoeh+syc+a7VaT/RKu66sWt0hYuwgYJ++WYqxv6IH54IAEho
	ZV7I9YCvLMrgAt95+87K89auc2Koc=
X-Google-Smtp-Source: AGHT+IFz/YQ9z0BWDLojEieM9uNv9TMUDdr8wTYIWfPQ30REnZMevgOAKOcpvDxXTIuwUP9Rm+tcsA==
X-Received: by 2002:a17:903:1b04:b0:295:99f0:6c65 with SMTP id d9443c01a7336-29b5e3d802dmr435988915ad.30.1764443136367;
        Sat, 29 Nov 2025 11:05:36 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb28008sm79853095ad.51.2025.11.29.11.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 11:05:35 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Re: Syzbot test for fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Sun, 30 Nov 2025 00:35:07 +0530
Message-Id: <20251129190507.543570-1-activprithvi@gmail.com>
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
index 6ac4dcd54588..c7eb6efc00b4 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1993,6 +1993,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
 
+	if( le16_to_cpu(cl->cl_next_free_rec) == 0) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has 0 chains\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno));
+		goto bail;
+	}
+
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
 

base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
-- 
2.34.1

