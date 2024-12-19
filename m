Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22313190685
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 02:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575722; cv=none; b=nQzWQGToLWvG9hxDctJezwbwDrxVUE0J4QtBBPNxfi3pA317mZsT/4p0t09uNLZdMjjeGohaxvyWcTxLTGi6l2YyxIIhG9n3XDO7k4xea4QN7ZpAXRNuDjgODL4Hc8FGPDZ5RvB9tX0s6XDNFC0Pdo4jH5qUAfXfwZGZoj2fofc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575722; c=relaxed/simple;
	bh=uW6gREAjVtJ2OpRjMy/n/Vx7nbzOviJdyVpvyg6VGj0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QoftRPDyod5EtycDT+MQ/98YLVdMzTxZun6BaN/KKbi1gTtePhuo4bdjOR/FCwvKvEGY6A+eivRB2auHwuZTdcRINIV0rAavkgC/HWvlkU54pcFfyUKHwL9AKV2uv/njlZ/k99EQP/O2VvHQiIbPvmOAmuCTzBN0l889DLHTel0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PY0EL23L; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PY0EL23L"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7292a83264eso280664b3a.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 18:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734575720; x=1735180520; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=35FnTfH4WG+K4PY792luJMCXMpwCP4Hox12oxUuAxYU=;
        b=PY0EL23Ls1HynGkPn7mXnBeph+kA2TbDU7DIOXdEIwHa9/mQy69F2qxrFK7ErlWwQX
         SBIk7bthoPwgXamvLyBRcenHhzSiQi854jXNCadfA03OehpUP/L/LCtr0DD1V0Sr/Ntq
         IFy6eSEVj9hhpq6O7O9L/9676Cs9/8iyd0jzgTg8Y0USlvJzNuMzgwzTyeh4lbriOREq
         eBJxkag6Jh2ZCWglNq9pMmvcHFRhz5pSXZa8uQMZRxvJ9AYyy0WtRirr67P9FfNEn9yD
         Vhhn2ocARl/3LYSNgkqZqTYSSnMhf+VuRcichYeclFf54Tcsi1xV6xU51k8V5/5JcD4A
         BvvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734575720; x=1735180520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=35FnTfH4WG+K4PY792luJMCXMpwCP4Hox12oxUuAxYU=;
        b=dDcZzoeqmqX/iT51xPJ7iKz1dbwAATfHSWZg/HwDckbFHm0YAH6lJH/s6Kb5K2LXXb
         wI8XEav47jMbVrAXiyxvEsidr/cW8Z4rMbpz5Fu+GwvVfZjCxTILbrFMGRMigx9ISlVb
         C9tLLcF9vww/4CMJ3hAn3+jDFNN5kbwlC8DR3SYM/vAjPb3W169jzepMwMQanUMkPulQ
         3vk+U/gqdaSRPBQ8oP0xE0d0SpKDJAwNCx3gKkoPYeiBIUW0Yp2D/9w610vy08g5teYS
         rgU5DIyZ3QMuxN0aReuxCeVaQmF9Ksoe4WCp6sxJcTINsf9z1eH9nzK6Ha17X+CJJtlb
         XYwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVILtVzIiW1RMOtnSKPTl5pWOx8Na0ZWLMBqRCG48vw50PNgbkcuc2d9FoDki1OGm41yW7hqBDIQSYTZQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzpG+QK2QCuJZA/sCXD8kSGWyCNq9RUECrj7LgNCIKp+0j8z2P0
	lxkRcHqSSMFbp4ZF4CHJiSwkIvdmSLD7svwsQCcNzaqipGkz/DkK
X-Gm-Gg: ASbGncuWs44JryLVj5+0VAbNktHp/p6FmV5psUFqYCl/++6SMzUdBNYDwOy235FCTZn
	TFUtvdd3hNrC8eEPz1z6M+05gr4cjE2vHBlm5UDjVH2CC2QV7KpmwXsrz5TqDzbCMvsxSyTfdfM
	xyXbTjGkRm+A+Hyth4hM6b18Hn1+99xbgc8WmJtwV+LshZdluMdcv5Fa2IMMBxxNbyf3ZCK33l5
	3eizsCBS/Skg1c6yqeQQxPy5ITknSY6JSipfFRGQ+SAXmZUzwOSuSTOYZddqfVnwWI6TCvWYnEA
	SlVFRVs=
X-Google-Smtp-Source: AGHT+IEYa8/cPCrPUtV+8BluujgYPFlXKrKcInk+YdaLokr+l/jazm3QEi9WUGXKVKTvc9yKVja0nA==
X-Received: by 2002:a05:6a00:9096:b0:725:e37d:cd35 with SMTP id d2e1a72fcca58-72a8d2c2269mr8262629b3a.18.1734575720422;
        Wed, 18 Dec 2024 18:35:20 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b821da83sm142163a12.40.2024.12.18.18.35.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Dec 2024 18:35:20 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org,
	pmladek@suse.com,
	kvalo@kernel.org,
	bp@alien8.de,
	andriy.shevchenko@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
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
	Paul Moore <paul@paul-moore.com>,
	Kees Cook <kees@kernel.org>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>
Subject: [PATCH v2 4/5] security: Remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:51 +0800
Message-Id: <20241219023452.69907-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241219023452.69907-1-laoar.shao@gmail.com>
References: <20241219023452.69907-1-laoar.shao@gmail.com>
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
Reviewed-by: Paul Moore <paul@paul-moore.com>
Acked-by: Kees Cook <kees@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
---
 security/yama/yama_lsm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index e1a5e13ea269..1a2d02fee09b 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -76,7 +76,6 @@ static void report_access(const char *access, struct task_struct *target,
 				struct task_struct *agent)
 {
 	struct access_report_info *info;
-	char agent_comm[sizeof(agent->comm)];
 
 	assert_spin_locked(&target->alloc_lock); /* for target->comm */
 
@@ -86,8 +85,7 @@ static void report_access(const char *access, struct task_struct *target,
 		 */
 		pr_notice_ratelimited(
 		    "ptrace %s of \"%s\"[%d] was attempted by \"%s\"[%d]\n",
-		    access, target->comm, target->pid,
-		    get_task_comm(agent_comm, agent), agent->pid);
+		    access, target->comm, target->pid, agent->comm, agent->pid);
 		return;
 	}
 
-- 
2.43.5

