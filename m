From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Aug 30 11:10:59 2004
Subject: [Ocfs2-devel] 2.6 I/O path totally messed up
In-Reply-To: <20040830135022.GA17620@lst.de>
References: <20040830135022.GA17620@lst.de>
Message-ID: <20040830161052.GC15160@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 30, 2004 at 03:50:22PM +0200, Christoph Hellwig wrote:
> The second argumentto generic_file_write_nolock is an iovec, not an
> actual userbuffer.  The current code doesn't even have the slightest
> chance to work.  
Yeah, I'm embarrassed to say we missed that in the commit for that code.
I'll be fixing it up asap.

> Maybe it's time to decouple the 2.6 read/write code
> from the 2.4 code and implement proper vectored operations everywhere?
Probably - we've got limited resources, so patches are welcome :)
 
> (and kill tge O_DIRECT vs O_APPEN hack, and the broken fallback code,
>  and..)
No comment :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
