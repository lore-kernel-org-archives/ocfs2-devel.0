Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E53D31AF2C
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Aug 2025 09:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594724; cv=none; b=V2G/V78zc2wVkmJ5BB8jI1437yaO4//n3jHeAVbnPmJeXHOenvYBs3w6zKU1Ge9/hbrlp7PDBO6XvYkuk06F/Jq8EJeNOCBcDhVZp3pNyBuMzUSw+Oig2GrNwWz+yT/gjlOTHloDXBENYGZI+2kExBoU6cNSzIhLTHKUE0HB+Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594724; c=relaxed/simple;
	bh=dnsJB4XBdnq79F69BsbT+C1e0Sw7iogBj5KndCGpujs=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=Owp5pwcDu1N/pcLZdvojEAb1NiX86hsuG9G18NMkR1nfjvYrqvnna9WpSDakySQQPUVOmk4Z6thVGdLHJ1On8LLu4ypNpZ+tRhvqKzhNh5CRmnrZhvDycG7C5/NeKC66kh8y/bggevXDGiDZpDxQ+Tjqawet6QgiDMupoSURxWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=si2Jmb4A; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="si2Jmb4A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1755594705; x=1756199505; i=markus.elfring@web.de;
	bh=dnsJB4XBdnq79F69BsbT+C1e0Sw7iogBj5KndCGpujs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=si2Jmb4AXKoMow5DbVoNsUWDwB0rWFkAa6XfpeFSELqJawNlxPoVAR6CuHYsy8sy
	 AgkoC11xTkxrdP4CQq413WGiNL0l2SmYcjw/+tskkkl+8MErCDhfALW74GS12dOmd
	 I6xSW1HfJ2znuFx6y4J1mpecBvSnc2ngGcYS88quIKY9JpqyX+GEWy57v+7F6EjUI
	 bwie0CpN2j1IhjPdji1BPrXmHvsGk+o0U4KSTPJjVPigo1JDbqpqG7Y+wg/ljbpye
	 gg7c7sdEvDoI3V8PQr6CCFl7SNQRfY9ocyIwJ3E7iKEx1ckXvYqcrSqzZsJ5nx8x8
	 suDryz2NcFrjAgFUmQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.248]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MDMzC-1ueuCF0aN4-00BNhv; Tue, 19
 Aug 2025 11:11:45 +0200
Message-ID: <c98dacc1-46db-4924-bfb3-c56a084eed37@web.de>
Date: Tue, 19 Aug 2025 11:11:39 +0200
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Liao Yuanhong <liaoyuanhong@vivo.com>, ocfs2-devel@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>,
 Daniel Yang <danielyangkang@gmail.com>, Dmitry Antipov
 <dmantipov@yandex.ru>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>
References: <20250819032958.426932-1-liaoyuanhong@vivo.com>
Subject: Re: [PATCH] ocfs2: Remove redundant 0 value initialization
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250819032958.426932-1-liaoyuanhong@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:b5PwUhEO953XhRWJ0uAFoDbGnnaXKc4HRvD/PVftfjSuL66CzMI
 7xTBUciCXLUuC1EO4bTsBDdqTeQ2zXtAsmjIQ443wbBp0dtZN4D+o8u0/2NBHDNF0gJtDgp
 35W4mzGkOEqGCyWjyvcAAvQ/d4E6aAAXI/f00bSTVqS2vDP3bI+PG9QaLmapqPAUSVUUUy6
 htvfP7EvZr+1q6Lgmj4Pg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qlODxoJViqo=;MVM0QmGc03VPBsZKb60SFNPYo7D
 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
 zTxaQdnCQ4tIDl6A=

> The o2hb_region struct is already zeroed by kzalloc(). It's redundant to
> initialize reg->hr_region_num to 0.

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.17-rc2#n94

Regards,
Markus
