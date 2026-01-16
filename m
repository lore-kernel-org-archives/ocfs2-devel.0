Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0553E2D46B2
	for <ocfs2-devel@lists.linux.dev>; Fri, 16 Jan 2026 02:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768530272; cv=none; b=XwKIf+8krQdMRLI9fHJKT1+Coba5FulK6QDMzYelRDvc2mLo8rBKW6D7pgoLM45w43Mkx7LVbFxCQe9u8qKmLAx1Q2BmPlYg2XeKH51179i632oNPAyGqyybTw6cHJ9SUSNe9h6LOrJZLqcdJBMHiPmaLF7fRZTj9Q3IKiYQGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768530272; c=relaxed/simple;
	bh=AU8ydwM+6bS6tN4tu5gRNYM3pm8mBvS0h3zIXbblp64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h4r3E+aMziX24ZEjdq7MyzO6ja/6A5m05V1DhqCcY8vE8VwqQIXg7XMwXaiD9l/L+vuDbbMOZ1pUa61M9eA9sxWtKPthBebl908tUSa2jwX4WPV8G3YifkeTxBuPW9SolznBkmEZBA4CVoQzd/smIJ6Y4QyXhlpwCP3McYSbxiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=CKqH0dMh; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="CKqH0dMh"
Received: from macsyma.thunk.org ([37.140.223.154])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60G2M4QF012987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 21:22:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1768530137; bh=e7+ZkXTf+cEt8COK7ZiBm7FpEGCZkXwmsqQ2YKKQgYQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=CKqH0dMhvlhBzX4Ihkt/n9SLGrWfxX4mn8QeWQB6i/JMAynZ/PpZnz2J7QzS+Bs5J
	 LHYjeS4eVH/+ftuv6ryVG1XbTNkEBDxBvsdirBrG5SJDvA92Anx4u3N3DTR/EiIhC5
	 D7kuOYWuR+wEG+aT+6digJ4U2JgVCouMwzPvCca8UfAIhFjTH/mNpBMF8a1mqTO4TR
	 J3Ca6tRIWBeIDKXxVFNRB7jtbFt4susYUTGwXkPso02XWNw91PlkdVzLKiVnspunHr
	 roxMctbg4I/pbwnOXw13om2WtDRQ1218LHXRi7gxhCYQcXc4EIsE/wDw9NxL3LC14F
	 SKf5FnkqXpe0Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A12EE54D8E5B; Thu, 15 Jan 2026 17:22:03 -0900 (AKST)
Date: Thu, 15 Jan 2026 17:22:03 -0900
From: "Theodore Tso" <tytso@mit.edu>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
        Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
        Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
        ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
        linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/29] ext4: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
Message-ID: <20260116022203.GE19200@macsyma.local>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-3-8e80160e3c0c@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-exportfs-nfsd-v1-3-8e80160e3c0c@kernel.org>

On Thu, Jan 15, 2026 at 12:47:34PM -0500, Jeff Layton wrote:
> Add the EXPORT_OP_STABLE_HANDLES flag to ext4 export operations to indicate
> that this filesystem can be exported via NFS.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Theodore Ts'o <tytso@mit.edu>
