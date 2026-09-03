Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D314EBAD6
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451870; cv=none; b=hFuWR8SpVymu/FTIqypC/LlDDPi1S6zbhDz9BD4TtYmP1h3E6khl+85eGXoEZFmVK/yc8wCzyg7pHLkw4pEdV4ZoXEnihsjg2EOTVAH0S3YkkgltfGakrXyFFT+JVUPHKxBdmMuSLOk6mNQc/P99y7AGUXlyRTE7hswCCcw2Juw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451870; c=relaxed/simple;
	bh=oZCzF7U/pNqSGCBx7Lc2XFggzKryAdR7EYUb7XoIkuY=;
	h=From:To:Cc:Date:Message-ID:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sJiQY7hUHbBFQK3aO+d+4de5UoBrseRnZ+2wxIZglURlmfkWInZ1ErZa6f426Mkr+S2Ft+Y8FXRV+IjqlVyZ0MxOo92Mvp1+DoTbxgeZXrAc1J7GeXURqQo64V5A4ut17itzDBgVswZas8fCMwh1VK2OU3Gmo8qqtq7j6q5jvGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PlBtaOGO; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PlBtaOGO"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4843a9cb4ccso6988f8f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 03 Sep 2026 09:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788451866; x=1789056666; darn=lists.linux.dev;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:message-id:date:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oZCzF7U/pNqSGCBx7Lc2XFggzKryAdR7EYUb7XoIkuY=;
        b=PlBtaOGOGkXevA1NUOrRyJ5bG7sU6vwM9ly0TPKqdg1GpPBRjWe9gX4xsOnMEE7saJ
         JumKX2yRokKQ/DJFjtcEjtOaWu0e/6uVnK9gkzeKJrr2k+uFXr3cC2ngvLaU3WzMLvT9
         /KJ6L1dnbCqAjiLOL32XPRUYwqv0NJH1tQoRBu4a+4cmCyaSMZeO9dwLKqgmNQO+QhTS
         T2TfYPsLjfBexTAZM5LgpfnpW/T4DV20r2PWYujRQ3mC4c6vnxpzwJMJNnnGJYlBTJCG
         BefZOJUbgjnbtQnQYTC91Lq3Hhsw2Tu/MjV8uWep75xAJXIz61d47pSYrt/1CxRiabBS
         YlMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788451866; x=1789056666;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:message-id:date:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oZCzF7U/pNqSGCBx7Lc2XFggzKryAdR7EYUb7XoIkuY=;
        b=pXfwSdyxiSFnXmtSynG9BsbvmDwfA20uHj9G4BZf6RKpn7LupirQzSf8pe61O8N609
         kRKqOKHpfmVcWVJ7aFQRPDEH6ob0kPh0lD6ZvrZ/Lw5vOVFjiDIl+RUbNLduV7R+cxYE
         0tw8JmtQXnvg11vkLdLL5zN/WgVL5NaDuL74CS4+noRNvvfuQ9AxwQpES+CbUximiOFT
         JtodPGE8hw7DdSBPoHToqiVOHF9aPvXpMsUKKQW1pAFEq2x5jJejjwtM7Z/zCWUoFARK
         X3VPjBFZvivke6zPi8zs4vKJFtsXBf0LtazxFdilQXdd9iRBv/EnnDaa5Vcq2kwFHNWA
         B6Sw==
X-Forwarded-Encrypted: i=1; AKwUvBwOI7AnYhwwpozl2p0khRQ3UikowfVoUX1z/LmxeExSkwtiQ8XnaH1KTu5PCjdKIMQWSy6C8SlbD5mDcQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lJ+BOG4egadsGQ1S2X/u1OMLzSz4k6YbiPL6dXZgBi1c/28h2q
	8df/OyJ9wR7oKu56qL1JebYuvdfcuO4vI/VaUFGoHThEI3REDBfNUEKr
X-Gm-Gg: AYBFou2TnNWAfrfd0Ry/SqB5uTJ3juJk3iy1NyQnmaMzf4L3NmPAaNoCyx1wPBTQ6x7
	2HFpoRSqpqjSLfCUhvWj4U+xBJzXahi6fz6cgZQPmAN0Rt5AlFtfg1nKM61N8gTifTwbC/EiA9c
	oMZ6OR+yU2FOfpR44184MCjEzrX1lysPusUKrSRjf0PNsKol6x9TpWf2/n/Kd+PF/BnYc9xXSn1
	pIWcA3Tfczw9bHLsLmVvbPU1b25ibvnqMvbJ6uvuOawFRp4xBD7xuxL9hLgr+A75RHRHL6/Oz6g
	4L5WNzBeMryUyYd4HNVkqSxmdCzXxq+tCzrPSzACBDSAx0ZBtZdyQH7yqsff1hTz7EYxDb7FCK3
	EEFyAM9+mLULHjVI4pvKkMLzEvd5q4nHetr45WRz41FteE7yG9xuYsyrVwWKg1DyJfmpkxAzLbW
	tWpUd47xCjXcPVqtPGKFWWgxzH3OL+uwiqKP3Px75D2vAnsBwCS7RHnVytRid2EHCqxVBTnIs8s
	63J/WMgGtd3S0xNFzgpInUm72ZP/uSf++wFvc7R0RMHoV5Wt/pmixMEC+/1HycwgsvwbFh4xxZr
	c8TrRAwvm17l7BjmCpkTOvI=
X-Received: by 2002:a05:600c:530c:b0:499:cef6:104c with SMTP id 5b1f17b1804b1-49ce58369f4mr111926625e9.1.1788451866233;
        Thu, 03 Sep 2026 09:11:06 -0700 (PDT)
Received: from [192.168.1.144] (98.102.222.87.dynamic.jazztel.es. [87.222.102.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf2abe1basm49686565e9.10.2026.09.03.09.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 09:11:05 -0700 (PDT)
From: Miguel Garcia <miguelgarciaroman8@gmail.com>
To: stable@vger.kernel.org
Cc: pvmohammedanees2003@gmail.com, akpm@linux-foundation.org,
 joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Thu, 03 Sep 2026 18:11:04 +0200
Message-ID: <178845186455.1865019.8043691693828475058@gmail.com>
Subject: Re: [PATCH 6.1.y] ocfs2: fix deadlock in ocfs2_get_system_file_inode
In-Reply-To: <20260903152421.1801322-1-miguelgarciaroman8@gmail.com>
References: <20260903152421.1801322-1-miguelgarciaroman8@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Please drop this patch. This branch already contains e79c0fc4f61e, a backport=
 of upstream f5b1910e23f1 that removes system_file_mutex and fixes the lock i=
nversion. The older trylock change is unnecessary and can cause failed direct=
ory lookups. Sorry for the noise.
