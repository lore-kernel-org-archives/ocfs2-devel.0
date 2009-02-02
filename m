From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 02 Feb 2009 00:32:07 -0000
Subject: [Ocfs2-devel] [xfs-masters] [PATCH] fs: Add new pre-allocation
	ioctls to vfs for compatibility with legacy xfs ioctls
In-Reply-To: <4985D48A.6090007@panasas.com>
References: <20090130171423.f99c88d0.akpm@linux-foundation.org>
	<20090201164130.GA32276@infradead.org>
	<4985D48A.6090007@panasas.com>
Message-ID: <200902020131.04203.arnd@arndb.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Geert Uytterhoeven <geert@linux-m68k.org>, mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Sunday 01 February 2009, Boaz Harrosh wrote:
> Christoph Hellwig wrote:
> > The structures have been defined exactly like that in XFS (and ocfs2)
> > before, and there are similar cases in other ioctls handlers.
> > 
> > If anyone feels like changing this in some way feel free to wade through
> > the endless discussions about the pros and cons for it, but I think
> > doing it in context of this patch is not helpful.
> 
> OK so ia64 gcc is broken in regard to __attribute__((packed(1))),
> and it should not be used.

No, the compiler is correct, it has to generate more complex code
if it cannot assume that data is naturally aligned and the architecture
does not support unaligned loads. If you don't understand this, please
at least read the list archives about the last five times this came up
before claiming that the compiler is broken.

> But clearly the programmer, Like in this patch exactly, should spell
> out the hole created by padding and spell that hole out and call it
> __Padding. The porgrammer thought about it, identified there is an hole,
> please don't drop this information on the floor. Put it in the code so I 
> don't have to break my head on it.

Again, you are missing the point. The patch has to leave out the padding
and whatnot because the idea of the patch is to provide a
backwards-compatible API for programs written against the legacy XFS
API. The original definition of the interface was flawed, but unless you
can travel back in time to complain about this in the initial submission
of the XFS file system, you should not blame the entirely correct patch now.

	Arnd <><
