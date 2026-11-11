Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409540;
	b=GwJwca8uzZDKmkGZnEiZxpqiiHz+8hq/LhEm1PJ0pTCElE72XsFoSxgyfwkzLu6nBC44
	 PXwlifTleWWRzV1EI42hRxIOzyVOPZtflS7kLNu7c87YrQ0U03TESdbshog/gdczxznVE
	 9U9zgE5wdYXkkEAtDtz1IBkSWjfNaKzuEbSE/9mlf2KM2Qdb2IG8QN+23X2na+Ss1Ew8q
	 UNeOeoqG1H5SjiaiFfmoeI8b1rzswTzbygOYSHpWv1zsRSc6l8cS0u53w6axdmLLFbc6D
	 Uws0rZZoGpd1rNRoYkj3zz0TnC5FTwgOcWKD6gK5dcPY3tiRrkuMkkteyQ+DzbCwEhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409540;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=3eXaujzWsI4QrtOtWgTNBZbBC275dnsr/pB67SZEqiA=;
	b=ftbtxzzZfgyYFl8+q/4ugFSvAhWGVmjzAvbPv756pHRudRmeKFRC35toz0qZ//5P0qP6
	 leITScIDGN3i9qeZtSzdvms0QPd3htlYufn//WDv049wflHRzTKFzAQzGMSU6aMSk02ea
	 8PllNSCRLnUbtlWEYRNjb2+FaGcB16qfbeKA1ycC/+WcrppZOzQf0xtfdxJLOawAMd4bk
	 B36cLygwc2NYtcGEYfc9SRxgD20mGA5j62qdL8LDfeFDWuGMJE5kqw43s4MituOZ2O6NC
	 c9zlb6QHuphkaH73/hlOx5r83NKGOhKLrCsI4c8mmW/eMDiBRdVP1DsmwTXylGzs3zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C82F606A321;
	Wed, 11 Nov 2026 15:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C82F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9F2668D0D; Wed, 11 Nov 2026 16:05:36 +0100 (CET)
Date: Wed, 11 Nov 2026 16:05:36 +0100
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
Subject: Re: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
Message-ID: <20261111150536.GF10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

>  #include <linux/uio.h>
