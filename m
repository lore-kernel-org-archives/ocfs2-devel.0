From: Daniel Phillips <phillips@istop.com>
Date: Thu May 19 11:19:12 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <20050519065405.GI1340@ca-server1.us.oracle.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
	<200505190230.23624.phillips@istop.com>
	<20050519065405.GI1340@ca-server1.us.oracle.com>
Message-ID: <200505191223.16189.phillips@istop.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

Hi Mark,

On Thursday 19 May 2005 02:54, Mark Fasheh wrote:
> On Thu, May 19, 2005 at 02:30:23AM -0400, Daniel Phillips wrote:
> > Zero terminated strings for lock names is bad taste.  It generates a
> > bunch of useless strlen executions and you force an ascii namespace for
> > no apparent reason.  Add a 9th parameter, namelen, to the lock call
> > maybe?
>
> Or perhaps pass in a qstr? Anyway I have to agree. That shouldn't be
> difficult to fix up.

Qstr would be nice, either that or an explicit string length.  Either way, the 
compiler will catch any missed fixups.

Regards,

Daniel
