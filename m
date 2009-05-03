From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 4 May 2009 00:08:56 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <49FD976B.3000508@panasas.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<49FD976B.3000508@panasas.com>
Message-ID: <20090503230856.GE8633@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Joel Becker <joel.becker@oracle.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com

On Sun, May 03, 2009 at 04:08:59PM +0300, Boaz Harrosh wrote:

> As my first impression when I read the title of the patch, an English reflink
> I would imagine is something more to the left of above graph, between hard-link
> and soft-link, something like: link to an invisible dir-entry that is gone once
> all soft-links to it are gone.
> 
> So form my point of view. Call it something different like Copy-On-Write or
> COW.
> 
> I do understand that there is something very fundamental in my misunderstanding,
> but it was not explained below, in fact the below terminology confused me even
> more. Please explain?

It's simply a lazy copy, with interface for creating it similar to link(2).
That's all.
