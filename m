Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794195817;
	b=O4RkjxlscQBCRTXrI+RFnQOJTXnEkLDueqpJYOjpwYkhwFs0MiuT2D6EJFxCIi6p9WoG
	 GOytfY1ZDj/v7b6FDYRSf3gGoI/gLBUBA5luh+pZBVnKgYoW3aXoOXz1JaRS4Jx/o8QaJ
	 c3ylxaBVSCMuLmSmvbaXRdiY1sLQbYQkQF2dZMj8nVSSjhaKuzYrJluIcfTtq+yuo4ptW
	 1S19PB2vAKQDKnfnJn3dsej1qCXozJum9OKr0Ho19ONbg+OVpbKnUm6mOeoGsGitI0hpD
	 FGRnbfWIt6CX66B01HWjvZILEkYaD43xYAEgn+L+hKSYErtRns/+DlWiMJ7KW4kk2Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794195817;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=VxCc9CWGeKPIK0yidoTH1LkVvQU2hINZ7DGVHD2Knc8=;
	b=nFca26TrMdmscvWDCpCPnESQDurOzePv8PD3UZyBAcEJ907868NEb2h4mG0wjEyTdQfo
	 FdsCSZigQ/clr3tSlPKmPNq2MkZp7el0bzpnRzKHbxYJ3kGV9elheoSe4otgnPHkZiLBU
	 6PAJhcG9Kdbp23ZdUwx5ExfDErNWYAdIUC3dQPN4Kk7CJDxnCFMFKEgODnfpboMZrInPP
	 NN+MNo6UNZZbF+2YpmOhTeSCjQK/6LPiG9uRfUN4saL2YRFfGOy6US4gVqU/cra+82eUT
	 ffOrp3SIxVzuQLAh9ToKh3KKBMFUvqRdn4QBczhFh/kocwCvcI31hp8leITLU+3veqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="pe/iC9Iq";
	arc=none smtp.remote-ip=115.124.30.112
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B7C606A330
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 03:43:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32B7C606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pe/iC9Iq
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794195808; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VxCc9CWGeKPIK0yidoTH1LkVvQU2hINZ7DGVHD2Knc8=;
	b=pe/iC9Iq6TWefmdRr1xrsN7dpkHqJQHjnqaDfT9KzquC1xAoynGVBmJI5uN7kUys3upJlCEa8RmHcaRB+Wl+Anh+cFuOVsgAYuQWKN34U9ikprrLfCBvIvrFdq+GWu/hIt3TRkA4p63ipL4dZ5v1eKNEs+KNIlfM1Ob7NTd3kaY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XEIKFAw_1794195806;
Received: from 30.221.146.205(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEIKFAw_1794195806 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 11:43:27 +0800
Message-ID: <8b72e94b-2871-4a45-8a9b-2841dd76e4ff@linux.alibaba.com>
Date: Mon, 9 Nov 2026 11:43:26 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/31] ocfs2: split dinode validation into shared
 predicates
To: Andrew Morton <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/6/26 7:14 PM, Joseph Qi wrote:
>   22      Bug fix.  filecheck fix reported SUCCESS on corruption it cannot
>           repair.  Revalidate and return the residual code, snapshotting
>           the block so a failed repair is rolled back rather than leaving
>           a dirty buffer behind.

Sashiko still has review comments on this patch and I've confirmed it looks
real.
https://sashiko.dev/#/patchset/20261106111458.1467464-1-joseph.qi@linux.alibaba.com

Will address it on v3 later.

Thanks,
Joseph
