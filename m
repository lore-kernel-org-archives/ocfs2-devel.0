Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11304734F3
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 08:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790584869; cv=none; b=usO8uVZDtdRfvhYBWgTC6lqOnJrqqV7Hg4ni9N11avEl8aKLh/dCk+Hhen+fcSt1iNoWfm7B66sBlIE5PcKGSnkKsFBYgVeLxSfxy4Ti1bTt1OXgs1fKghguMDIpp0+FJhc8beYnH8FgghfvYw+2xABR1o6CabqW3Nb/Xf1DCrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790584869; c=relaxed/simple;
	bh=6r3vpx/NkYETsM/mPEp3V9vb/MNzPolgc/j6bVjGvhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bp2451v5EIKLDrs0TS/Kq5M98CicnlyUhzPwZOoNXrL93/XiBZ5KXvgd3U0mqLzVHCVabtX+Dqddzqwm33nQYEdVBW5KZ0fSbRHXIV8WIB8U8+fj9s7E5alahb3A58qUkvmG8w1oJ5VVvTep3FXTfjuIcvX4VFVOgB5JNnqLrnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=uDNJkzBl; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="uDNJkzBl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1790584839; x=1791189639; i=markus.elfring@web.de;
	bh=6r3vpx/NkYETsM/mPEp3V9vb/MNzPolgc/j6bVjGvhk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uDNJkzBlkLDfnH7CrnWulsiOnaLix0dNizYNlmwbBQ9FICjUSI7G0KWPRofjCKT3
	 o+MVrpx+8r79QqhsMV8SpxzyIJAP51DM0Egce0DZWEbq8PM1HD8tFOrN/Y+bFD6D9
	 yfrB2pkonlNtlHSMFvb56JuChK2vSBAFE5ky5tXDvY2IQBhn2JygTrm/jW8sn11mu
	 HpxxPgb/rJH1FisNDxG72Ur462TNZ4NtpUjIhF1fZCuiFzyYFNHf5ojXVgmcj5Pn3
	 +55N87KM3r6E1H0G7JHUdjGbscwKtgxqKtrxL7H+vvCaJcv5LQ9GOfxaoHXoC3HKu
	 6EVUE2bLXoLO92a8Qw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MY5fd-1xEjZi2jWP-00IxnB; Mon, 28
 Sep 2026 10:40:39 +0200
Message-ID: <716be0b1-d28a-41d9-8433-ab58843bbadf@web.de>
Date: Mon, 28 Sep 2026 10:40:07 +0200
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Protect local_alloc_state updates in load/shutdown
To: Ginger <ginger.jzllee@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20260922060048.13158-1-ginger.jzllee@gmail.com>
 <97f59588-8236-4566-bd8c-7be1a735cc1e@web.de>
 <CAGp+u1ZcA5vNhZ_Vx2HscEP2x3uXc_CrLQ0f7FNTa3UKFYyVTA@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CAGp+u1ZcA5vNhZ_Vx2HscEP2x3uXc_CrLQ0f7FNTa3UKFYyVTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:VUAeb+HgLGcjqB5/DYx8uasr+onXUnIL0ApPfgOVz8H1OCdJA4F
 sMErt2+gWIGgH0t0TJYZyVT033gylUyrny3mFXQiWM3WJwqT1ciSLdzW6Hu3J8JoPfxkoC8
 dYY6aFj/QOskHzScKXguK6LA9dfUpQ9xTMfbj9FfZGIcDsA2lvKz3sL+bORqaLyi/n7bXnD
 QfmiMRX+bGp+fwsCT5P6Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:I639+ApSh3c=;twf9cbrKQMQ1ersJc2xD7fk/0rI
 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
 XspB2jWHZbHQT

> Thanks for checking. Do the following changes match your expectation?

I guess that source code indentation should be adjusted according to the proposed
usage of scoped lock guards.
Will further patch versions follow for improved applications of scope-based resource management?

Regards,
Markus
