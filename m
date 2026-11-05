Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872181;
	b=KYYAaeO/N4D0gG0qBwETfetP0Za3N2CfJX18I3lAb1rPqlpgS0qQFhafbiwDaykqJaEz
	 GPcm0HnomwGvD44WsQnuzl3Cw1tPQXatEqx7arP+80o3NUCnAP9sn6ZNW/6J6auMnzsJT
	 Wb5091MuXkTqYQX6kYKlAuBiUDTcoTsiqDXux9JrI7St4hf7T50F+QaGwgHg1lOxpcyCi
	 v90ZduLYV/P+WLxLAyV5Dotj18rL/4bVf/Q8NsUFN86xfuCO3+x/T/AUj7zTTj9vQIrbj
	 jKZPhloQn8rwrzPPk0NVU+ZghFalG4elgvVP0wZCOO+vPnqbGZcj6IaFZrlQvwHT9lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872181;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tslu2xeIoN8JfK796gR9Aw/uwGqtiUYAtBcCuc1sU4k=;
	b=Za942RWlIRN3m6SV4pRHiObJ70VCEQnw1L5ZENYECask8fP1PoSVChAjuDFamhoXsWUI
	 DTWaXNOWCVCaJrLT68JIvzY/cysASllbml4te/BA+Okq2aIIHq+PSbYMHNvjbmQ4ixPzJ
	 JKVmp8W69lJUY9NSHp2nGKlHYLAJsXHz/bJ/Iv7oZ3kvewonqkD3lnyssa7gvwpNc7u44
	 a4g3OBjJvSgmx5Rdj/pD7xpzL/bnojh3sNi0Jv4jc0pwyhWKy6zyfP51kpZyTfUhZDxQM
	 eR3/v3US+YkCee4+3TpdK0mMCbuUkK9wEJ05Rg28TCbl/spjozQf0H5cCMXx3XJkFYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DuuYfwLX;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8263606D80F
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8263606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DuuYfwLX
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872178; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=tslu2xeIoN8JfK796gR9Aw/uwGqtiUYAtBcCuc1sU4k=;
	b=DuuYfwLX/othlt4WICIJlTtaJni7LC5Do2g/+hkgX6lrLInGJlilwYJ/ch1qwWp89n03ZVPkglm2pMImPewqaj2gOnAFIVMTDAhPzNUOWgYbVEMTKjesH0D0JK+dF1O2tppkR8z4gfyhSuwe9ekQ2B3YsiRalcnq7o6iii2gXXw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZaP_1793872177;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZaP_1793872177 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:37 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 11/30] ocfs2: abstract the inline data i_size bound check
Date: Thu,  5 Nov 2026 17:49:07 +0800
Message-Id: <20261105094926.3203416-12-joseph.qi@linux.alibaba.com>
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

Fold the i_size against id_count test into a predicate, completing the
inline-data group.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index d2fb111cb193..db2a67543c7d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -177,6 +177,11 @@ static bool ocfs2_dinode_has_oversized_inline_data(struct super_block *sb,
 		ocfs2_max_inline_data_with_xattr(sb, di);
 }
 
+static bool ocfs2_dinode_has_inline_size_over_count(struct ocfs2_dinode *di)
+{
+	return le64_to_cpu(di->i_size) > le16_to_cpu(di->id2.i_data.id_count);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1758,7 +1763,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 			goto bail;
 		}
 
-		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
+		if (ocfs2_dinode_has_inline_size_over_count(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
 					 (unsigned long long)bh->b_blocknr,
-- 
2.39.3

