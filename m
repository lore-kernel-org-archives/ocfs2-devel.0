Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161D91AD251
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153640; cv=none; b=AEYr1qiond5jWlKy+wYRfewAoAxexPw4MJgTplSyTDsskxD7PsOTMm4sGpzbBc/yE/moGsngQylHstuRtijlZxnpdv1QTBMriFbtm1abZ8YrVYcq/kh2D1DELQoxa8kQtri2PlXv3LhJMMJRRbF9471GtqS6gIeq3evG//VT2e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153640; c=relaxed/simple;
	bh=LJvxsgflj8pZlvjIKTkCrTlJ7a96ogwA3GwBe0I9emQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FsYn4n053UMsAcSiPRxooV0b3dZdC/kk9jrevvUPG3EtPF1IeMIoDOJ1xaWztqwhmBajwaxI2sROgjRRU+duNwlLaKQN8+NzStCNiiKz/J127Ki0gyGGtoCR89UG0vfWnpUn3bmzjSLOgHowHq73RZYMHpixuonZzr7DD7ew4po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c7Px3/sZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c7Px3/sZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726153638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ihswte3WO7fAyaggneLRgaaCtBvDjJMIFwFHZuMM5zs=;
	b=c7Px3/sZupsJIZEI+64E2mHd45qdoeFGYMTF8wydsLF2JQuoZPTiHCuIE2b4J0LNX7SkB1
	D45MnZjncMD+J51RftgcBuSFieHd4tRUYlXfQGoh26fG9YXp0KlyqGCC8GQrDMJA6qxuYG
	F+8bIedkIx0x3eK8ulRqmsTt/Q9rL9c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-Sb7Kqj6iPQOmTylxiKa5zQ-1; Thu,
 12 Sep 2024 11:07:11 -0400
X-MC-Unique: Sb7Kqj6iPQOmTylxiKa5zQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AC571955F43;
	Thu, 12 Sep 2024 15:07:08 +0000 (UTC)
Received: from [192.168.37.1] (unknown [10.22.48.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DED919560AB;
	Thu, 12 Sep 2024 15:07:02 +0000 (UTC)
From: Benjamin Coddington <bcodding@redhat.com>
To: Chuck Lever III <chuck.lever@oracle.com>,
 Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
 Neil Brown <neilb@suse.de>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Andreas Gruenbacher <agruenba@redhat.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Alexander Ahring Oder Aring <aahringo@redhat.com>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
 linux-doc@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 gfs2@lists.linux.dev, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH v1 0/4] Fixup NLM and kNFSD file lock callbacks
Date: Thu, 12 Sep 2024 11:06:59 -0400
Message-ID: <E2E16098-2A6E-4300-A17A-FA7C2E140B23@redhat.com>
In-Reply-To: <244954CF-C177-406C-9CAC-6F62D65C94DE@oracle.com>
References: <cover.1726083391.git.bcodding@redhat.com>
 <244954CF-C177-406C-9CAC-6F62D65C94DE@oracle.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 12 Sep 2024, at 10:01, Chuck Lever III wrote:

> For the NFSD and exportfs hunks:
>
> Acked-by: Chuck Lever <chuck.lever@oracle.com <mailto:chuck.lever@oracle.com>>
>
> "lockd: introduce safe async lock op" is in v6.10. Does this
> series need to be backported to v6.10.y ? Should the series
> have "Fixes: 2dd10de8e6bc ("lockd: introduce safe async lock
>  op")" ?

Thanks Chuck! Probably yes, if we want notifications fixed up there.  It
should be sufficient to add this to the signoff area for at least the first
three (and fourth for cleanup):

Cc: <stable@vger.kernel.org> # 6.10.x

No problem for me to send a v2 with these if needed.

Ben

