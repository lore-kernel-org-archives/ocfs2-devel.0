From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 01 Feb 2009 16:45:09 -0000
Subject: [Ocfs2-devel] [xfs-masters] [PATCH] fs: Add new pre-allocation
	ioctls to vfs	for compatibility with legacy xfs ioctls
In-Reply-To: <4985CF66.6090409@sandeen.net>
References: <20090130171423.f99c88d0.akpm@linux-foundation.org>
	<200901310248.42820.arnd@arndb.de> <49856FE6.8020601@panasas.com>
	<Pine.LNX.4.64.0902011104320.20875@anakin>
	<49857BEB.30404@panasas.com>
	<Pine.LNX.4.64.0902011151180.20875@anakin>
	<4985966D.8040402@panasas.com> <4985C1B0.8060905@sandeen.net>
	<4985CCFA.4070008@panasas.com> <4985CF66.6090409@sandeen.net>
Message-ID: <20090201164130.GA32276@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, hch@infradead.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

The structures have been defined exactly like that in XFS (and ocfs2)
before, and there are similar cases in other ioctls handlers.

If anyone feels like changing this in some way feel free to wade through
the endless discussions about the pros and cons for it, but I think
doing it in context of this patch is not helpful.
