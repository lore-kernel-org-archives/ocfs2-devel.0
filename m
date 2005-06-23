From: James Morris <jmorris@redhat.com>
Date: Thu Jun 23 13:03:40 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <20050518223303.GE1340@ca-server1.us.oracle.com>
Message-ID: <Xine.LNX.4.44.0506231358230.14123-100000@thoron.boston.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

On Wed, 18 May 2005, Mark Fasheh wrote:

> This is OCFS2, a shared disk cluster file system which we hope will be
> included in the kernel.

The masklog code looks potentially useful outside of ocfs2, as a general 
kernel facility.  Any chance of splitting it out?


Quibbles:

- A lot of the macros should probably be replaced with static inlines, 
like OCFS2_IS_VALID_DINODE.

- Approx. 80 typedefs.  ouch.



-- 
James Morris
<jmorris@redhat.com>
