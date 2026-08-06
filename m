Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E1B3A785A
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035567; cv=none; b=kc0oq8Dx0ff6w6ubJLLYt9NQTdhgxRMNiZnR5CscbBsxJgmdO7IoLlFQ/J/vP+LPhR1jL8uiIwnsTg2zi5w4vkpTK0cemTkXdq7dTsnTsMWjD7IEvSJ5Z8m83LtOsHVeQQeLgdmFMiIJnXH/Xso10VF+rnja4cEN0aL6Dg96SEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035567; c=relaxed/simple;
	bh=kuaP2Ip3RQshQpbYi/ZOrxn5Jrkw64bBBtC+6NgGKu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCLsDq0uWNoDK8PQ4u/+Bfz/FrBeJ9x82nGvW8uMpqB4J28BBvGicrAgFTHIbYhxihkJ6mLwyaOm3bKyMMYu3zxnF/25Ck0ZaZrcaVFOy4HV+y/vlA+o8d0Pim7rgMILRbLSfQs2Zae8v5f1JR9uyR7lCkpiPaSNLFwSlOkC1B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lnE7ErTy; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lnE7ErTy"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5c38565e774so713833e0c.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035563; x=1786640363; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y4mp7C2u8iNxOV7vEnH4xyJiQARLq+7PYATgmrobvgA=;
        b=lnE7ErTy/cGIf9vaCRh1sKDh4mtPv9NwtI1Gr17pky2fIVG8apzCqCrCA7XVLwtDME
         VyIdMMIfc2G8ZiwtbzVxfzmoEXUU4l8Dw6F6Wtdbbj8iyv8uKiap3bytkRhzio1oIig1
         f9+gzj5Bpx/RDUnTEFqwhOQeNZiNqOQpdAFEO/x2pW+hZxRK7UcYAzUbmVqOcL0zmIni
         nIbU1TnUtCDLeCcMmfk/2ecV7DMekGu9yWxWEmn75xiZGXb8rxYoVC6U81d1DnTlMM48
         78OvWFH2xFiAPYrTmxfiIQVi0RQO4OpP++Y5rD18EUszOS/WuOrr1++osbaH8sj30UuW
         oMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035563; x=1786640363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y4mp7C2u8iNxOV7vEnH4xyJiQARLq+7PYATgmrobvgA=;
        b=ke74DTCrPSEM0UfCAJaKOZUwNR0HS887Txlehi78SrsBGy+Q48bWk6Ek8YW8CoZYHV
         bTKj4lvmnlgJzT+/MLiLIiQ5YjcRLmiQtQkhQhd8gC+7rT1i/qVcxOm8G1AjZ+W3WZTE
         EXR6jdkWzvDTkL0JL2FNHR4joAz5GQNd+YmZCgbTjhID2YEEBO0yuHgWZk5wghkHEjLD
         wsBsfs/VdhZxrOKKzakdGoqRMAEgtBD2qDcK2ShRzhFxK4ZFu0ICoSPHF/xYgYkV6Jf4
         NV2OkxaLst+dimHxwvHYfXuV816dkmoh/JwlTkuMDNumvo+56s2ehlq3CnzC2sJt0Eiq
         jmuQ==
X-Forwarded-Encrypted: i=1; AHgh+RoIbQ0ewPp/Wz8TKpJQa6cd8ArzOVq4cK2KYsrEzQO0cp5l4JHjhg2ottaDXNCkg/9tV1ylUWGPMz3tuQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyEHFY2LvWDmjohRIPxUpYHd7L+da6pJuMyN5WRHIvUzA7rHBlp
	jTJHb8hbXoPhSXsRFsuWdI/AOed8Mm0G5U9xJ5Olg9L5ZVkQi/qsq8fU
X-Gm-Gg: AR+sD11Py5fpOfo1YPfP23unkyNa6Cp1hKU8Bi4pl5Ed/sXO2ZBcy3sYv3ZYmHPkEMn
	eTnFn2Qpt1nCHAQZlWrhuxbmoJSYn4StGEvt0MM3FFLfp8e26dCi7txpYosYFlFBW86XGIPA/kF
	/+tUW0iFP2dZEafaWS0o46t/uQGzF4zi5kTZO7aps+6eZILXoSBNJqJL5upekE3YBlbdWoSBELB
	b+US/OMA+DH80piitP4OTV0Z7yd4EbnU43tcTMkuUryUxe6qBPvrBXXWKNrgycp2vBJX6Tb5cth
	acisluYs0g2sO85lDAx6yZgnx4u7kIyoBpc18y4BBXhbMT2IJQe1KctxtBVbstGLcPLrtkDawdP
	F7qVhDlG862VACQNJOjVJca9Qbf+xxtJgRwjtu2HV2i85X+TkiJ4D69YQM5xdGsmktVSJvpIXio
	fBRJnABHSOP8E7R21BHpbsG6+fC6LBOvKbRt528pwZaosI9R2O3j9d/HpiioIX6kQyhnzjLKvAc
	zzABpw=
X-Received: by 2002:a05:6122:8f88:b0:5bf:b3a0:388c with SMTP id 71dfb90a1353d-5c3d91849cemr2184457e0c.6.1786035562798;
        Thu, 06 Aug 2026 09:59:22 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:22 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 06/21] buffer: discard BH_Write_EIO along with the rest of the buffer state
Date: Thu,  6 Aug 2026 12:58:29 -0400
Message-ID: <c6e9db48d8d0feb83d4ca29306f4bc1e58f1ee0f.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

discard_buffer() strips the state that describes where a buffer lives and
what has happened to it, because after an invalidate none of it applies any
more.  BH_Write_EIO belongs in that set for the same reason: it describes a
write of the data that is being thrown away.

Leaving it set means a buffer_head reused for a different block starts life
carrying somebody else's write error.  Like the bforget() change, this is
mostly theoretical today and becomes load bearing once the rest of the
series makes BH_Write_EIO the report of a failed metadata write.

Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 381690479520..570ce7f495d3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1518,7 +1518,7 @@ EXPORT_SYMBOL(folio_set_bh);
 /* Bits that are cleared during an invalidate */
 #define BUFFER_FLAGS_DISCARD \
 	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
-	 1 << BH_Delay | 1 << BH_Unwritten)
+	 1 << BH_Delay | 1 << BH_Unwritten | 1 << BH_Write_EIO)
 
 static void discard_buffer(struct buffer_head * bh)
 {
-- 
2.43.0

