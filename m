Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD475279792
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 02:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643642; cv=none; b=DsuXemZN359vht7SQ/XomiJPdfLiSf2bBhOw7MdbRPdeJX7Yl2a5QkX31WuMlqRjVP0CNVKIuCt7RlxU5c/5IrSBLtS36ZxFhVL7KschJaAK1IZKfRi9t2JdnSn/NGS9+7XbefiMqBrzC3RddaYDTPFTOoid25wJv1EdCV5y/k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643642; c=relaxed/simple;
	bh=x995t96d6Cw3Qt1VxF4SbJcYs6nfINfuwXuKD6EFRBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JyS9/dK7nXUT+54I3ncehzOAZnKoRMUxrvN3k5l0dK3N0gGBg36E9pvJZ+1DxVfWwtTv+FmQnteY7RznQbJrH+wy/I5U58JbzTkSjvHwNSHYWOobFiW0bYbRMO6/3iVebCzaOfh34BUO7ei8e25c5ocZFs6nxKv0fYLchd9Pupg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lzcy5SlD; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lzcy5SlD"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so1959199a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 18:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764643639; x=1765248439; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x995t96d6Cw3Qt1VxF4SbJcYs6nfINfuwXuKD6EFRBc=;
        b=Lzcy5SlDmYzqU8Yk+5GQzMh6s6exgSe8fXp+TuwhKmiDWR/fPYFALRY+zri5vBUbsp
         VseUwRxqfx8dl/5KxDeZsLHGOFNx/C/zlY4y7UnKobY2gUT3gp43ncO5HLfWC8d8OdMx
         ztjuooRogKzbVPI/zxzH6UzuKnslucp3ZQolNs3tqw/cwI7jo4XxrkBGyk2Q6IEVyJ9Q
         zjfsQINVPKhB96+L8/aoNB/7sGc7b29LePde7ilAxZKLzjYMYzBXXPqPM0mNjQnx+1aC
         VBIsQy0qV/Mvqs/QXsi16vS7XuomNYIcYtKMRsvjozHdnYCfHlWc0I6SBsvnVWGJYHkb
         sORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764643639; x=1765248439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x995t96d6Cw3Qt1VxF4SbJcYs6nfINfuwXuKD6EFRBc=;
        b=pHmPFoS2T0ylROigSZur/mZIfxCTS91cFV48ka/Sojz4Y2K3TGifieBHW+nYYeE20M
         LZY0RZ7nlux72iQgDhnxT53mZRIBLPCusq/br6so+ys1J4M1qc0d77T57y7IaxY5aqUs
         hoDfXIwB1DNucZFoCyKumur1J8HOlm8+byjJMGbSWxyQib74czNdrgDhgg0u43bib0S3
         jEeREXuxJfTcag2NN5BCCNJocxKvDzbqfaQX0HV03mKYF5ozUU9lw6yzNtMeZQEnKqQ2
         o/uavibYnKwMavbD1LKR7zUa0tNz03qYwqpfWZ3iFHTQmBTlJDYaWbW0vWkKAAMbQuZh
         8MJg==
X-Gm-Message-State: AOJu0YwnFqHcQLsTdkwh05hk8jCTu+qZGSDzkLR2pd3ExjHDYQiPThuU
	j8KTAGbURSlPJChagiABpm0blNvGsyxAVo0q3KGF92YlYOXiUb9Tutw1
X-Gm-Gg: ASbGnctUUAIwvZ3hUCqdpPFvG72rNLSG7IKweiK66np49TYS5nBBIZ32hNlhcArljxC
	o0Jx8O0xdtjGy66G7orVlw/DTQFirAQzPjMd1/MOAAgXvmzPVbl516RbdnnYo/xxo+NDtAp4izV
	KbABKR+FAEj75G8g2kRsn5pPpmoy16IHA/v/gtTJwWZq7b23MRVb3HFXu8NzgsDJTsfA5rkZOSg
	qH0j4O3j7lPdiAUDfxN//CPqUwEh6dtO0Ya4S/nrYv4CcwgtINgzgBN5t7I3D/DNieEaDl0RM8y
	Tpx+hIjNO/3OwOebY0I+NmHAwnBzdYChoV9zyaeW8r0AhMdnG3iStTA9MaZ+fUmF8DhLWrn0Fv9
	hGvZEcCOzaLfJlirimN9z8AtxBFD3bZMfk035tT/4Crx4et6MDohuffY8QJYir28nYqGDvLjBiv
	CPbaVO+bVD
X-Google-Smtp-Source: AGHT+IEGTTIqXhESIHjvJQHGKuaIzJMgG+hEhCFWh8453PENfudtLcpZV9mM7sQwz1liceKG3S3m3w==
X-Received: by 2002:a17:907:984:b0:b76:bcf5:a388 with SMTP id a640c23a62f3a-b76c563c139mr3103143066b.50.1764643639159;
        Mon, 01 Dec 2025 18:47:19 -0800 (PST)
Received: from eray-kasa ([2a02:4e0:2d14:1a1:8eee:b306:2d20:a328])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f59aea78sm1337913166b.36.2025.12.01.18.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:47:18 -0800 (PST)
Date: Tue, 2 Dec 2025 05:47:15 +0300
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org
Subject: Re: [PATCH v2 0/2] ocfs2: Refactor read-only checks to use
 ocfs2_emergency_state
Message-ID: <aS5TM7vkdHldOngq@eray-kasa>
References: <cover.1764640432.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764640432.git.eraykrdg1@gmail.com>

Hi all,

Please ignore this series. I missed a semicolon in patch 2/2 which breaks the build.

I will send a v3 shortly.

Sorry for the noise.

Thanks,
Eray
