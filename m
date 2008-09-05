From: Christoph Hellwig <hch@lst.de>
Date: Fri, 5 Sep 2008 02:29:13 +0200
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Add the 'inode64' mount option.
In-Reply-To: <1220497421-8606-3-git-send-email-joel.becker@oracle.com>
References: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
	<1220497421-8606-3-git-send-email-joel.becker@oracle.com>
Message-ID: <20080905002913.GB29097@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 03, 2008 at 08:03:40PM -0700, Joel Becker wrote:
> Now that ocfs2 limits inode numbers to 32bits, add a mount option to
> disable the limit.  This parallels XFS.  64bit systems can handle the
> larger inode numbers.

sorry, should have read all patches in the thread :)
