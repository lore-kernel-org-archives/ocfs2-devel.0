From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 31 Aug 2015 12:54:10 -0700
Subject: [Ocfs2-devel] [patch 05/28] ocfs2: acknowledge return value of
	ocfs2_error()
In-Reply-To: <20150828232043.GJ1145@wotan.suse.de>
References: <55de3994.w2sNGV4JuorZ6zu9%akpm@linux-foundation.org>
	<20150828232043.GJ1145@wotan.suse.de>
Message-ID: <20150831125410.1ac229ce4c84ae05a485925d@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 28 Aug 2015 16:20:43 -0700 Mark Fasheh <mfasheh@suse.de> wrote:

> On Wed, Aug 26, 2015 at 03:11:32PM -0700, Andrew Morton wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.de>
> > Subject: ocfs2: acknowledge return value of ocfs2_error()
> > 
> > Caveat: This may return -EROFS for a read case, which seems wrong.  This
> > is happening even without this patch series though.  Should we convert
> > EROFS to EIO?
> 
> I must be doing something wrong because in the kernels I've looked at,
> ocfs2_error() is a void function.

The preceding patch (ocfs2: add errors=continue) changed the
ocfs2_error() return type.
