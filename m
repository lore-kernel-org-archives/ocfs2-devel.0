Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EEF33A715
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 09:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768815797; cv=none; b=LQrZD3RudR1oPWC2ocx8AQMj1/geoSRSYpVzbHH2LeS162SaOyv64gDrNg3FXMPXZQiNowsEQBf0aMW+sw2evxSez2delcoTmf3DMILkvVxCV237turW2GQatwwCkePhy5z4g2ahqnWdFeJju478B7cRw0lxNTFjPs3B+M8Tylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768815797; c=relaxed/simple;
	bh=wxjztLuQlINXKaRwIhkhn5s4QVuCiOTRdabbOIeg6ns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nn40MNsQFTtEwswKjG+4B3fPp++Juw065IJmU6M9k3THrstSvHTJdEw6mK7p80gzDObbfNR6r2McNZJbt9WaiadwSDqoSE7GAMNiXX5SfTXGIx/KMkIVPL8nOTidK2hLZNpfbo0OvWyFijN80//0Ga5uSo+lb2w8szLwQgf+rFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=OnEdZ9lP; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="OnEdZ9lP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768815777; x=1769420577; i=markus.elfring@web.de;
	bh=AMPRjZ+Wk7UcebFKSnffBtFf4cqRKVy/5sk84iuJUl8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OnEdZ9lPFcJgp+CC5zV4L1hRt5oDlaZBZnOG57Exden5eHKgMcyaFjZCSTTPwbQU
	 N0k75tRg0+AzbJ6nnJsdbfogyxBz8shd1cVxFVshnLDAWilbb/FmMCdIuCNufmgX+
	 i/8TJrg3O3uOAHG7Ej8wzcTWAguAo1yuc6U/CSabUEAakTvQ8S7+7P56oeqnfoJXD
	 SA4I97tawA0KRc0/U+VRDQ5UzqfSSXvrtXsF894GgD5VDAaGl/ZWEn2bcXNwOZwvz
	 OpYabiAVRBYAMeYDb2KVWPzoc9W0jF7c2O0x2I9MwWKPj++LRcBAn86LINccjB3gg
	 hMxo9XOEXsPJWxMt8Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.178]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MQxo5-1vTev00LGZ-00SquG; Mon, 19
 Jan 2026 10:42:57 +0100
Message-ID: <e3f1974d-5e88-4824-8466-6abea6359c19@web.de>
Date: Mon, 19 Jan 2026 10:42:29 +0100
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix NULL pointer dereference in
 ocfs2_get_refcount_rec
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: stable@vger.kernel.org, kernel-janitors@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>
References: <cfd0e0eb-894e-48c7-948e-9300a19b9db7@web.de>
 <20260118190523.42581-1-jiashengjiangcool@gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260118190523.42581-1-jiashengjiangcool@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OL0fUYJ1zpuhwC811qK9Vc2dBXCR17HPn6BQMk5pYEuSgwZX3aW
 jxBjLmFSTMLT25waajz73ipaKLHotplbF9xfaQ+koxlR+0Le9EGFEXahOw8BTfWuxEdiecV
 NywABXm/+JAqo5dWAB5D6kVqFE0j8npeE6L50fqt9dfeJfCPj/p+6mabOqD97gYesCbHdtf
 3uDRijVh+jYp3PhfOEUzA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:30knBD01OkA=;4TPb8pDIEFbgWSt8v6fI+GZZRIV
 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

=E2=80=A6> This patch adds an 'else' branch =E2=80=A6

Thanks for another contribution.

* Does anything hinder to follow a corresponding wording requirement?
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.19-rc5#n94

* Can it be helpful to append parentheses to function names?


Regards,
Markus
