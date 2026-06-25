Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F58A2BEC23
	for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378067; cv=none; b=V52EdsKi2azei2fePEIJILZPkUNz6mONSArJoqgNeTuD/swhKGA2LpUNKWr0rb5SqNEmXi0kgLCdyPx1/IkWccHNL8dVrTvAiDnqhrEofWZWozzXaChAYsuoOlNm6TKDrgmOaMQcwb2Y0QD2ph4G/56+zSCB+SoAj4CDMLgEx5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378067; c=relaxed/simple;
	bh=qG+8UNzb7n1IcZkwZljOYHzy0X8AZwiYkKgSc99r3dE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SVnYmMV73Wzu4NMkcJnTHfOO+fdNsfBxVrpDbIdda8uavkC9omUaVUCpnNR4wBbJ1ciXeQXG4vapVrM5900N0HU6OkEuJZfew5fUfOWF4gJX4jtPaVIhjOuYv7sC6MzoVFXscecs3nLM+9MbkMr7MWwDNP/l5k1AJBLtnZjusHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2Jjz+GC; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2Jjz+GC"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c6b3f71648so18540905ad.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 02:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378065; x=1782982865; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0LKkASNlVuvhKQZtByk6KxhNC77KfLjasF4hXylrFP4=;
        b=j2Jjz+GCgIlpQwpiYglUr2BGVlJKuCK6n2crK2jVl9ooZ2oIN09iPLOut363U0z5KG
         1qcjZQv9O8dbVsv2EwLl3SCoGgnjZR7+minjV0lYkjBSnIi8e6y8AOWXJUEysWfYIyPe
         CEIcVz3RLh3EG7fAQPqkycSQiRIIHO8azRv8Z9MaEtqSes7kis19ER2n4rpeL6D9P+uT
         +kwM1T9U1c82TAe2/5Ud/ZZycfdycY8jSHFzRUlmOfQMmMgYeISfq9fAae/pDqfdYSYV
         hhnTs34FUsXr0fMWygntAhdMNAogOexFXjtZi7PFw4V/8pQIDkaqEH9NCm6ls26Ey+qJ
         zYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378065; x=1782982865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0LKkASNlVuvhKQZtByk6KxhNC77KfLjasF4hXylrFP4=;
        b=aAE3Vo94G1m3Fc41BjpQv7qpnBK6Y3cKB4N9nkH1Ge8GspkTKGheJyc7HKmoyrJhqr
         HLvs2HMEKD1297wv/zTnAqyaVRjwcssl2Kt0fiET5ypofrK92wckq4g2acctHU2Gk3A+
         exVTEs8VMaKBFgYKaISwY/rSt4YEj/GQDsnD9G/NPoA+Sp7cVFtFhItzTswXiPtxYROg
         tRCf/fJet8c2cZ2I8X2eVOmFc+xIUqyl0+7rvycjaZXqlP3NQCMEGH7Ei+kjDT/iv8/g
         i3mnuXDXBDVQBW8eVdJ8pWeeYq/QwayDKTgebd8sLyVJvHYn8E8Wnvd7MUshCYG0mwxW
         SxTw==
X-Gm-Message-State: AOJu0YxjMsN55AwDtTuWklRwvDON9X4dW00M6f44Wsi1ss97uiQ1QvOm
	f74zPVIIbxLycZ1O9+xzcZetufobW24boGdud4FmNn5LWKJyJJinlY3p
X-Gm-Gg: AfdE7ckcsAzPXMoJgI5wL+Yr6+XI6JGiwDGGkiMotzvqP4OYP04X+KDib0+Gwop7H8E
	6qF+mj0zCfcJHAE4/d6bmd8zRSWgDVHvJ5TqOA45xH7zEc3VHrtI2e+1+2dg7Zszn1vQq1e1SQM
	gX2RuUJaUbx9hBk+YJLRvJbBys3Ixym96dnx5Cbg6dbatlQBsletzkWS9olfl1nFAQjUuryPJcj
	Ub1dn9Mnj1y0nQnP/Up+pWzeNB6lq6Pq+24+w3oHEFKO1a/x+OsSwzSyO22/JbwaEg5YqqGdsjK
	9oeJoRtslGHhM5WuN1keBHY6IiJcPFyowksnHa4yxRjudtzg+zRxdIdAvRIEopYRhcGJB4TQfzO
	ToiHEc61F2+gDIsS8uQ04L9gFIKXMaRC4X6v3QFrMqCfAF+mani7dCPz6k8c39qdWuGREHoChzP
	ZyryIW3Gw=
X-Received: by 2002:a17:903:1cb:b0:2c7:f227:58ee with SMTP id d9443c01a7336-2c7fca717bdmr12865865ad.22.1782378065269;
        Thu, 25 Jun 2026 02:01:05 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f6518bb1sm15365715ad.84.2026.06.25.02.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:01:04 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zzzccc427@gmail.com
Subject: [PATCH v5 0/2] ocfs2: validate xattr entry bounds
Date: Thu, 25 Jun 2026 17:00:58 +0800
Message-Id: <20260625090100.202881-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260622130332.2094018-1-zzzccc427@gmail.com>
References: <20260622130332.2094018-1-zzzccc427@gmail.com>
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
Patch 2 reuses the same entry validator for non-indexed xattr blocks
and indexed xattr buckets.

Changes since v4:
  - Replace the descriptive string argument with enum
    ocfs2_xattr_entry_type.
  - Drop the new per-operation full inline-xattr re-check; operation
    paths keep their existing ibody header/count lookup, and full
    entry bounds validation now runs at inode block read time.
  - Simplify corruption messages to rely on the corrupt block number
    instead of also naming the xattr storage kind.

Cen Zhang (2):
  ocfs2: validate inline xattrs during inode block validation
  ocfs2: validate external xattr entries when reading metadata

 fs/ocfs2/inode.c |   4 +
 fs/ocfs2/xattr.c | 194 +++++++++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/xattr.h |   2 +
 3 files changed, 187 insertions(+), 13 deletions(-)

-- 
2.43.0

