From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jun 23 13:29:35 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <Xine.LNX.4.44.0506231358230.14123-100000@thoron.boston.redhat.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
	<Xine.LNX.4.44.0506231358230.14123-100000@thoron.boston.redhat.com>
Message-ID: <20050623182901.GB8215@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Morris <jmorris@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

Hi James,

Thanks for looking over this.

On Thu, Jun 23, 2005 at 02:03:35PM -0400, James Morris wrote:
> The masklog code looks potentially useful outside of ocfs2, as a general 
> kernel facility.  Any chance of splitting it out?
Absolutely. We've found that stuff invaluable in debugging issues for a
while now, and as far as I recall, Zach wrote it with the idea that it could
be useful to other folks too. I think the only issue to resolve there would
be how other subsystems reserve a debugging bit...

> Quibbles:
> 
> - A lot of the macros should probably be replaced with static inlines, 
> like OCFS2_IS_VALID_DINODE.
> 
> - Approx. 80 typedefs.  ouch.
Heh, we're slowly removing those :)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
