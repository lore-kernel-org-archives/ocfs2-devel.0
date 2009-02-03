From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 03 Feb 2009 11:21:49 -0000
Subject: [Ocfs2-devel] [xfs-masters] [PATCH] fs: Add new pre-allocation
	ioctls to vfs for compatibility with legacy xfs ioctls
In-Reply-To: <4987F2B8.9070700@panasas.com>
References: <20090130171423.f99c88d0.akpm@linux-foundation.org>
	<20090201164130.GA32276@infradead.org>
	<4985D48A.6090007@panasas.com> <200902020131.04203.arnd@arndb.de>
	<4986AEE8.5040609@panasas.com>
	<Pine.LNX.4.64.0902020942230.11930@anakin>
	<4986BE07.6090000@panasas.com>
	<20090202205102.GG28129@shareable.org>
	<4987F2B8.9070700@panasas.com>
Message-ID: <20090203112105.GD11926@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Boaz Harrosh wrote:
> I would at least expect a big fat comment explaining what happened to the
> structure on what known ARCHs, and how it is expected to look in memory.
> And a BUILD_BUG_ON to make sure of that.

You may have a point.

Struct layout on some architectures changes between compiler default
ABIs in these implicit-padding cases.  Kernel binary compatibility
will be affected.  It is a good reason why we have explicit padding to
natural alignment normally.

From http://wiki.debian.org/ArmEabiPort

    "With the new ABI, default structure packing changes, as do some
    default data sizes and alignment (which also have a knock-on effect on
    structure packing). In particular the minimum size and alignment of a
    structure was 4 bytes. Under the EABI there is no minimum and the
    alignment is determined by the types of the components it
    contains. This will break programs that know too much about the way
    structures are packed and can break code that writes binary files by
    dumping and reading structures."

    "One of the key differences between the traditional GNU/Linux ABI
    and the EABI is that 64-bit types (like long long) are aligned
    differently. In the traditional ABI, these types had 4-byte alignment;
    in the EABI they have 8-byte alignment. As a result, if you use the
    same structure definitions (in a header file) and include it in code
    used in both the kernel and in application code, you may find that the
    structure size and alignment differ."

-- Jamie
