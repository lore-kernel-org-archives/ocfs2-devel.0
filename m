Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E647A2C08D9
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409270; cv=none; b=ojd3ZJtwDjcvOZ5kQ6O5Rm9ErfMb/mAb6xpVkgbhdbGqV+XLG+0dRktrxjzJRzSyXToCJ1WrKsYsHs7LA1Q83T3KlJHtzGCyUkjm4sIv0hHjlV1gVaHsDvLqtYOnqxBeUccJ89xnWXexJ8T6TYJydjSnrfvCQLfhyBDkEQU+0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409270; c=relaxed/simple;
	bh=eRFMjyzp2oGycBxV/BqaSJ27ZRWUJFSdWHeBZPduE80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZX6Wna+pTOZNvAjLLrD3AEv1C5efQNoj1I4urDJ8DLahRc/gXlCAtqV1lLHS6FHXTpWSUMPA6zvnMNAB9fGsjdGydIHIGkUP+bMXVA2gTTqsKllYV93T5Vofb/PVXjx205n4Em4itEXqQrDOnYel5O4amufVAlNngnJHnujIZIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gg3xvysJ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gg3xvysJ"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45cb6428c46so47576835e9.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 02:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409267; x=1758014067; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGeEYXDQB6umQx6HKeL3+YR9XaxrRRDu5k2GywHVd3M=;
        b=gg3xvysJw3tQNZidNdxAKj5eDEmmmnuTPcaNXVymwClrNrf2/HPczSpZ7fp7m1w/ro
         a2srDV/yXgtzJsRcfJDmZcz5lZB85j9hd6kzOQwDqTdvJ8LVHkG4AQAGz9F89ZnUsQCC
         uxtjfeFZFtgy32VZN2zdEIVftDRku9y8dhtfVZ4vghPBGAREJGRxAjoqpx3lsdpi+Qhj
         TYpP/xPW2G9diEb6ns3FCv/KVxBYTmDLHmHIx3r09ygx/gMhGmfiEcR+X1212/8H9qmr
         TJjnBbbMuPPV/abHtouqGWJwkDCErOwgN0hPxBwCQW5zYt85nmY9XS6fcvJZZ5jBZEyS
         6SBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409267; x=1758014067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pGeEYXDQB6umQx6HKeL3+YR9XaxrRRDu5k2GywHVd3M=;
        b=ViTD2BbIuQBQVY6BwVnbcTYE4Igfvy76SJljrroIPjFPNJrKixFy0T1JEbeWm66U5G
         tdVM00u8pMDwkN7tM8rPmR/VxPGiUhZsZ4wFbRdpt3ekI9rvlhuLM4AUBVk+Ui7nsBrn
         PY47WOjMk0pE/8npn6Z2Aym18KZSaD5hm/ARA4h5LdVbi6vI/FkQk7qnILNDA3nFlVgp
         T7C24cnMSXGQA5LghsLsNobKZOMAEa4qhQAWLsius1vVR8YvOg2twl8zYkCcdnGxfb0Q
         emxxfxtukzjuo0AeWOarxqWf/y4WieGyEmUpm6Pt0AgWSC8uOQrPrpEnW7hiHKsRd67X
         /RVA==
X-Forwarded-Encrypted: i=1; AJvYcCXmN19sV40kBI9qF4qCsv2he+DVg2lAhcMskIQnXU/OdX2HT9bMTcKReixYDdSeT9Nb4sxrtCVtMJ30ng==@lists.linux.dev
X-Gm-Message-State: AOJu0YwuRhtiNNH8pN3jCam4/WMj++KdXPDSpOjp4egDdL53GjTS6dxb
	F+T9oxHNX93SaoPwuIIkXHWZAs9FIe/Y8/VSKvCMqM/nXRUuJ2tPi6PH
X-Gm-Gg: ASbGncvpxxnoeDiz5d+K2Cyso8AvAo/49EkdMa9u9/dZS+CgFtvZS1oZ0Yf9R/TqmLs
	CCXDeVpMEF5RIfJ2MmNCoqF2jt6vJy1jc9FeImMmCdsaioABVUBpk81X6vnrMlgWpQ/Gwk1BZUp
	cVKcsHcT0iiqlF3I2yDduiEGYhP0d5gSP3OnyiKj5eDxxOKdJlU+QbZq2W9rzortnpmj/pYIcOj
	RrYA5LCPF3hIsFv12lER+D86wb8heH98A/Q0Ar3STPAulpq4sEgREQcu1TAOGxzZAo2FcmrKkZx
	XQt5d3ow5zg7XuOdIWuR1kxCOzlf9jw83B9r1dC4Ri4iOrmUeKSQUZouew7Mwzsl6dKqJ2ZAs/5
	/FtyesH3jW0ZGSxEzIQ0h7o86aE/MpVZVFd6ZpETd
X-Google-Smtp-Source: AGHT+IG73BUdVqF7npmnaqNpM6L2M9vasLYgSIvBku9zwGGD2nanT1deNZNWSqsd32FJ9AMUZgh3Vw==
X-Received: by 2002:a05:600c:1f11:b0:45d:db2a:ce4a with SMTP id 5b1f17b1804b1-45de07ee7b3mr93383135e9.9.1757409267121;
        Tue, 09 Sep 2025 02:14:27 -0700 (PDT)
Received: from f.. (cst-prg-84-152.cust.vodafone.cz. [46.135.84.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bff6esm1810784f8f.13.2025.09.09.02.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:14:26 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2 09/10] fs: set I_FREEING instead of I_WILL_FREE in iput_final() prior to writeback
Date: Tue,  9 Sep 2025 11:13:43 +0200
Message-ID: <20250909091344.1299099-10-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250909091344.1299099-1-mjguzik@gmail.com>
References: <20250909091344.1299099-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is in preparation for I_WILL_FREE flag removal.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 20f36d54348c..9c695339ec3e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1880,18 +1880,17 @@ static void iput_final(struct inode *inode)
 		return;
 	}
 
+	inode_state_add(inode, I_FREEING);
+
 	if (!drop) {
-		inode_state_add(inode, I_WILL_FREE);
 		spin_unlock(&inode->i_lock);
 
 		write_inode_now(inode, 1);
 
 		spin_lock(&inode->i_lock);
-		inode_state_del(inode, I_WILL_FREE);
 		WARN_ON(inode_state_read(inode) & I_NEW);
 	}
 
-	inode_state_add(inode, I_FREEING);
 	if (!list_empty(&inode->i_lru))
 		inode_lru_list_del(inode);
 	spin_unlock(&inode->i_lock);
-- 
2.43.0

