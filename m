Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409507;
	b=wQVMq3kb99NrglXbpKOi5AiJj+0ZSc3RQOzJOpebVXkUFLCzwpXwLIYZ6ShzJb653SAe
	 PgTVRSMfud2VXx24E9IUrr7jHbNMrVTgbiiI84j+oVKKANSJFmNyPzvUzImyjnmeTAPJZ
	 P8Fi+shr7cjPJTO2n9ufeAc5cObPgM3Q8sZaOPFyXneOwGlUkRG16SdmJzmlQpPSRS+Fv
	 /pJHLEMgyUDRlGqP7UrEyCQKKI/YJCDA2eXh2g//OrhtfsfUsVm9ruGeKVCIz0sT0ABLz
	 IsEC+2UkBLkgVnTaMZ/qMJJ+653kuZwy5zvTEuWisJuRDLnZc4njUZSfuY4ufAUvUog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409507;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=R1bzDtL5141Elv4pL/2UE6Sw5x/43pETF4OFOKJbiIJ5hedP+osq2TIxJADR4TDgWQOA
	 n4iTmQodBcPsMb58Ro6v23t4xcT+Ci9EIw5El7gPTzki0XClYWudCulERG/JaNYXSTpLJ
	 jFHitcFcleSKjKyt/41Iv3Do4iNOpm3TDLpEDZmFGN9KPQqgy0nVziQ6CFXLu5bG4x8w5
	 bs89/hPNzOdjH4Uu822dIcS2aFUmj68zGeXA+a8ATnTkJBmLiWeoCkDhB/540M9hUJ2SX
	 pBUZYwCdbCp7DA97ijqhoiG+n+iL2ziD+qUQvi3MX7ODosd4GNW8m/W+uVCVOLogMPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF82606A896;
	Wed, 11 Nov 2026 15:05:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DF82606A896
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F080D68D13; Wed, 11 Nov 2026 16:05:02 +0100 (CET)
Date: Wed, 11 Nov 2026 16:05:02 +0100
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
Subject: Re: [PATCH RFC 08/41] mqueue: use fc_init_pseudo()
Message-ID: <20261111150502.GD10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

