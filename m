From: Christoph Hellwig <hch@lst.de>
Date: Thu, 2 Oct 2008 10:09:28 +0200
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Add security xattr support in
	ocfs2
In-Reply-To: <20080923063329.GU4563@wotan.suse.de>
References: <48D3725A.1030701@oracle.com>
	<1221817353-11111-1-git-send-email-tiger.yang@oracle.com>
	<20080923063329.GU4563@wotan.suse.de>
Message-ID: <20081002080928.GA24717@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Sep 22, 2008 at 11:33:29PM -0700, Mark Fasheh wrote:
> Also, would you mind rebasing these against the latest xattrs branch in
> ocfs2.git? The only change was that I removed the code in '#ifdef
> CONFIG_OCFS2_FS_SECURITY' and '#ifdef CONFIG_OCFS2_FS_ACL' because we
> weren't ever defining those yet. Obviously, you get to add them back now  :)

An option for ACLs makes some sense, but the security attrs are so
little code that's it's pointless.
