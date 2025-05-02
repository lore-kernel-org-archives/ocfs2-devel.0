Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9CC25484E
	for <ocfs2-devel@lists.linux.dev>; Fri,  2 May 2025 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746200296; cv=none; b=SM8Q2I+UiT4jmkRcFv/VufCXlaxn1z64MUefuKL+5doinh0n7or5M+C13wVaV8U5VNKyXJGWhRJgtx/todJE8fDf/OZpxxuJv62Z/SpSfIzbSIo24yCN4kyaraZURFTxGgOKf6oGOGSeYeMsP05TUmwqiylcUhuf/GVyvT46Us4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746200296; c=relaxed/simple;
	bh=+EbFaAul4sYbEwIMXue0ZrWzbKCgLDgm9uvsMI5mxIg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rtQ1uZ6SKoNqUYAHGLp1iHGbqF9ZbrP9Df2hmnBPk4MfV97SrJJoKblTi6SU+keXhJKZJnLXCIR9cjkJwHqvhcCHehJk0R9/YkyVnxra2l+baGyynIgGSEmDLEpa12v/JV1VJdEo3Z9eEjwwp9yebW++cE7Z/aj9Y6Xel9wwLfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ULibKHNS; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ULibKHNS"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22c336fcdaaso27870815ad.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 02 May 2025 08:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746200294; x=1746805094; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NLBKIU7fLn783vyRrwQ5nLvlEI11nNGPE7lwiiP5H4A=;
        b=ULibKHNSImW2X9ZNZnibYke1TOijhWi8KNF9RjhejEoWjSOc/KFArP9un1xoTMTkIM
         RVvIM6CdxADSS/wnheSafC9zF+Fq+XPxzckosVs+2+iDXZcQx3RkvoTplUwESqweAm/+
         9qesmXvzqnQJvhwp/a3q031RomRiMBgqKbsYacxhb2Zyf8GnkUQnJFproMpB36S7T52X
         CFggED5W/oSDJeSZGVhDs+U6O6h5Sig5ivVwhwR04w2zKWRMRGuouV1V1qEXvsErTwoW
         IIphL3JEs2UQjixga5FRMbCzsshZs4XitN5tVUBRHYeyNMoeuAGUZfAjkv63UL+PmmEJ
         Vj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746200294; x=1746805094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NLBKIU7fLn783vyRrwQ5nLvlEI11nNGPE7lwiiP5H4A=;
        b=Jp4YsmQ14xyyOYPAf2a6EX4GM5Fb4zu1uzXjRqE8GO1YYZjocef+OlEX6lL4p6C7Eo
         hAvBDYvmaUGuXHboc+pmX1Zbv+3+DJmsrZpRVLPupawSVYBAbZ1UuJrFTePOhUw/+944
         lsdig82Y+20u6FEiz0FuJYpc6gP02O9qMoI+m9wz5KiEl+CiwGtXF2xOrnKjqkF0V5A8
         +w1u3LjwbFMmzV2ojaJbOeG+2B02POa6uVdBFmpNFZMOfWF7RsN1r+GbyvZ9Z7NBCPHc
         uuNNdfrOsndNatBqtMwfCGSk2D37w0uf6sgzTOLI6CZnMcun0vT8Pi8YTjtl9/zyk4XV
         jNbg==
X-Gm-Message-State: AOJu0YxVIBn9gtouA6vD0AoXoUSExw1FHYwV2f5gLVVPRYBsHXc/zfr8
	KpHquUXFW4PAxk1zMwTXM09EieuY1F88Zg7IPejl3KFMxaYu8clT
X-Gm-Gg: ASbGncs4O+MhDecJezpqTGgGfewSWzfGvT7DoVpj/uPvy6rI6n18PdcDBWhm8QogZgy
	REkt1Qek4mBjcrTV4qgrRgSe0OfOWhOmYbHMwQvVFHm6u5V00+ibjQ8h1gAJJJXaJwiMdh+4yHi
	Xjwb/bvwKZd7MLnyHMk9hARtngbCLNAqdZomRJsmJWRsoKPSj6evI++EA85ESQYfxkBXpfSfAdD
	w9BBExwkozAqYrl17Ud7jU8+UO8Ouc9CRCtczn/p0ygbQYBp4m+b7XQFRpPEvKd74jvdGalNKOA
	9x2PSd6aHWyEeWkosjJ9aEJ9lhrkF84b+OVgrF4UBQO4qPQ9a7oX9m8vWqmklBjpOpuNNIQtGTj
	yf/u9ZAZdiJpkrAhMByqi
X-Google-Smtp-Source: AGHT+IFajp66gmseTOYhGIHylGu7DHbckOMLRN1NUAWSX3WFhJmt3yida5qoHACmAJMFYibLqqQzAg==
X-Received: by 2002:a17:903:1450:b0:224:122d:d2de with SMTP id d9443c01a7336-22e1031e63amr51321435ad.16.1746200293619;
        Fri, 02 May 2025 08:38:13 -0700 (PDT)
Received: from localhost.localdomain ([159.226.94.129])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3924dd2sm925206a12.14.2025.05.02.08.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 08:38:13 -0700 (PDT)
From: Zhiyu Zhang <zhiyuzhang999@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	gregkh@linuxfoundation.org
Cc: ocfs2-devel@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhiyu Zhang <zhiyuzhang999@gmail.com>
Subject: [PATCH] ocfs2: Fix potential ERR_PTR dereference in ocfs2_unlock_and_free_folios
Date: Fri,  2 May 2025 23:37:42 +0800
Message-Id: <20250502153742.598-1-zhiyuzhang999@gmail.com>
X-Mailer: git-send-email 2.39.1.windows.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When allocation of a folio fails (e.g., -ENOMEM), ocfs2_write_begin_nolock()
stores an ERR_PTR in wc->w_folios[i]. ocfs2_unlock_and_free_folios() later
walks this array but only skips NULL entries, thus passing the error pointer
to folio_unlock(), which eventually dereferences it in const_folio_flags and
panics with BUG: unable to handle kernel paging request in const_folio_flags.

This patch fixes this issue by adding IS_ERR_OR_NULL() to filter both NULL
and error entries before any folio operations.

Fixes: 7e119cff9d0a ("ocfs2: convert w_pages to w_folios")
Reported-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/CALf2hKtnFskBvmZeigK_=mqq9Vd4TWT+YOXcwfNNt1ydOY=0Yg@mail.gmail.com/T/#u
Tested-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Signed-off-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
---
 fs/ocfs2/aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 40b6bce12951..9e500c5fee38 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -760,7 +760,7 @@ void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios)
 	int i;

 	for(i = 0; i < num_folios; i++) {
-		if (!folios[i])
+		if (IS_ERR_OR_NULL(folios[i]))
 			continue;
 		folio_unlock(folios[i]);
 		folio_mark_accessed(folios[i]);
--
2.34.1

