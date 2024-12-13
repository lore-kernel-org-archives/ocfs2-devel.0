Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EE818A6BC
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 05:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734068843; cv=none; b=ih+IYwAnVOJwfVGrUbSl9JRWEFclhntb/zW+X41zbfviQnFJBJYkd0I+xvdTCDu4ac3dySnJNQIRoRk2hyZfVGsBQtVBsTZUB36y8ILX4uAv6eT3QOq0OTpY8vP8NcbcpEaW9hrsneRTHKaDPMe5Mp6LRMLxHvtbjonY1fffh9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734068843; c=relaxed/simple;
	bh=HBeo4xWE6l5jixWcMRrsf7eVi0MSPm7+QXC8ECpQ+bA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TgZb/Xm8f3e0phMWn2evwx8BNWD3pgyoUiiYkSyQ+B4/P4D6m4DePw9IfyWRWNX3l314TiUkAZI87Lae5NN8CBw/fK617adhyH4oUoUqmdM9UM5GCAofP07MpBVXPUysHE+gIcR1p17ziW0/uQSkJdwZoLxSBHZTXzAe3ax5j6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DDpQM+mD; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DDpQM+mD"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-216395e151bso9166725ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 21:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734068840; x=1734673640; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQpRmGydqcdMOxZRzmLm98GnY2wtgMQ5ZotZeI2M2YQ=;
        b=DDpQM+mDnX4RefGk0RYT3eqYxqzji0TGhzKYgNt4mVG5skudlqCYKfvAy7aQKz02eN
         lIn4enl4x6+MJH4wblVCPmQcR4vrIdLDBXnbyNfBNvxYxSBNqVe3CxkGXP4sPtPA+uOh
         ANrRHKn/2q6M8FwTkoe8eVu0HVPnkG3fyHM3bmJXTLbydOCMntE1UVDkm5oSOh7Ce2aO
         z5xmfhyKhQEF4bI0S4fhHLVXVajMRUGu30qc+v234SQB/i0tKJnPkXAdk6mMgWS5ZSxS
         3Ac0RKyK5d9+0pVyjeb3cgzniylPvifzZa9Y+UL2pFIkPEXdautBHj47am5fS91A/bbk
         ZwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734068840; x=1734673640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQpRmGydqcdMOxZRzmLm98GnY2wtgMQ5ZotZeI2M2YQ=;
        b=MY/DlxR9YcPOOKYEuZLcaxRh8DKLHmq18Remn75MO6yTyOu2q01Mxl5KdUgS4JaB8T
         rQ8gbaZdBatHMCdaGiUkidhGHoMFRh2lnGxakgLxgmrzHjFtrE8ObPtVtA9hFRV8LZMh
         TTxCp7hm0Phcyb2FoTrQ6H/YMYdfndY0Fn4xM3kHdTgYwP3aO287mYSjq6epdE8siFfc
         x6KTBaRZqxLGZDckPGnJoqVhB3xeN3E87OnM7t86AjkgCzsFuEWSpcpBNxdjWnTVReDl
         rIF4TWYdLZhoGtJg5ZE8gkqd6difrIsdCvrVqBIGzKPL4bBYKX0N9lZO5rIzGBiyd9p1
         PoTw==
X-Forwarded-Encrypted: i=1; AJvYcCWSlOtZ2B5DtzmapV+QhCw+lac1+0M2sijQdPG/W4hu4lnqZlvmFD2uKIQ9Pd0RO9X84XwYllU7GkVfAA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxQtZuulQiw23IKwgT2q1HXugZs7FLvwDVZSDswbX0yDJT+n00b
	QDSGwdf3AWLN6AxHY+5jbabNqEpGXMfjNYkBfKhRa7ljEPVwmrdf
X-Gm-Gg: ASbGncuEfZ6e71Gl+sOR0HQPLTXtx2oTTzB0lA6d9XILABXr3qNvwTfw8Q2p25fWnbx
	WIDyWZOUrLjmKFmcdvGOZ4QNeISyDJKtGj3EEfPbgXxt56+13ao5xhYJDqzXjCZNOuavJjr1MoY
	U1g3ahpnLKKnRglwHKx97OTrTpYs3ysCwg0IzZBrCYlvLo58U3IgzOdxQ3EVZe0L9GAfF9C1Hkd
	VfgyD1Tc9thGf8jx3LBvxMOn/ozP1/9PwkDsxqIwJdfoWRvxvMYgQvAbzXQSLC3JX9hzZ0t4SRv
	bQ7he6M=
X-Google-Smtp-Source: AGHT+IGy5lWO5x7q/SCrL+dH9NQnv1Rp0u2NkmqEtY14rjHQEczQdhUClmCmrxdf9miFcIspK1e1uA==
X-Received: by 2002:a17:902:d506:b0:215:9c06:272a with SMTP id d9443c01a7336-2178c872102mr82765085ad.24.1734068840305;
        Thu, 12 Dec 2024 21:47:20 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216483dd292sm82564985ad.226.2024.12.12.21.47.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Dec 2024 21:47:19 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: torvalds@linux-foundation.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	x86@kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	ocfs2-devel@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>
Subject: [PATCH 5/7] security: Replace get_task_comm() with %pTN
Date: Fri, 13 Dec 2024 13:46:08 +0800
Message-Id: <20241213054610.55843-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241213054610.55843-1-laoar.shao@gmail.com>
References: <20241213054610.55843-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer. This
simplifies the code and avoids unnecessary operations.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
---
 security/yama/yama_lsm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index e1a5e13ea269..4bdfa51ea6fd 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -76,7 +76,6 @@ static void report_access(const char *access, struct task_struct *target,
 				struct task_struct *agent)
 {
 	struct access_report_info *info;
-	char agent_comm[sizeof(agent->comm)];
 
 	assert_spin_locked(&target->alloc_lock); /* for target->comm */
 
@@ -85,9 +84,8 @@ static void report_access(const char *access, struct task_struct *target,
 		 * Imagine angry ranting about procfs here.
 		 */
 		pr_notice_ratelimited(
-		    "ptrace %s of \"%s\"[%d] was attempted by \"%s\"[%d]\n",
-		    access, target->comm, target->pid,
-		    get_task_comm(agent_comm, agent), agent->pid);
+		    "ptrace %s of \"%pTN\"[%d] was attempted by \"%pTN\"[%d]\n",
+		    access, target, target->pid, agent, agent->pid);
 		return;
 	}
 
-- 
2.43.5

