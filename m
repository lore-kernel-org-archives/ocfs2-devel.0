Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409519;
	b=c0sdOe2I8IungS5YVYwElgSelNbqg3LImBmlj7fXUyUKlJKSWWWzjmK8yyHJufVmXEnB
	 GeRrEEeKtQFdNhYSw7Qqlw3/MDaEnrNs1nvVklxAY1aPb1krJR9DiGstQqaQfP8Qt1POj
	 ZeZR3+1R3nRtNUONyvn9ZCebkVHuICSgeDdNYmSt7tkb6Lokc4uRVSQySaajEtNpuVLPx
	 gt8uB+QZpHoZQrejrgQ4LQdljTgWIlF0/Zbx1ZpjbxNzI4htGpeMM6uihDiYR21ik6/hP
	 5QtlXJXeFTKqLiP2b4L/vRHxOmA1HJuAZJHed5c0BMtelWiJSs1cnPhz65RiMZBr94A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409519;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=W++0rineEGce3kJ0/xf8y0PsWEBeQeTa4FytoRnnVzSgB0cJc7XmxrnUp+8FUcvgFsBU
	 Do3nW5gWwOLm3rmDIch4VX4Gbw/Qx1e+vlRCXYti3A7ly5mSHVNUrYjCt5wOYcUnFF46o
	 3T2D5yebPovEllL3DKEb4402eO72XilhDO7Ag5xN8otVWBtLRugqeiOwRGauPujEHfiq5
	 my/6T6thvNQh9MsoKsAel8SCmD+4TlwQIlLqxwwVy7ZXCb2SHcbgDqDVQAfM4XbeM4Mbv
	 COTnV5sduGKhpk8kTPCmwJe67FDUkZi4fZ2VWQmHOK537z8qQ1x0f4SgRnaFu2uXJaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A838606A897;
	Wed, 11 Nov 2026 15:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A838606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A94B668D0E; Wed, 11 Nov 2026 16:05:15 +0100 (CET)
Date: Wed, 11 Nov 2026 16:05:15 +0100
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
Subject: Re: [PATCH RFC 09/41] bpf: use fc_init_pseudo() for bpffs
Message-ID: <20261111150515.GE10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

