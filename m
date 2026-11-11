Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409553;
	b=RNhwlgAAjDuHCxdcBFTUIzRjeHla8X/TPgtT5v2Hoyem9qOyg1ZkEkMqErszJDyvBqSZ
	 03dGwNRpfaYcTVvDZhwb8cuZ7quUsQ7PyXVWcZxeMuiIhvuC2XL6sDWDugQB5LijdUyMC
	 JsccZ10Mwqcwfhcs0lJP+yhXUGv/2mOxs7e5H138mT5TvwiQf+qVA6Ecn8LH2O6xJNoft
	 QyRWoWXGWIcrb+ue+wgO7nYF/lWgd9EspCJc/wF5/EW1TLWUkn4pSJbCM66tfp+PyYNMl
	 J9Wvyl7GyP8Pxwn+E2zms1f6BEIe9Z07sMHRYd4IT1lN/keEU87zyKunNaFGabVz6sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409553;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=eTh/pZjfcHNyaYvHc1i0brd4au2XXqBxglcFJNmjPBo=;
	b=omPWHpL9RgkLgShh8EMZisckuweMllxIzJDnnzNPaFpplbrmuJOodpGiKGra/ed8i5pT
	 4VYHJ7JRPI8OqS8BS5KRVS/rVNMJtd/pBOVKjVntAl0f7l5uqyBkL65tCsd1Ixq0CGJgm
	 bxUiIWzjDhQmjuF9E07zpfT8SXwB2F7jIWGpDzqQ6GdPQLRb2eGSUqx0N0yuvr6yToMd8
	 TklDLY1pu6pb61RM3SVOxhojT3VRmD7WOGcAPyD72Kga4R6F8+2XH6ZNJDvc5849S0+PP
	 AKpOC6TC9IbO9k5fFGDuRYliFodB3kBYGrwiyYwM0ddct4vhoB0pgORNmT/cgALKB/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830A7606A33F;
	Wed, 11 Nov 2026 15:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 830A7606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 484DC68D15; Wed, 11 Nov 2026 16:05:49 +0100 (CET)
Date: Wed, 11 Nov 2026 16:05:48 +0100
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
Subject: Re: [PATCH RFC 11/41] failfs: use fc_init_pseudo()
Message-ID: <20261111150548.GG10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 10, 2026 at 10:14:27AM +0100, Christian Brauner wrote:
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

