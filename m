Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3FB1FC7
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Jan 2026 13:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768743668; cv=none; b=MV9CtXnk8vgPjw39KEi7AaG7r/1NWX2CiWKBOV/5alYNyUKUP1+spCwUoplv5fu5PQOKz3J0pLoYsWgR1kCugWKAn6IX269FN3PEBeoPrzzOeNrzRK3pa7fLUcUzW48cW+RZII62h9GkRYdumKx3IzC30HDtAW6dJuoeBmW5X54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768743668; c=relaxed/simple;
	bh=mHs9UhPFkj97fmjr2ht7/Zq5fPiefxd9I2CCXdMGkC8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=qyqr5EUBvDpvcoPyVfvGToaHmkX6Zx/7ni6V3OLrwGbpDOfOQUBD4K3tXKaVNgi7TkMoNgp49lUKfT+uMVyaNyVFXFSpUOpzRsK8kvMNKiM2wSvdti0HxXSlYSB8aQZOztGGT6NMlh7g9YnHo8YuYEWofrycBIaznU/Ft6su+bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=biwXFx1B; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="biwXFx1B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768743664; x=1769348464; i=markus.elfring@web.de;
	bh=mHs9UhPFkj97fmjr2ht7/Zq5fPiefxd9I2CCXdMGkC8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=biwXFx1BFjFwp+Q+40q4vg0PdbwWLZtMhv4nxan6nvP7mupbrDPFVfv2ttyZL70V
	 Hsq7T9/kBChsBVLIHG4p+Souort0dw6jfv9UJqAAGTceaGBAMlQbluVXlgFXVwFZk
	 pe2zP3ejrkQ657l9VZuxcgk221loxLELWJiuMLA6Llf041CtfF74oCaukT+6oHpzW
	 lKnEtT35MQrkWJlVEt5VR2ro6q9Xpb4kdOlvh+zJtH6QOLerSTMaO2lcHQExrQdpU
	 NZ5lrY1hsCup3xgBs0T3jYe8e5aMSdi5YY3UmGaae54K+qtytV0qqN9BHODt67YDM
	 zAAUCinrIDISuZbinA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.1]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Md6tr-1wHLoB2HgZ-00dz0i; Sun, 18
 Jan 2026 14:41:04 +0100
Message-ID: <cfd0e0eb-894e-48c7-948e-9300a19b9db7@web.de>
Date: Sun, 18 Jan 2026 14:41:00 +0100
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>
References: <20260117161605.30291-1-jiashengjiangcool@gmail.com>
Subject: Re: [PATCH] ocfs2: fix NULL pointer dereference in
 ocfs2_get_refcount_rec
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260117161605.30291-1-jiashengjiangcool@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mNtvnl26nYRJQTQa6NGdY9uiF1FE0L+d8rMbDw5Kkbk3+6BtJ8v
 cIAbZtLywLjGinWJ2HAlt6turFRG1/waE3nkeLYKtrrOuRmmkk+yZ1mFOrNHYRgUdqDZZBK
 /GHeoj3mVasIKiU+SxlA5ckUPYliYp0qPfzKL0Vi4FXPk0KQoqFqBZje3HAZq1Zhb1urti6
 69CTWyRDdFruy+0zUGppw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0M4mu6cBQ68=;/rwAZlDwJYzMHTTi9c0RsPPr9JI
 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
 rupNQtII0Gnxyl5hAxUu5V9GLMCNvKO+8MO5w2

=E2=80=A6
> This patch adds an 'else' branch =E2=80=A6

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.19-rc5#n94

Regards,
Markus
