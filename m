From: Christoph Hellwig <hch@lst.de>
Date: Sat Oct 16 06:13:12 2004
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] manish commits r1580 - trunk/src
In-Reply-To: <200410152051.i9FKpCWY008044@oss.oracle.com>
References: <200410152051.i9FKpCWY008044@oss.oracle.com>
Message-ID: <20041016111302.GA29477@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 15, 2004 at 03:51:12PM -0500, svn-commits@oss.oracle.com wrote:
> Author: manish
> Date: 2004-10-15 15:51:10 -0500 (Fri, 15 Oct 2004)
> New Revision: 1580
> 
> Modified:
>    trunk/src/suballoc.c
> Log:
> cast bitops on bg_bitmap to unsigned long *

Are these disk or core structures?  IF core please just make them
unisgned long, if they're ondisk you just sayd goodbye to binary
compatiblity for BE and LE 64bit hosts.
