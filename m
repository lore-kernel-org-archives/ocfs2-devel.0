From: Kyle Moffett <mrmacman_g4@mac.com>
Date: Wed May 18 23:28:47 2005
Subject: [Ocfs2-devel] Re: [RFC] [PATCH] OCFS2
In-Reply-To: <20050518223303.GE1340@ca-server1.us.oracle.com>
References: <20050518223303.GE1340@ca-server1.us.oracle.com>
Message-ID: <8E7D9068-5392-4479-9207-18C63618A133@mac.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, torvalds@osdl.org, akpm@osdl.org, wim.coekaerts@oracle.com, lmb@suse.de

On May 18, 2005, at 18:33:03, Mark Fasheh wrote:
> Hello,
>
> This is OCFS2, a shared disk cluster file system which we hope will be
> included in the kernel.
>
> We think OCFS2 has many qualities which make it particularly
> interesting as a cluster file system:

[...snip...]

> -OCFS2 has a strong data locking model, which includes a shared mmap
>  implementation (shared writeable mappings are not yet supported) and
>  full AIO support.

Does this include support for UNIX sockets and named pipes?  One of
the issues I have with filesystems like AFS and NFS is that they
should theoretically make such things possible, but the code is not
implemented yet and does not appear it ever will be.  This is very
useful for home directories when using programs like "links" that
rely on being able to create UNIX sockets in .links/socket or
similar.


Cheers,
Kyle Moffett

-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCM/CS/IT/U d- s++: a18 C++++>$ UB/L/X/*++++(+)>$ P+++(++++)>$
L++++(+++) E W++(+) N+++(++) o? K? w--- O? M++ V? PS+() PE+(-) Y+
PGP+++ t+(+++) 5 X R? tv-(--) b++++(++) DI+ D+ G e->++++$ h!*()>++$  
r  !y?(-)
------END GEEK CODE BLOCK------
