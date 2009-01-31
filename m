From: Arnd Bergmann <arnd@arndb.de>
Date: Sat, 31 Jan 2009 01:49:17 -0000
Subject: [Ocfs2-devel] [PATCH] fs: Add new pre-allocation ioctls to vfs
	for compatibility with legacy xfs ioctls
In-Reply-To: <20090130171423.f99c88d0.akpm@linux-foundation.org>
References: <4980C71F.1010804@ankitjain.org> <200901310138.34164.arnd@arndb.de>
	<20090130171423.f99c88d0.akpm@linux-foundation.org>
Message-ID: <200901310248.42820.arnd@arndb.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankit Jain <me@ankitjain.org>, viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Saturday 31 January 2009, Andrew Morton wrote:
> Is this written in a standard somewhere? ?Is it guaranteed?

Alignment is defined in the architecture psABI documents. 
Unfortunately, many of them were written before the 'long long'
type became part of the C standard, so it's not strictly guaranteed.
AFAICT, the alignment of __u64 on x86 is the same as the alignment
of 'double' by convention.

However, the problem is well-understood: x86 is the only one
that has a problem in 32/64 bit compat mode. m68k has similar
issues with 16/32 bit integers, but those don't apply here.

> If some (perhaps non-gcc) compiler were to lay this out differently
> (perhaps with suitable command-line options) then that's liveable
> with - as long as the kernel never changes the layout. ?Of course
> it would be better to avoid this if poss.

If a compiler was using irregular structure alignment, all sorts of
library interfaces would break. The kernel ABI is only a small part
of the problem then.

> The other potential issue with a structure like this is that there's a
> risk that it will lead us to copy four bytes of uninitialised kernel
> memory out to userspace.
> 
> IOW, it seems a generally bad idea to rely upon compiler-added padding
> for this sort of thing.

Agreed in general, but the whole point of this particular patch was to
provide compatibility with an interface that has been part of XFS for
many years.
Linux already has a better interface for new users (sys_fallocate), so
changing the patch would not be helpful and not provide any advantage.

There is also no leak of uninitialized data here, because this structure
is only read, never written.

	Arnd <><
