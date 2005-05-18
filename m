From: Manish Singh <manish.singh@oracle.com>
Date: Wed May 18 20:26:58 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <20050518234022.GA5112@stusta.de>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
	<20050518234022.GA5112@stusta.de>
Message-ID: <20050519012658.GA27595@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, akpm@osdl.org, linux-kernel@vger.kernel.org, torvalds@osdl.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, May 19, 2005 at 01:40:22AM +0200, Adrian Bunk wrote:
> On Wed, May 18, 2005 at 03:33:03PM -0700, Mark Fasheh wrote:
> >...
> > A full patch can be downloaded from:
> > http://oss.oracle.com/projects/ocfs2/dist/files/patches/2.6.12-rc4/complete/ocfs2-configfs-all.patch
> >...
> 
> Some comments on this patch:
> - there's no reason to make JBD user-visible

Sure, the only reason I made it visible was because of the comment in
there:

# CONFIG_JBD could be its own option (even modular), but until there are
# other users than ext3, we will simply make it be the same as CONFIG_EXT3_FS

I don't really have a preference either way.

> - is there any reason why CONFIGFS_FS is user-visible?

It's a generic mechanism for userspace driven configuration of kernel
functionality. There's nothing specific to OCFS2 about it. Other kernel
subsystems/projects could use it too, for their own configuration
mechanisms. More details are in configfs.txt, which is included in the
above patch. Note the example used in the documentation text is an NBD
driver.

> - some global code might become static:
>   run "make namespacecheck" after compiling the kernel and check
>   the configfs and ocfs2 parts of the output

Yeah, there's some stuff that that scripts catches. Thanks.

-Manish
