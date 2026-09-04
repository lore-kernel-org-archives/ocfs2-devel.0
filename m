Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5973ACF10;
	Fri,  4 Sep 2026 02:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490408; cv=none; b=Nc64BetfxK2lTayBwSbs33OVGvsINxtESL4FRXbmf6KELZk+j6IUuS6n9O2+x/EWVcWbo69PZpRaRYOM95BlZz3UcPG/aO0a+Klt/UrGVHMkoPKBYpTQmijRH0TaPvp8Wk7Ij0NqsDke76DHHWW6V4bd0gDgmlFV9TQQ3fnd0l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490408; c=relaxed/simple;
	bh=v4PrwhcvY/QD23+xwj0El/vO62iH1VO3XAFBNf1jDs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNPTXRQ3/het5WhHcqBBkcHT9ZTrpdJFl36yai6S/DB1hKqMw5FprojYIXENthSKinbua4Ak8Q58oqFJy6u9X7TkLbkPdk5VkJTMhXURHY9Qj9M5QfcOW7Tawi2SzfnycHeCXApKfPmVlrAs5YyMAa2NdtPd9O3fTdscdNvER0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXAcs+pP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXAcs+pP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9CF1F000E9;
	Fri,  4 Sep 2026 02:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788490404;
	bh=UXsZWCSVeHm+XqpEpW4P+QbJSFu19m8hCINjgwCu7wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXAcs+pPvndPEDGlFjP5QiZcFP9IvnAq36rVxYzTMxrJp4ToZ1reWt45PptqAxj9T
	 8rZ/DeXadHqmW9BgPFHFKOYHaeAdBuvmorngEUkF56g6suZF5sEgm6M/tBIoQC/WUq
	 2IZaSPk3PzApZUhQ2GtAFcSrJykrqOJALrbAuVxOYB25svexLOuLYiXHmAw8J/Y07A
	 5jesUmQiFd7YzQSxrwUWumegndm0Ze1sCBg6Hi7NZyyt9vpO/fDILxqp/aPPyMsfsn
	 fKMwbH+BZajSOD8Y4ApIfXKCIz6d9YYfJvioFPwDmVfNJOyA87grNB3mIbbuduI4rH
	 eqUJnJNmnMG4w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	pvmohammedanees2003@gmail.com,
	akpm@linux-foundation.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Miguel Garcia <miguelgarciaroman8@gmail.com>
Subject: Re: [PATCH 6.1.y] ocfs2: fix deadlock in ocfs2_get_system_file_inode
Date: Thu,  3 Sep 2026 22:52:58 -0400
Message-ID: <20260903-daily-reply-0007-re-ocfs2-deadlock-withdraw-6.1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <178845186455.1865019.8043691693828475058@gmail.com>
References: <178845186455.1865019.8043691693828475058@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Please drop this patch. This branch already contains e79c0fc4f61e, a
> backport of upstream f5b1910e23f1 that removes system_file_mutex and
> fixes the lock inversion. The older trylock change is unnecessary and
> can cause failed directory lookups. Sorry for the noise.

Ack

-- 
Thanks,
Sasha
