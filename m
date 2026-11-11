Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409011;
	b=dk1AyUhKFK5jflcn3fG2DVG8cf16e2vTC/Uyih+5C5JASvIrLbpuYQmQRa3GLY87t26I
	 BQovy3/29FS3dSchQmXtrUUAOJDH2kLCzRyXkMREwYuMlVRVbHV+aLDU4OXUqqNp7fFQj
	 n3+XunmK2vjymqO0lolBR7zHoqkp6WqX/BdsjgY2yNe1qxdOx4AzL0X2j86ecVdWUmR6t
	 sPNx/LargYzrKFKvJip4inx2F0bekO5xJA6Nqi+1HjzKQ7RCdvus8yNbfDiHuMNYJICN9
	 driXPMBESrvfUo/nxYey088n815f93rOFX4YBoSog/kJbhIR3u9Geo1NN7ZL5j5qC7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409011;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=uTScRtTvc50Ly2VnPZ+IRL7zVmHRGtRnjIEMUslXOU4=;
	b=OK2Ch6MVmt+pYzoJ8LOjeIx1AVFx8P2XwcmJPNFqR9dZsfI7zraRjNIqnqaY49RZGW3l
	 //E8kOGoSmzMxgi/yJleOhxRIE4ELywt3QbwmAPEEXqOfeBD725funC1a0WzUFIeB/bso
	 eFwXn4MyMlFYLQxYo2koe7aO2KQqXBZ87a8CLJVu8LvV39UoFfRYTL2X+SnrSsvPqV/mx
	 vB4cVQXmh0FcF3JW2H1yfx8GiISYsptVS4tiLWVDetWbfAfG3koqGikZe5UTsKSCf6nuC
	 61V4iM9pXsz76WQYhHpzmf1KIMjijMCtIf94tU4aMwn0yZZU6uAPeLkDMEg7xjIWDuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D22606A327;
	Wed, 11 Nov 2026 14:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23D22606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BF2AF68D09; Wed, 11 Nov 2026 15:56:47 +0100 (CET)
Date: Wed, 11 Nov 2026 15:56:47 +0100
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
Subject: Re: [PATCH RFC 03/41] target: fileio: check that the backing file
 supports ->{read,write}_iter
Message-ID: <20261111145647.GC9996@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-3-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-3-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 10, 2026 at 10:14:19AM +0100, Christian Brauner wrote:
> With fd_async_io=1 the fileio backend calls ->read_iter() and
> ->write_iter() of the backing file directly. The synchronous path goes
> through vfs_iter_read() and vfs_iter_write() which check for them but
> the aio path doesn't. So a backing file without them calls a NULL
> pointer on its first I/O.
> 
> Refuse such files when configuring the device. On the synchronous path
> every read or write that needed the missing method failed with EINVAL
> anyway.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

