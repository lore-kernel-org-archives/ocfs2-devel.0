Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2489228F4
	for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 17:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726939866; cv=none; b=oYaqyEbXMCLZB7W/XHgb6jAnIG5nqx/Ig0/jouTCAnrJsg6NDnVhgtXZcbxyy4t33UzfcjX2EOdZc1TyfbUfFWoVTaSHrdYYOlz5+iEy6xxaS0X6+79aS/TYWZdWUh2LGcBZomvkdmmh6nXFJuPQvvly+LdvXj+YET6XjyctwFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726939866; c=relaxed/simple;
	bh=XGCYixI0vFK+yIAU0vI4gYEk54HBG/rMq52xNLmqow0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kygj55e4j5oxNb4+Qu+78wkGzZVJMCGBbvyXqX9LtFBQ/UyNPUKf4gMMSvRGmoRozHu0DF+6bqnTjKADDbA5xKdQUAv8sv6CjKIvdAAtf455S+KMzy0sN+1jbPQa329ILe2nNErxpf/AVOXD0flJBzxgbAICwftLerzizffPpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kak0EDrz; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kak0EDrz"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-205659dc63aso26114875ad.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 10:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726939864; x=1727544664; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGCYixI0vFK+yIAU0vI4gYEk54HBG/rMq52xNLmqow0=;
        b=kak0EDrzd6Z13jetWA6znXA/QWY6jTneLIhi3hgabdchnd6lk3wTmvdQCiScysv3mw
         CoR7q3pgS6RqDf4kiKQ0UBYLMbLfY3dHNoYgT/CCkD0Nqq1D/fhIdKqpYXVc/5dXOEnk
         q9GP1NFZ22yZ7Q0JwhaE5S3G8GdA60FuD6LAxU/0iAJQcDm1Lfj1m26igQo9o+pRSLnm
         ht7ppAneQFWiuzQ6hsagN0d7aUw7006nZGDhs/xDDm7eAIo3xfsW/n3ZNoEWWwIFYP5U
         wxgDIXHWE7sQNZy44CvHZhNNZ/wjlwVcabI1QVEO+j5FJTWsV1bbVPAifZdl1MlY6diC
         uHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726939864; x=1727544664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XGCYixI0vFK+yIAU0vI4gYEk54HBG/rMq52xNLmqow0=;
        b=Nq/c2fQZ0HP+09S2KYJ/DEGXJjhFJ+vIkfajuR3T6sIkqzxZCI9IxS0R9zLLPzVQWg
         /c00RVktswlEaymRHhPRAWhc0fEy4pMPc6sJB4TCycPSfuiR/DOwKv4/UiqxVdjXCmsm
         7z6BN9vjA7A3nTVESCNA3KAPm+Czufv28j6fz2bICPmNWr4wevPdAIaZoTS3oTPsIa0c
         sGhCgxObboOLkRuJQaj61xJzlZWPemz4bj2usjWxeVy6b+wXwK/jtEQFFofEe4LPCrNH
         ZRheljaJuBFXr37nz/zcD+5dozdlh9g7WsQ6wAzfNdVS4+IsVVa4zSlsT84u448NcGGZ
         E24A==
X-Forwarded-Encrypted: i=1; AJvYcCX/D8yaorhH/YwzGAQJ/DwVowRC7H4hN+yOU5YMtGAYQvSG+E9AWZvM95ruCnIfXnASTS2dhW9o1J3UNQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyPzls4xDjT11vyLyCoiohiY+MN/oFiwDVD/HYtPpm3wWpKSHAA
	jirmTMbT6oh9NU6aNZR6EQk/VGBe8MCcfj3HSdMvn0dG8mH21HeF
X-Google-Smtp-Source: AGHT+IHWqbbnm9qKaQ/XxFI7HrCdMk6rfQmgnvsR2dGXF9HTvrMr4x3N2MeZThdjkfoi4HE8uyrBpA==
X-Received: by 2002:a17:902:cec9:b0:202:38d8:16c with SMTP id d9443c01a7336-208d989f11bmr72151235ad.37.1726939864078;
        Sat, 21 Sep 2024 10:31:04 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-20794600fddsm110971495ad.82.2024.09.21.10.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 10:31:03 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: heming.zhao@suse.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	pvmohammedanees2003@gmail.com,
	syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] osfs2: Fix kernel BUG in ocfs2_write_cluster
Date: Sat, 21 Sep 2024 17:30:27 +0000
Message-ID: <20240921173027.9425-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <e068a56d-959c-43ad-aaea-839b89344693@suse.com>
References: <e068a56d-959c-43ad-aaea-839b89344693@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yes, you are absolutely right, __ocfs2_claim_clusters indeed
allocates 0 as the bit_off, looking into this I believe the
problem is triggered due to ocfs2_search_chain called by
ocfs2_claim_suballoc_bits, what do you think would be the best
approach to solve this issue, what function I be looking for,
any insights will be highly appreciated.

Thanks!
