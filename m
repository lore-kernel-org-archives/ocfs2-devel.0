Received: from forward502b.mail.yandex.net (forward502b.mail.yandex.net [178.154.239.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F263C47CC70
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jul 2026 13:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782997390; cv=none; b=Ag/hzrOxGypWZQfF3lsSimVDYr4yh+YiMMx9PS59E8Xb/W3WIEbYcD2/apm48PugmmJZqK9wHSVq2vMxrI2xC3M3PEvvNsps7/td94ch6h9Oe1pnFV2g/bNK1sGaRFEwt9baPWMSeGCPdL0MSODV0EZeLhgzA6unEnyF5/LYFgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782997390; c=relaxed/simple;
	bh=g9KiUH5qgOrz7LhZp0gU5yDLnCJfA9a/10t5wmwpGyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SRwqsJGcCR2RM99qkoG4bvyWvHp//gSyxd5L7si9hvjqu48ou+INSCcrnCpGXE9MM+sGfG4orryrPRUcfVPh54llzScVK55H1VjI3xKpmYFLmKG3lLjCwt8v980CqmNh2HfSWDgWb6M09nXVunOw3yQf2BdUxnB4gY0G4q0c4Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=DxcWxh5o; arc=none smtp.client-ip=178.154.239.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="DxcWxh5o"
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:1698:0:640:befc:0])
	by forward502b.mail.yandex.net (postfix) with ESMTPS id C547181F6B;
	Thu, 02 Jul 2026 16:02:48 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp) with ESMTPSA id k2gxMVBgReA0-PyZe2liG;
	Thu, 02 Jul 2026 16:02:48 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1782997368; bh=YR2ZHsb5lL4l4Y4EtikOcF5Grkin/s13A53jJFfPwNw=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=DxcWxh5o6S4tvCn2MFYNYCTriuN5EAuaitDIMUZERHAsp8bjfyuWfe/HTReT4ct/L
	 cQqjey5mwjQ+WqfcKPuXZEfty2Ypiiksk6ht4gSNLiS7Fwbwa9ELaLNTdw1pqsxAyN
	 9dlOf0jOnrL45UrRJOko5MYNcKH5lIEJBqB8wuJE=
Authentication-Results: mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <c9c39a22-5fe3-446c-b9cb-181dd822f59f@yandex.ru>
Date: Thu, 2 Jul 2026 16:00:30 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate quota file block count in
 ocfs2_local_read_info()
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Sam Sun <samsun1006219@gmail.com>, ocfs2-devel@lists.linux.dev,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260625084448.1634511-1-dmantipov@yandex.ru>
 <f89a5fb9-9d49-47e9-b356-f14acb603f0b@linux.alibaba.com>
Content-Language: en-US
From: Dmitry Antipov <dmantipov@yandex.ru>
In-Reply-To: <f89a5fb9-9d49-47e9-b356-f14acb603f0b@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/26 12:08 PM, Joseph Qi wrote:

> This will reject valid on-disk layouts.
> See ol_quota_chunk_block().
> 
> BTW, could we move the geometry bound check into a dedicated info-block
> validator?

Sure. But it seems I have no clue how to detect invalid (extremely
large as in this particular case) values of 'dqi_blocks' anyway.

Dmitry
