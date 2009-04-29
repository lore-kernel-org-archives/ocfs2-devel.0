From: Marcos E. Matsunaga <Marcos.Matsunaga@oracle.com>
Date: Wed, 29 Apr 2009 13:52:13 -0400
Subject: [Ocfs2-devel] Inode not orphaned
In-Reply-To: <20090429173041.GA11607@mail.oracle.com>
References: <20090429173041.GA11607@mail.oracle.com>
Message-ID: <49F893CD.50607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I ran into that in January 27th.. I don't remember what I was running.
That was it. Nothing after that on all my nodes..

Regards,

Marcos Eduardo Matsunaga

Oracle USA
Linux Engineering

?The statements and opinions expressed here are my own and do not
necessarily represent those of Oracle Corporation.?



Joel Becker wrote:
> Anyone else seen this?
>
> (25736,1):ocfs2_query_inode_wipe:882 ERROR: Inode 129047 (on-disk 129047) not orphaned! Disk flags  0x1, inode flags 0x80
> (25736,1):ocfs2_delete_inode:1010 ERROR: status = -17
>
> Test case is my patched version of ocfs2-test/programs/dirop_file_racer
> that allows long filename prefixes.  I ran it on two nodes in separate
> directories.  Filesystem has a 512B blocksize, and I specified a
> filename prefix of 250 characters (thus brushing up against NAME_MAX and
> forcing some longer symlinks out of the inode).
>
> # PREFIX=cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc ./racer.sh
>
>
> Test was on ocfs2-ALL.  All features were turned on in mkfs except
> indexed-dirs.
>
> Joel
>
>   
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090429/6bd29c49/attachment.html 
