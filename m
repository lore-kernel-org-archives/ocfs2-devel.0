Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F273EB81E
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Jul 2026 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443083; cv=pass; b=J0Ngf1lSOcERYd2l4Qrfg7bgfqhSK/Cot+eh10fCzROFBe8bY3ywK85NvqefN7S0axBr36cAsaPi/+8/THpJ3DGI0zKSF3nAtg8AqXsrHfy9K5V/g5lsXh0coFPhChlbtMh2lakIWktbie9rkmtLWNeOt3/scb6E9WvxQH1MCAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443083; c=relaxed/simple;
	bh=hKygRULlhg+SZLsja9Q5aNLIpZSpmLW6dRBau+cxrXE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=HvsnjYW7Pof4CvbBcpgzCAu8XIfJqT3GjYM1E5qZjJngLMF1Po/Z8aaQYpiGq07niMIsDq0dwulmfPeUXUKxCez4/vZROVSIOS7WMlrGoTZw4u+CtvvdZqwJqjkonFsWzkTPvCrW41QUM07H+F0+DvpjRDQ8asjHkhDkDdXawsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lSGicfJv; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lSGicfJv"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47640541585so2740718f8f.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Jul 2026 09:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783443081; cv=none;
        d=google.com; s=arc-20260327;
        b=N8YCEZlMQtFdWxJwHGYxmIPhC+sN5V4BMXtvo0+880W3UjVSmI/IpAxKknnEiN3rzQ
         KGuWtq8KmVonAcxoMXK4fG4jV7cK7ZWsQrfIBfPm1J33mMzta8OF9aoALVQDa8qIJN4x
         Q47IjfdaG0bfaZqULxCpDTDhh8DJZCeFH4opni7asFMbg1pe5sEDG24lDBN4AjYyWSMu
         TeST0L2e2G2ZB9zG0thhE2c9TUanaK+04iE4yHlvhQTSzasrqEA6q2aTwTbTXHggKYQ0
         sFv2Izr884f6cgb8cGM8H+SqkSk/IBvN7O50Vjk5KXXZXHILEHD4kENkO5wneGKetYze
         tbNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=hKygRULlhg+SZLsja9Q5aNLIpZSpmLW6dRBau+cxrXE=;
        fh=muHN/+lknAEmbUItwfEKA8udxPRPhqP9BQDbNJFSihI=;
        b=ocIILFUeIf4XBEgCQJ0BMuCl7afiZYubcSC76X/rfoZrmK7isS4EUwfLAjG75b1rmT
         rmgp0WJ0AGgJojyHutNBV+6jo91F9ODuslLI9ehiFi0dAkpN78MuWUH6m+K3MVinlknZ
         lEzZ2XSySHVHovyydutDRv48CrUTN+6C1fsEMXw9garPVYNj9tuniEkdLpleCG4N4ktY
         QpjoT+VyR2N+k6jqudgMrJNBgdya9A4EOZf7LeN2j7ewpnQKa3fOpS2W2JbkpXRXTI1j
         LmcYwWjwtB3q76/QFuqdUiSlOo/o5d2SdpxXpQp1XHajBSW1vUietnvhp8jGihMcakMk
         GuXg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783443081; x=1784047881; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hKygRULlhg+SZLsja9Q5aNLIpZSpmLW6dRBau+cxrXE=;
        b=lSGicfJvIdABI3zI2LtOI0GyWMW4NfVUM4lT7xRRYtNgQWEFRNEfg7gDhpYar/aRf1
         3jOaWXWU5KHjBP658o6STZs9SUU2XJuBceZ8Hl0czmtZ1RDnzmA2txfOju9FH13Sis9N
         cv7UBPJCIzjX7cCrJYnPWHq7KnvkCtn48Yl8bKRmOLxvqQzY/12le5OFaJygo/bZfzn1
         z/e+LYop8NEoM6gpLEYVI3v+tcpR1dZp9RM/q1eBZB3gHh6urqwDKu7ZuSy73TbObwLV
         j0r3ckCQS+7ZMkxiM4RinIYTzBBvqThKmf2gqmoUSWX7+JQnS/voz5Aa9WyOK/05nOfl
         sSNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783443081; x=1784047881;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hKygRULlhg+SZLsja9Q5aNLIpZSpmLW6dRBau+cxrXE=;
        b=Q8uKiZn0x/XgrEbf8KsGCwiGCN/UQQaM+EhS63Th20C4edSrHXW5VzndvU81tuMAqI
         Xv+B74txgnBCDLLFftOF+ZI0qaSx+j6ppc8cnZWhOLSptWqKctZbsMXzK45YFY5nM16/
         kgf2c8np5EfE8yetrB+WeW5tOPjsjQ8iMzKLiAVK6QObmbd/Wob1jaj59ToWVsKEGeGa
         vLTp7im/j0VQ9ElDnPKvRP3FERdMhQwWEH0BkX8ohcMqNVXHLRcv+VhzB+5ckHLQ3nxf
         TR3L6OAUeOuybiIBbdITdv6ylbXIwSJSHekgQ8DcPsHvPZ1KXpi0xMAxzF2HCLL9vf2x
         VBSA==
X-Gm-Message-State: AOJu0YyUiak3hibIKjf0x+sB0WV6K/TbqT3px196wb0yAKnlYRea1WXw
	HdMU2yGpYADrTw8bCakFhDP1idCxWiRQC+EdVjpRF89WV7cgsvgcwOt7D0SqhZM+C0cU5t1bGsp
	PGbHmW2JtKbaA2nvbo1nYX/pWbv7FqRpPh8UTIZW31g==
X-Gm-Gg: AfdE7clwuyzCmgarNyhEafdYE1o7ttUn1pQs1JkIhra4dOiwKWA/1OwFnru0Y4yy8vT
	GCn3It7wMT6eCwNXPkoE6Vl9AausiNM5c4DLay1jRI7fpNt8u9ik4233jypAS+OpN1mXUvOnPmI
	QWOll0CoZewucaTqUm4ezExkmpEk7LhLhtFefiFcDje4C76N0SFsjFoeUm4TMZP4yCe5Ci5/j4y
	yhZgZvY6ryll/j95NoZoK0QhMNKHsUlALPKtQEB6Qy+ddFw9kK8gElP163MnfYSwuuC76TiRwCa
	ONzCSeAZ8ZdHOBmF4GfJPbB7XZAN
X-Received: by 2002:a5d:6543:0:b0:475:f0f0:9efc with SMTP id
 ffacd0b85a97d-47de66cb46bmr5486512f8f.51.1783443080603; Tue, 07 Jul 2026
 09:51:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Gilberto Ferreira <gilberto.nunes32@gmail.com>
Date: Tue, 7 Jul 2026 13:50:42 -0300
X-Gm-Features: AVVi8CftIluGD8MOaGQxpue14wUH7Tf4bZw-V6Mdn8_Nlyfr5lDz9fpkTjWcIKY
Message-ID: <CAOKSTBtn2Hw5-ii4YYTcahkQDWOFzD1TVeKK0qVZ3MbauUVreQ@mail.gmail.com>
Subject: Async IO with newet Linux Kernel
To: ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi there

I always need to change Async IO in the Proxmox VMs to threads or
native, in order to boot the VMs when using OCFS2 with iSCSI/FC
storages.
Otherwise, the vm did not boot at all.
This happens with kernel 6.8, 6.12 and 6.14.
Now, with Proxmox VE 9, which has kernel 7 but default, I noticed that
is no longer required to change Async IO in order to VM boot properly.

Has something changed in the recent kernels regarding ocfs2 and Async IO?

Thanks a lot

Best Regards
---


Gilberto Nunes Ferreira
