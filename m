Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8C22F9D83
	for <ocfs2-devel@lists.linux.dev>; Sat, 20 Dec 2025 09:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766224183; cv=none; b=VwyA1d4qO48BlPjeKms3KWAw0ok2MwVLhbIszZWHnirEwkDdOHhM52OLeOwiodWVnfpJTomYBrg/n2bBGX46iDwuuZDPiXf+PQbLFZDys7SyjqejZD3hpc5Ql5ndURF7R0Om17eD6jhPWK2WjSABHrQ3RxqJBT2cMgiPDeU4uV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766224183; c=relaxed/simple;
	bh=8vPBBIVGC/F5q2+wWMM4e4vlGTNbzIZZ4fuMbWYwOnI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a+s0uUtec+WmYzHJUHelTapI/iTJ7YjEQxHGB6BQCshaE599OVDSwkbCyEhVrxR7pfxGEY5DIRJo0J3FdJ03Z712PPhXrkpsPeZcIDaKge0GBteDwCme6on5WMzGOu9ct7Hca71ldZApWm6XAFVxawNlgWXfSqbTn0lT7N7F+80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OamRB6xJ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OamRB6xJ"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso27837885ad.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 20 Dec 2025 01:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766224181; x=1766828981; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j7IJxF6HMphYNWv4fklqBcjfxDWSKokfkAddGStMOYE=;
        b=OamRB6xJx8aDqyt0dlFnqbCSqfgaByjZD110wjFqKp5x+VDqdMb0le/lAaWlqVsHM/
         cIzGnNn9PROSaY1MCjthhlcEFfMBU/AyrzPTQ8atIAXX2hDnmkEH6GB1D7TIsL4njSLR
         YkQkNS9wdsnjoCdFNFxSItzSMe5NfjwjLPNJGicE5gX+J1i4y8s9sJQ9QyapJDmcgV3V
         57cQPsgXc9lLdNWlTd4r/GUwV1icTqSF0NU49VtDVluifiFLezYvQueTGVUTmobbvDbP
         PFm4I4nXPFUZ4r2RJJleKa4wrs9Ers9fpplectDEwlG7zNKUnuItRMZt1huBpL6oVLWI
         0GUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766224181; x=1766828981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j7IJxF6HMphYNWv4fklqBcjfxDWSKokfkAddGStMOYE=;
        b=lWUiKeHOsVDX6z40ggDkrddIAEy82lVwpIKYBM4pucuelkTs3PWEI9ctoFlEjOFzM1
         yP6sLlfnz3hMbcE+qjVcODVUv7GyjMli7YRwZg1jpCP6ENjvkDeNqTz4IMhhUahmgK72
         uZXpGED7i8dUFWGvWorGVwuXJEuRvz0SET6dH/Udd9t5PKTtVeedlWPbgxDcwSoRPeoH
         IpB+yHWeHWtJ4cW8DwKbY9QYUQFsCJ0KFQb2df19JJwhyosGjkCVJsrbWl/nbidKOYCS
         Odd3DGqMVoBNTe7uRwQoPnVCfRSEe6r1pKTSXfSJwmRxJPTCHniw0cXHTlfzbX28n272
         BssQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqYEE2gxht1pUCj54x5ofPs2FB3U5vMHbQN3ifavP+zmjPfzzZIkbst+u6B9Cd1x4HeE2IhGSMLIPL3w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzxKSQ/UpMD6HPKwc7q+tfXvnhE1hhUp4WmCddfY0t5XGMDkvNn
	H3ToQpFQGZlHnJ2ndsMdpZDfQYLM9h93YA3KVg28vf/3+0eT7XguXReF
X-Gm-Gg: AY/fxX6hLAMvBOEzJAjtZxgRXcFzqkwV/A6Ra9m1Zn0sfV/QvxgmXWaVKCo9+e71iMb
	QkD5/WdzIY+vUlTBVvl8sxDzLT92qokjyLGnHwxggBT3r7zGV+7+ByBo0I3qBq7iou8A7cQPzqo
	cWM26adOVzJ3QejGQkgwwYaThR1Oj3pIe8tQjR72uZHX2AfN6Cyu3kVKZPBenIPhxxVtiH2o5YY
	9y7sUgRzsN9Y4OzrRAr3BB0cdBuyHuS81M5mF3nV8n7vgC3WN6ZPsE+Fq1eT77pWz8bjwxwEN4Y
	NoVGKXg/FOfqimSO2kBpHZ7uCYz1R+HJJLuGtk27pbA+Q+BRScRF+ozp/x+IK9Trbu0znEx7I+F
	STUW/6xYHcYWY26EZ9PIaNdepf5dQl7N5VSaelSyxPld3S6n7GTwXOr/wBB5udfPrYSYfH6aLkx
	wsHVWOEq8qDRX+WOPoElLB/TKdgOck
X-Google-Smtp-Source: AGHT+IHMytYlzWCq2SFmQytqElgOtJeFb21rSHQ0neO72vPgyAQ4/pAf5fT0MOb+oYKbYoeapmzQNg==
X-Received: by 2002:a17:903:38c3:b0:269:82a5:f9e9 with SMTP id d9443c01a7336-2a2f2836764mr57108345ad.29.1766224180679;
        Sat, 20 Dec 2025 01:49:40 -0800 (PST)
Received: from localhost.localdomain ([111.125.231.172])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c66bd3sm45107635ad.1.2025.12.20.01.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Dec 2025 01:49:40 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: Add check for total number of chains in chain list
Date: Sat, 20 Dec 2025 15:19:28 +0530
Message-Id: <20251220094928.134849-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The functions ocfs2_reserve_suballoc_bits(), ocfs2_block_group_alloc(),
ocfs2_block_group_alloc_contig() and ocfs2_find_smallest_chain() trust
the on-disk values related to the allocation chain. However, KASAN bug
was triggered in these functions, and the kernel panicked when accessing
redzoned memory. This occurred due to the corrupted value of `cl_count`
field of `struct ocfs2_chain_list`. Upon analysis, the value of `cl_count`
was observed to be overwhemingly large, due to which the code accessed
redzoned memory.

The fix introduces an if statement which validates value of `cl_count`
(both lower and upper bounds). Lower bound check ensures the value of
`cl_count` is not zero and upper bound check ensures that the value of
`cl_count` is in the range such that it has a value less than the total
size of struct ocfs2_chain_list and maximum number of chains that can be
present, so as to fill one block.

Reported-by: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=af14efe17dfa46173239
Tested-by: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/suballoc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f7b483f0de2a..7ea63e9cc4f8 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -671,6 +671,21 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	unsigned int block_size = osb->sb->s_blocksize;
+	unsigned int max_cl_count =
+	(block_size - offsetof(struct ocfs2_chain_list, cl_recs)) /
+	sizeof(struct ocfs2_chain_rec);
+
+	if (!le16_to_cpu(cl->cl_count) ||
+	    le16_to_cpu(cl->cl_count) > max_cl_count) {
+		ocfs2_error(osb->sb,
+			    "Invalid chain list: cl_count %u "
+			    "exceeds max %u",
+			    le16_to_cpu(cl->cl_count), max_cl_count);
+		status = -EIO;
+		goto bail;
+	}
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);

base-commit: 36c254515dc6592c44db77b84908358979dd6b50
-- 
2.34.1

