Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B9024B26
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Dec 2024 03:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733283175; cv=none; b=BYmsObqR2G0STSLlmq9P3VhdtCPPMBauK0zp+8l/eq8/LkFAYslOfpGBessLeHuk40iCTKpkctYPwTGX38CeEW7dOAQfYCC5mKf/VE0L5A6JZHLy8P5DJuVUf9/eg+Ze6U6jHioTKEVOq6nTzJhZZwCIjebrk+rDi8CSXMAp4y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733283175; c=relaxed/simple;
	bh=rGxRr+3GnC8oRnWqfBazKCBIX3f96M/vvnV9gVhUqg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V1CB+F61/aZCev8sakLx3RZtMHVQeKzxKtP/g/gnyW0WaZv99SLp2RX5ADsRsiCxzPbEW6Iv2oDx1SXUnw4Pu8A79GmRSpN9bYxpiEvM3/Yc6jAsZgHtxjjKr9o8AhtOl3VowTXSOsbZIzZTj8rr5LGPQjfe8ux1lYReGVTMRP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ecKZ98xz; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ecKZ98xz"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-434a7cef2e3so6298555e9.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Dec 2024 19:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733283172; x=1733887972; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7JAjjJaJE2SqnwfAB7C5rQkjjf+jzpgp+0xXtzPoRG0=;
        b=ecKZ98xzVxO2LEyfUU/Xg/+rbhOKjLBBs7GFeQWdiiqaflTXa3C2bArLMDY6MTyg+J
         y1rLUUVKdocKs26s3zNYDuijbA842+VutP4eaVkb5yO/4PN97AP10e+pJ3YGuIgwaQBL
         YWlImhGgE3WSMWTNsH2MAdhf+bjpyymQV+B8StmR52duNayB8IdynlAzcns26tlNeway
         x9yNdiEkJm3/NltnttPVxfxFoZBY5Kttz+HuOuenFr66NoRGVcSrlGazFlqPzAPcJ0Gd
         LmQAVj0cLeTYsEFuIBV6A6aMDMn8SV1JbrIbAboiySfCWTBfzPcMU3CzSimGzpRrtKRx
         edpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733283172; x=1733887972;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7JAjjJaJE2SqnwfAB7C5rQkjjf+jzpgp+0xXtzPoRG0=;
        b=Db0/4XgnmBQ24Keh62jv4y1bMctVdDiwMbHyophRbddBhZooXn4ZjLqgPCnm5YXSO2
         j3Wny+PZYtNerxsN9LQh7bnv5HODgLodsZxhEnU88gJ0cfVrNoxTQca5/0G3c86ZIwjn
         oMKAIkdRUTrNGgwh1nlhBixmgUUQoeMDkgFSj1nA5wRhRlpVcu+blPbPrmNZB3XTX+Kp
         VAKJsGgV4PPPkNZyqG+mVCFOkYh8tJA0a05Blu52gkJxGiBnl9Z5BglTbsuM62aReoh2
         iDSr1vEeJserMInIp7el15sBwmvaLFwd43HHzD7kgolqs/KXE11nKNqTzU8fxeX7SVve
         gyYA==
X-Forwarded-Encrypted: i=1; AJvYcCWsi4gBXZXElKjM1Fz+Zlld7ut3RN4YxqBGZEnwRwnd3ev8/2d0aKgDhOGp8j8Drgs7g9ZpOcJxFk0B2A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxB0IDddv2ktIDDuumvmuht5LEjSeRUBW6IYx1z6OtSsn0lmGJ2
	vTIXDNBr5OrtNBUR1BGm2NvndO1SVKt4MmMZaxgx5g11Sps/F4bHACEXeaOvX4E=
X-Gm-Gg: ASbGncuXjKAXd27OpuKVKYGUmjJmWbhrLEi0UaZCtzqVpJrSGcyJWWIx+6+9T/Iktzd
	KuDIbXkuoxEluAL670UpsvcmHSSJe6WGC8DQfxIH3PQVX2qNnOAGSWF7y9vPN+1dhbkc8WAnnJb
	9U5l9ymGOUA2DIv+ZKqOC7JrlCMFqNOPnnT+2mZmb05r9fBRbA9VFPIAIuLph7/GUYF+rO1pG0Q
	EQ6r7kBCGmbrCtC0uHY3kJbsIpOSElx9qFK0o9oSrGt9hIN3WbjeSzaofVRMQ==
X-Google-Smtp-Source: AGHT+IEwUcZcwfhH+KayGgzitkNGYCWrij8kJDqhz1bcku7MrZ3FcKOjRX65X0ZPwHdwOZtmGeMRtQ==
X-Received: by 2002:a5d:47a7:0:b0:385:f479:ef45 with SMTP id ffacd0b85a97d-385fd41b1damr1484510f8f.9.1733283172189;
        Tue, 03 Dec 2024 19:32:52 -0800 (PST)
Received: from localhost.localdomain ([114.254.72.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215a04dc249sm37476025ad.203.2024.12.03.19.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 19:32:51 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Cc: Heming Zhao <heming.zhao@suse.com>,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	gregkh@linuxfoundation.org
Subject: [PATCH 0/2] Revert then resubmit ocfs2 commit dfe6c5692fb5
Date: Wed,  4 Dec 2024 11:32:38 +0800
Message-ID: <20241204033243.8273-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SUSE QA team detected a mistake in my commit dfe6c5692fb5 ("ocfs2: fix
the la space leak when unmounting an ocfs2 volume"). I am very sorry for
my error. (If my eyes are correct) From the mailling list mails, this
patch shouldn't be applied to 4.19 5.4 5.10 5.15 6.1 6.6, and these
branches should perform a revert operation.

Reason for revert:
In commit dfe6c5692fb5, I mistakenly wrote: "This bug has existed since
the initial OCFS2 code.". The statement is wrong. The correct
introduction commit is 30dd3478c3cd. IOW, if the branch doesn't include
30dd3478c3cd, dfe6c5692fb5 should also not be included.

I am not sure whether the revert and resubmit patch operations are
correct or not. Please guide me if the approach is incorrect.

Heming Zhao (2):
  ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2
    volume"
  ocfs2: fix the la space leak when unmounting an ocfs2 volume


-- 
2.43.0

