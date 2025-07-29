Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548A92900AA
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Jul 2025 12:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753791748; cv=none; b=Zwf6X62StvQaFQdVLqh9F6OLJ7CkJ8xEelo/K4k4OCYnrdKcUIxkqj2JoAnnwBzpa8+NQjCTSE3JYqLs0E/psi6mgVXJHC6zVQ7WhZDFfZ2ooPtUk9Y7NPuAKFU8cIGgai516jifIf/MqY3DUHlgxvWWRsVWIePewTnpxBu2Rrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753791748; c=relaxed/simple;
	bh=WDhFPBiAmW4VXr1rv0LvlmfI0uza+weYkMJa+rABUlY=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=p8hDbiWhZzXCkAkf+EVIFX4pLVyn4QVRPz8K2Kaxe28To0h1dGF2ajm/tOPYWmKi1d4rsbUlCJ0YrM6UENApOC/1vmFz43S6MaucmS4LDSgd4BQgrxysCILf9r3TeDIDjPrUWkWbDc5sWFupMv3vU/ToJgJoXGD8LTf2jvF075w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=SMBrVExN; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="SMBrVExN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1753791734; x=1754396534; i=markus.elfring@web.de;
	bh=VBg/acP1p+b75vMLBo3l2d8L+04u2v9F8pzWNMQWcmg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=SMBrVExNLDZ3sWs/6vUX8nTev3I/7VB8qkm+99aMERGvZd4mRy2P0IJ/loobgs2g
	 Lo6QuiYS5HomhMaMQ24RmavQndf56KN8zeC7zed7g813IBUY1I5gPHIQvqtclzxL2
	 lcmXUI45vER8u1QfPNj2On+9nI5Scs8db1jy0nQ8Yoj8rNR2YqU2/mJ82Tmb2jUv0
	 D/tZmzFEpUcovbV7+Dxm76+nTkq1bD+MUGRrX2AJS9eX90o5c+OEO5q4rWoxqAOD1
	 fYsdJKwL6pwb1CabbwiKJMu9LbSTQjgd2CRI68P4dt2pw47OiM6n8Ht6ARtfMVlWf
	 TVv1G39KAtUv8FXANg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.201]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M8C07-1ulwP70JiV-00BQx7; Tue, 29
 Jul 2025 14:22:14 +0200
Message-ID: <d72608fc-b385-46c2-b0bf-bd78b2a8acc0@web.de>
Date: Tue, 29 Jul 2025 14:21:59 +0200
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Colin Ian King <colin.i.king@gmail.com>, ocfs2-devel@lists.linux.dev,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mark Fasheh <mark@fasheh.com>
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20250729114131.1925586-1-colin.i.king@gmail.com>
Subject: Re: [PATCH] ocfs2: Remove space before newline
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250729114131.1925586-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6Deg73Leru24jw1s/thlxGPIL7V6Qb1rAHikBXqwIxp+3fckIy/
 ZKJuSJSfXF8+M6LA58/cd9uqUaOma1PJ18t9BRp3wNqnhyK1xPpIZkMWT1TLO14rR78mj9L
 430yhTR8qdD1HUZgxeC1R7SRHyh6E+Jm4OhQJA5fXhQStRgtTK6+5tvSNbGpwxqK0uhhHxe
 EbFYkaq2ZWxk+RIqapt+A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:GMn65Kz6dUE=;EwPhiyNCdJ21H6PQIaPKz1NIgAj
 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

=E2=80=A6
> Remove it

  Thus delete a redundant character.?


=E2=80=A6
> +++ b/fs/ocfs2/super.c
> @@ -2108,7 +2108,7 @@ static int ocfs2_initialize_super(struct super_blo=
ck *sb,
>  		if (strlen(osb->osb_cluster_stack) !=3D OCFS2_STACK_LABEL_LEN) {
>  			mlog(ML_ERROR,
>  			     "couldn't mount because of an invalid "
> -			     "cluster stack label (%s) \n",
> +			     "cluster stack label (%s)\n",
>  			     osb->osb_cluster_stack);
=E2=80=A6

You may recombine such string literals.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.16#n116

Regards,
Markus
