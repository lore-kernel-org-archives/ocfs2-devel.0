Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308B23793A9
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Jul 2026 05:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783660071; cv=none; b=eFQhuIGWGhruP85LPYnFRZmb3hexdNZhMDWg3voMMWjxKabam4k/SObIhbC4YehHZf91WysfhyhO0+6zA0o5bcSbQDhNVMH2rEjPWzID4uKzn1p1A5n0ntW0FdbS2dxLIIsBjPtEKl9h83OErdVqjE8+acs3rCKmyOTQNcAR810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783660071; c=relaxed/simple;
	bh=T37xMCgsiHRoI8IL7Mhq+k8JTqo3npGSGG4RHC0ZMNY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cGn1usTbmWpnku3rY9UU1XFu8jmtVJbrU5WLRjVcXbUgXmP2fOn2ZeyIoI5zlYvmFX8KM/0Kmphuf71cTXopuWF/E/AVo4h+1AHV4qtBPNLkGW/f86XTZa84he9BNLsxqTL+J6RbT9v9AjCltoSvOZK0Iwq07JKAPa3YTildhs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A755C68BEB; Fri, 10 Jul 2026 07:07:44 +0200 (CEST)
Date: Fri, 10 Jul 2026 07:07:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>, Dave Kleikamp <shaggy@kernel.org>,
	Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Subject: removing the remaining blockdev_direct_IO users
Message-ID: <20260710050744.GA6720@lst.de>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi all,

we have 7 users of blockdev_direct_IO and one of the lower-level
__blockdev_direct_IO left, and I'd really like to get rid of them.

The filesystems are affs, fat, hfs, hfsplus, jfs, nilfs2, udf and ocfs2,
and you are the relevant maintainers.  In 7.2 exfat converted entirely
to iomap, which would be a really good example for a "simple" file
system.  Another options especially for the file systems supporting
foreign formats would be to just drop direct I/O support and reduce
the support burden.
