Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872195;
	b=ouxcN5kW5LNhZlv+2qyjO4ocOkzZ5Y/NnOEj7vNt/X78NM1tva4a/kGyu/DNo27W9JfX
	 2ent2a1VyjOrN1M88fiqIApCTo0JEQKUwXm4v00gmpgDkgvNik/xEl8Kvs6Bhubj81kyq
	 PQkhJ4YxOM5XhJMJTKnPCMJSerRJdwz6dD1fMuO621ko+Cd7ZIyC2YlBlZZu+k534w/RV
	 emKzla93HazXCSKZz+2nMi2R3wNogU3M3bhxta3zztUieIG4Mz7Ba8RwIzHnTIIJDj3N1
	 8D7ZgsFue5eDww2ACuwJ0e/MCsFjMGDCxfCvQP+QFEBrY29bo3/Vk09AOJAp28CS+Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872195;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ljQIicNK0HUVF4+og/onCbX4zTFPfDAbmm/iUvXZnVc=;
	b=BGaUxp2/r50HuLWUGk/URjfN3mdjNEzKHs53FMpzDabjIGdBH7ejcmtMG9VaIGWipyeC
	 IpJA277wrK21vySnSwbsrSHBK+Kfqv5QO1VmMseCRz8C/pLwmMQUwpGl33WVVh8tVss15
	 a1KXMb3ol+g4Lin49G4mwS7n/u5X7yXgpj8icA9hNpexOoOfw3Z70pds1KIL4HuDl6v0w
	 Bo2F+HOWYj7PSOA5OjIPbKLoBRYfqWQ+0exIvIr+C2+eOPsoYkhU+JEySfX6mTCSAalxY
	 RdS5u9M6PTT2jGO5zhktxDnuRijdq2IfFNg1nsQ6x5euQ0eDZWEjUmOuJaFAegISxQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Rl+3NA0s;
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95C160A380A
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A95C160A380A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Rl+3NA0s
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872192; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ljQIicNK0HUVF4+og/onCbX4zTFPfDAbmm/iUvXZnVc=;
	b=Rl+3NA0sXg4fIhn68ywjpiqad66hsqRlQCuBWwH9YpHiak1Bzn9BT4GBWjkUw5cG5EplhICWKusNYXed0D13nsmFnYBdz+gBR/D6N8pWxaNozM6f1+oIcuPkS7TFl0+xVgvKvACPC1ac100yjgLoOvd55vxyklWSzjEtzTQyTr8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZg2_1793872191;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZg2_1793872191 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:52 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 26/30] ocfs2: check inline data dinodes in online filecheck
Date: Thu,  5 Nov 2026 17:49:22 +0800
Message-Id: <20261105094926.3203416-27-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
References: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wire the inline-data guard and its three sub-checks into the filecheck
validator: allocated clusters on an inline inode, an id_count beyond the
space available in the inode block, and an i_size beyond id_count.

The size-without-clusters check now needs an explicit goto bail.  It
previously fell through to the bail label because it was the last check;
with checks following it, a later failure would overwrite its INVALIDINO
code and report the wrong reason.

The id_count maximum stays a signed int in the message.
ocfs2_max_inline_data_with_xattr() subtracts the unvalidated
i_xattr_inline_size and can go negative on small block sizes.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index db8cdf4d8627..06b190b00590 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2094,6 +2094,40 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 			     (unsigned long long)bh->b_blocknr,
 			     (unsigned long long)le64_to_cpu(di->i_size));
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_inline_data(di)) {
+		struct ocfs2_inline_data *data = &di->id2.i_data;
+
+		if (ocfs2_dinode_has_inline_clusters(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: %u clusters\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le32_to_cpu(di->i_clusters));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_oversized_inline_data(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(data->id_count),
+			     ocfs2_max_inline_data_with_xattr(sb, di));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_inline_size_over_count(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)le64_to_cpu(di->i_size),
+			     le16_to_cpu(data->id_count));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
 	}
 
 bail:
-- 
2.39.3

