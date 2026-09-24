Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470643EB815
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Sep 2026 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790268935; cv=none; b=qiurXhtrKouwVEIOnR/y+IBExSOmZQwydO8C0B0OoiD1MMZfz3j1yiFfhL67Y0Pu6jEpzTUWrYQE0w5VMkRvAw0zN6GPm8TNQCsaTSNsqibLEe0q0zrCCHDd4OZjQdlfdELrQGyO2wOWAzzYqLjiWXe4uyNhDNfQLBB1lhSrjOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790268935; c=relaxed/simple;
	bh=JRf6hCUq7MvOiDiRTdHcgk2b1ouJtmj2fjxF4fbIcKU=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=pzH5CqZkoE25c0c6zucGLxp7KDxkCMEN5wqkXtMwTTNXehaOs7Qym86q69FBituiSP6EENxJCJB60P56hEmggCDWI99OFpN7iZqbRJEyzJwIP21TGG9pnhZ8mzw2Vl7oVAvou5Qoh4GQHNP9x4ICvrTxZhUUCf7GtCiRnkXlzE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=vo9mCMCw; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="vo9mCMCw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1790268925; x=1790873725; i=markus.elfring@web.de;
	bh=JRf6hCUq7MvOiDiRTdHcgk2b1ouJtmj2fjxF4fbIcKU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=vo9mCMCw71N7IQaIBpeh6OTjOixKdCdMDMsTDhjVw3xPXnTjPCvynwRlohYzx6aJ
	 W9UOHBH9XkE/tOrLCpfnKGVu5fmKwttSr7iKtoibHudQPbUW4zl9VJX2jkwGhYRMZ
	 92DHQAM0CmHmgyj+HHtg1/UB2DmyFcLttPwStl1P+lHDBnnC7zsZVe/lTSe2LFb3B
	 XlmQG0bmxYlkRs9HGrOe+MR53eQ7I+s+4aUw1/G5v28WWVyHt4o1nDkz/AnxEfavb
	 tPXQpq/Ii91IwcSKefoOGHryhv1i+1TesIA4Va4FbKyt1EQHhVOskGjU24XSKSTz0
	 NQE8hRMCeJCbLZqGBA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MBjMM-1x27kH2scm-00G9uk; Thu, 24
 Sep 2026 18:55:25 +0200
Message-ID: <97f59588-8236-4566-bd8c-7be1a735cc1e@web.de>
Date: Thu, 24 Sep 2026 18:55:23 +0200
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Ginger Li <ginger.jzllee@gmail.com>, ocfs2-devel@lists.linux.dev,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mark Fasheh <mark@fasheh.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20260922060048.13158-1-ginger.jzllee@gmail.com>
Subject: Re: [PATCH] ocfs2: Protect local_alloc_state updates in load/shutdown
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260922060048.13158-1-ginger.jzllee@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kLRKcpZHgzUqItKLl/FbPQ1infHm/iGUiV3q4n8qAphQFUZgD8s
 x/S2QRa50TlOqeduY+Df9LT2GQTRZ+rNEV9EarkXLIdts4lnVdU8r9Fd3Zlq0pd6q96D5nu
 WaxIzxsDdWmwL4TT82ez79s237f09njzG8GUzwR69UR+Nh8W12UNj0zqsE4NqkK+O0etnpC
 8KPe5mqobbFla+hNV6kRg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:91IPC0UFnsI=;tHD5jIQV4NowKWxW0igOTX+CS/+
 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

=E2=80=A6
> Take osb->osb_lock when updating both fields.

May lock guards be applied in affected function implementations?

Regards,
Markus
