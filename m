From: Theodore Ts'o <tytso@mit.edu>
Date: Fri Feb 13 16:10:51 2004
Subject: [Ocfs2-devel] Re: [PATCH] Adding ocfs support to blkid
In-Reply-To: <200402040838.i148cCqU002632@penguin.co.intel.com>
References: <200402040838.i148cCqU002632@penguin.co.intel.com>
Message-ID: <20040205010819.GC3605@thunk.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 04, 2004 at 12:38:12AM -0800, Rusty Lynch wrote:
> The following patch adds ocfs support to blkid.

If I'm reading your probe function implementation correctly, you don't
actually need to reread the OCFS volume header and label, since the
first 1k of the filesystem is passed to the probe function in the buf
parameter.  This is done deliberately because the blkid library tries
very hard to read each part of the filesystem only once.  

(There is cache management that goes on in blkid_very_devname() which
tries to avoid calling llseek/read needlessly, and that's why we pass
the cached buffer to the probe functions.)

						- Ted
