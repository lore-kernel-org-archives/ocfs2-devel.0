From: Wim Coekaerts <wim.coekaerts@oracle.com>
Date: Fri Jul  9 02:33:53 2004
Subject: [Ocfs2-devel] about remove ocfs_inode_sync
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404D65CB9@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8404D65CB9@pdsmsx403>
Message-ID: <20040709073211.GD13977@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hmm no that's not right but that's what we now have to fix
;)

On Fri, Jul 09, 2004 at 03:15:41PM +0800, Ling, Xiaofeng wrote:
> Hi,
>     In svn1251, ocfs_inode_sync and ocfs_flush is removed at file
> release,
> And now, when creating a file or directory on one node, you mush wait
> some time to 
> see the file/dir and wait more time to see the content of the file on
> another node.
> Is this accepted?
> 
> Anthoer problem, once you read the file on anther node before it is
> flushed to the
> disk, you will never the content of the file unless  remount.
> 
> 
> Best Regard
> -------------------
> Intel China Software Lab.
> iNet: 8-752-1806
> 021-52574545-1243(O)
> xfling@users.sourceforge.net
> Opinions are my own and don't represent those of my employer 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
