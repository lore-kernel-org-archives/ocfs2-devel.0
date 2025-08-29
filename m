Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2AF23BD1B
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 Aug 2025 21:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756504290; cv=none; b=e4kIrtFg3iXncyNcMlnA0ACBJ/H34jH/jH+htXG3FdScWx76sGnRXU7uZUXZS73EPK3n6oOiCpUeXLznpcN3quzzL2QYAo5fmnCt5jXm6j9WJSgeRDziM/FSemQB4UYnx880uLR7euD8bUXjvwwyO9q6U5bKYd+57oLTtL3HIEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756504290; c=relaxed/simple;
	bh=B/KubSbVqQxL+YvRX1tZrVpBmaUIpPU9eo5VV2C/ktM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MqWg0utGZViYGF3izfq/1wSphVNkdYCTbRFBMB2sJ2I38+XuoXzpWmTzgZbD/H9pPsmiAQapAsnX7/XjI2d5ppGiXlExviKUkU5WBGQ8yO7yF9Ay4tcS2s1DAU9DdNRpKPjCVStbFA8uDtrRmDUEbDP9vqqkziDK9hrZAcnK8FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=eCwmDx2p; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="eCwmDx2p"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net E422940AE2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1756504288; bh=5CZJ7ehYFc2HvCbpuoy/I5YH1zUHzqDPg8dCzWNSVtw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eCwmDx2peovL3epK2vRSZRhtFFieHbnyhzKNSYiNrBmvASIcm56NAEE1nKiJvJSNP
	 7+8Anu6vyQgwUelQyh9Nw0++yl8noM1/XiBfxscIUF2gZC2RB/cjBD9Ar2nQH8fjEb
	 0z8hY4v4DIDnEmVc6WauaT89o7+yFEKbfsRsbeHBfz8wc9BZxJlzrYaYSkjR6k/bSU
	 WSZhhAzBeO1VfpreunakDBcv0U3CqcMmUaGN+AlW5thDSnSJcJ0qsguyIfZG2D6PaN
	 0/ZPuup7p4cEN0JnW5Kowhl5L29e1pzkYnNrM6qQcmuczPssyZ7Gub42St9biSwTM8
	 1hzQxdGq4u6Qw==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id E422940AE2;
	Fri, 29 Aug 2025 21:51:27 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Documentation
 <linux-doc@vger.kernel.org>, Linux ocfs2 <ocfs2-devel@lists.linux.dev>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph
 Qi <joseph.qi@linux.alibaba.com>, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH] Documentation: ocfs2: Properly reindent filecheck
 operations list
In-Reply-To: <20250826024756.16073-1-bagasdotme@gmail.com>
References: <20250826024756.16073-1-bagasdotme@gmail.com>
Date: Fri, 29 Aug 2025 15:51:27 -0600
Message-ID: <87h5xp4x0g.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Bagas Sanjaya <bagasdotme@gmail.com> writes:

> Some of texts in filecheck operations list are indented out of the list.
> In particular, the third operation is shown not as the third list
> item but rather as a separate paragraph.
>
> Reindent the list so that gets properly rendered as such.
>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  .../filesystems/ocfs2-online-filecheck.rst    | 20 +++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Applied, thanks.

jon
