From: Adrian Bunk <bunk@stusta.de>
Date: Wed May 18 19:56:34 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <20050518223303.GE1340@ca-server1.us.oracle.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
Message-ID: <20050518234022.GA5112@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

On Wed, May 18, 2005 at 03:33:03PM -0700, Mark Fasheh wrote:
>...
> A full patch can be downloaded from:
> http://oss.oracle.com/projects/ocfs2/dist/files/patches/2.6.12-rc4/complete/ocfs2-configfs-all.patch
>...

Some comments on this patch:
- there's no reason to make JBD user-visible
- is there any reason why CONFIGFS_FS is user-visible?
- some global code might become static:
  run "make namespacecheck" after compiling the kernel and check
  the configfs and ocfs2 parts of the output

> Mark Fasheh

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
