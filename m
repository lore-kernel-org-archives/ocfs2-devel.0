Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1256926F29F
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Nov 2025 10:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764238469; cv=none; b=ZjUOBg27o5h6Dkk+s3IAAg63Fi38o9ltG57ERDqTU5q9KFJSkXJVtKHTNczcja4kgQN1PozTGtZxlB8LTDa/saH2f2wS5ku2PBwAqQw2X2zO1O5ynY2DVkpQwNJtPy7ZIVfhAnysAmXdQDz4R6bWoUvqYlfo2+z0xgpde55rBSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764238469; c=relaxed/simple;
	bh=QS1qjqMrqJuWp3bcmlW6BSVzi8/TnZMTSryddcCmn+g=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fDkmQcdV+MgdNq6M/iK79Kg48KGerVRqHSfjRuQX/go/6sdKW+trwYaTl0syDvhHQlVNvRx0drlAFbNrzh81kXWkfQG0g9wlXVdPo1+Yh1rlFBq0ZULSZWspzbYQf1NO+sn3fI1CxhGy31MOtLqT3tWKBXkx2JHTMdwe3kqMbGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iduePU07; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iduePU07"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764238464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzPFVO6dZJRnbkG0C2t+slzavet33W5YtnKF48O433c=;
	b=iduePU074rVpWooEgvDapuOFWD++xJB+cZ9gaAzfxV/r2FANz+nao9W0ZgO32KyN4uh+IF
	auwJB7cVaOIkPrSOTyYrHWB2km1RZPQA84ksBz9fxiSsd5Mfvtfg23ZkYu8hvIwZebkmTu
	bdXjSrRhADtaXjF3EsoGbHoJ9r4hCwY=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] ocfs2: Replace deprecated strcpy with strscpy
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <2fd2f96c-6fe7-4100-ad74-04e587165102@linux.alibaba.com>
Date: Thu, 27 Nov 2025 11:13:51 +0100
Cc: Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <69786F67-0B00-4FDE-8789-E22EDDB96CB1@linux.dev>
References: <20251126114419.92539-1-thorsten.blum@linux.dev>
 <2fd2f96c-6fe7-4100-ad74-04e587165102@linux.alibaba.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT

On 27. Nov 2025, at 02:13, Joseph Qi wrote:
> On 2025/11/26 19:44, Thorsten Blum wrote:
>> strcpy() has been deprecated [1] because it performs no bounds =
checking
>> on the destination buffer, which can lead to buffer overflows. =
Replace
>> it with the safer strscpy().  No functional changes.
>>=20
>> Link: =
https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy =
[1]
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> [...]
>=20
> It seems that all 'include' above are not needed.

They might not be necessary for the code to compile, but I think it's
recommended to add the headers to make the relationship explicit.

Thanks,
Thorsten

