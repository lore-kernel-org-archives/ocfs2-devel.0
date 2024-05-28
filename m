Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CE771753
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 May 2024 12:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716897728; cv=none; b=n5iEk3zK2aovXVeT6aYMhDUtO6vtU32JyTF1/HxlyVjXl3NDjsMfnrdU3jOwgGhzu7cwe9sLWlj/L9JRz7iYuPViXBt0ZFbpLxF4Jbr2W0grgrmvxllNIta9Yom9JtZEeEyf9NYKS9l6jmtuwTmbPupi6EJXZdEWvLe6czhn6Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716897728; c=relaxed/simple;
	bh=KmPMw1YP4iTEHPXCxr/7IX4DfBeT1f1I7eZOMJUa8HE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H21hDlRdgeg6jhqiUMPjXoL+4Qq4pnD4u05ebOPKcv8fYscedtDRFklVRlXgHboD9qq+nEipThSUJecVjkzoaTLkUdFR6iroQvbZMOGZswDhgyPmhRGwUutPEZoPcGfxMJJ+eKRRgULJfc1Dt0QdSvYzuwIClM640Is++cC6SIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9pq+g50; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9pq+g50"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6fbbd937719so533889b3a.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 May 2024 05:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716897726; x=1717502526; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k/zAQPqNqZCi3VD/hLNFWLQmglumDosNwioeowNlc8M=;
        b=A9pq+g50E946XEUm734N5wjMD4FrgjalG68K08PE746YBucdp5blMmIo8Rn6Xzr6Yv
         og2f0kuE2rWozIhFTGYUQe8Yke5YCfv4McOzkLEJ+GDNnzHuSGwW+6zGefyVGCK/zaMH
         oqRP1e2ZkT2sZJ/mT+qKrar333TtSe4IZ/0Ehx3x31CawiCL0BMLfWx1Dnm85IIO0GiM
         0eNrsr+3eKS9SIRb0w3dIU8xzBLkkrnAu8M7KTRkYfTucg/D3SQnnBGLot69TNj8K+U/
         SH1Us9V5g0UmAREHR4jh3PfLh/vJ/R5hcwuuAHTHOMn5N6RqcycTYZ4eBh3W/L0vQFGz
         t/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716897726; x=1717502526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k/zAQPqNqZCi3VD/hLNFWLQmglumDosNwioeowNlc8M=;
        b=Sa3guepMR7lLz5C1CDQxu5wkZaCuONXL4ZKmQLfCihBom/Tjv1fcT6r9NqxyRA6NnE
         VfjHkuHSWqPQUIVAVyrfpSnCHnrKOWHI5YaMyc2gGEbBltoyO1K8KzhV0hNVK5+BUREe
         Yl+CdQl8mmlagJge2j/P8qGbNS6E4w9PDWCIsZs2IOk2m/Vgl02nJ9Qutb9n1BI5WJ6c
         FtTFCDgVc3FNhxeXe9DKYbGYPtO32nmskjQVSMSiuMIW5ZBHKGV26h17pGL2hspsqoCP
         Ezk7h70bdKDc7R1wH+DwIHmKR7nVDT5Ya5hss3M4zpmZiJHLTj4hccKzrCaEIEoG5ppS
         E3lg==
X-Forwarded-Encrypted: i=1; AJvYcCXI4CJP7kM4vRw9da1bcD/JY/vn9X9aShixr2i72dOybesJ6Bv97bWVAyDW3tX1ajEOtzcHcekkhrEEMggV5Be2HlytatTf1KHxdas=
X-Gm-Message-State: AOJu0YzWaZmBVibkhWAEk7QXG6ODdEUSZpKLaUJY/9y7k13YANsiSy+x
	muqvUW1aLieWcTCDoreZ1wHrD9vBxMrwZYtk19Lyflpjwerk1bqS
X-Google-Smtp-Source: AGHT+IG8bNy/GlESLk0peHJuJiL6T37jK2OEAhmbOl/iccEIWlrSRcQ8ZlSo3DAsXOgk+oEH4d61Eg==
X-Received: by 2002:a05:6a20:9688:b0:1af:f875:63b0 with SMTP id adf61e73a8af0-1b212df0513mr10775633637.48.1716897725894;
        Tue, 28 May 2024 05:02:05 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcfe6cd2sm6283209b3a.162.2024.05.28.05.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 05:02:05 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: joseph.qi@linux.alibaba.com
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev,
	lei lu <llfamsec@gmail.com>
Subject: [PATCH v2] ocfs2: add bounds checking to ocfs2_search_dirblock()
Date: Tue, 28 May 2024 20:01:40 +0800
Message-Id: <20240528120140.15550-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check to make sure all members of the ocfs2_dir_entry
don't stray beyond valid memory region.

Signed-off-by: lei lu <llfamsec@gmail.com>
---
 fs/ocfs2/dir.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d620d4c53c6f..56e2f8c62106 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -352,19 +352,20 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
 	de_buf = first_de;
 	dlimit = de_buf + bytes;
 
-	while (de_buf < dlimit) {
+	while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
 
 		de = (struct ocfs2_dir_entry *) de_buf;
 
-		if (de_buf + namelen <= dlimit &&
+		/* do a full check */
+		if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
+			ret = -1;
+			goto bail;
+		}
+
+		if (de->name + namelen <= dlimit &&
 		    ocfs2_match(namelen, name, de)) {
-			/* found a match - just to be sure, do a full check */
-			if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
-				ret = -1;
-				goto bail;
-			}
 			*res_dir = de;
 			ret = 1;
 			goto bail;
-- 
2.34.1

