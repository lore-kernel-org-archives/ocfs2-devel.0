Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409481;
	b=Phb8nOo06e1FPlrgv3D6XnraiUV9JgqpvmhXKqZRYvdt0QtgpmKlxVHmVI0j3ZaM1REO
	 nmvAV8pgn1wcltrpau3ePfiFoIEyFpzcRdb6tUS6JcZKV7zhmsnmjt4X67wgRMNx+v9m1
	 DcpjtQ739u6f0Ot1Qo5EbPRvOrShsqh3rLacvGAOgY/0PYx65Fsu1MC7rnK1NHsKR/+zX
	 6XdOOACAhk2OPx/EsFVh2tdISkrRVhUZuVWJJ2kwCIJaQIoG3U8QdwFLeQE+sMCJRoTwc
	 1pIWs9k2xk6BRhjSB7raBFkdNMsbPTBJkeBI2GomLnCBtpfSnMpPbYzx5Lt98RCcvXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409481;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=nNQa7ysgGW3Umu2RwzZOHFvmDm7dWo+4yXxUIGS+iGHMP42E3qfiu7uzJIK5lfUOtSTG
	 JZvyBXIbm6IVq7by8+Bp7VYdGGS2x2r4FPk7Ho0yObqQ5kDiPaPZSczJhEec4JVhNlxRQ
	 YlyB+7CiPB7DEiH6YH3EeO8bxTBXYpCl1x1rg5kpy5d3OLnCivPXlnN+jxaG2BA7F9GC8
	 ecQmo3N2h+2gZ/eWkQY3l6JhxBOSf9A7IT95caSbFxuFq5UQcyOOHREumOAKdCfLEmhUC
	 3mB/2VC/1sy2JY4XADPv4KXIHc6wMLRNlqVWhqGJhZCNV55OauviDiIEhMyEZC+oQ8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E550606A321;
	Wed, 11 Nov 2026 15:04:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E550606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 269A268D0F; Wed, 11 Nov 2026 16:04:37 +0100 (CET)
Date: Wed, 11 Nov 2026 16:04:36 +0100
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
Subject: Re: [PATCH RFC 05/41] kernfs: use fc_init_pseudo()
Message-ID: <20261111150436.GB10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

