Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409466;
	b=itFK7FXIgKodFbD98BKGj3/zICmXQLLGr9qSYvwD0vYFgI8FU0PRAZsNUWtMDBqPD9WQ
	 39hmwMQICmwbu0PwmuAm0ykNC4nkxmiAB6I9L/wDs9OdrkNz52YDi3pL7QTFZlLVBu9ur
	 ncD2oQ241n473eOd6jgIzAPo0DYItKOocNOJdYaeJd0T1MY+LEfDciTWyWyPzcHkd3HnH
	 aMXXJsdU4pVx6q0kXhUs1J9Nu6IgCwdzq2zCsHz+whfo7Ntxk1zYofzfGfMD8k0geWslh
	 ypTWGexv8iCCY0FDZ70KwzKx5KHI3BzhRQoa14doygg0qAZRGuP03Q0Amvk/tUHxOVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409466;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=1AcgqcqD9ccO0oq79SMjlVcLiC0wInzSyzhYKTzloRIGaYyMsUJf5DehdkdO9VlduWPP
	 UrnqhurFdCxlAli7V1zDkxqB25qTcmcGzcs94fRbinwJkr26kjUxs1G5TjGvKK18TrTXa
	 NGJIuAbXFgRhGbe2kafbn8q4IhsNRWK0tgFNAeszT4ge48ZLKIHB3cjqGwrYU+EUI6sRc
	 TrUpgrntYFyvBB6kJGyaHS13mWHClOH4RxZY3XJgKpD0u5bKahRJ8s8Hkdu6Wc638UDCd
	 rVv7fItna1ahYbsyQPCeljsJjbWalOoZJ3KcGhE4uNjYd/xPx/Oi2UGpp3XZikehJCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5D4606A326;
	Wed, 11 Nov 2026 15:04:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D5D4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9B6F068D0A; Wed, 11 Nov 2026 16:04:20 +0100 (CET)
Date: Wed, 11 Nov 2026 16:04:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 04/41] fs: add SB_I_PSEUDO
Message-ID: <20261111150419.GA10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

