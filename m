From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jul 22 23:46:33 2004
Subject: [Ocfs2-devel] A patch to improve the metadata reading
	throughput(a gainst svn1267)
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404EDD5CE@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8404EDD5CE@pdsmsx403>
Message-ID: <20040723044627.GE783@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 21, 2004 at 05:58:38AM +0800, Ling, Xiaofeng wrote:
> --- src/journal.c	(revision 1267)
> +++ src/journal.c	(working copy)
> @@ -148,6 +148,8 @@
>  	}
>  	spin_unlock(&journal->cmt_lock);
>  
> +	if (osb->needs_flush)
> +		ocfs_sync_blockdev(osb->sb);
> 
> >Is this necessary? It seems awfully heavy, and since we journal *all*>
> >metadata (so it should be synced up to disk via the journal_flush just
> a
> >couple lines above that), I don't see the point... I was actually
> meaning to
> >take the other call to sync_blockdev out as it's never used :)
> 
> We added this just because we found that some times we can not see the
> new created directory
> from another node, but by adding this, we can always see. Seems
> some buffer in block device's cache list are not flushed to disk after
> journal_flush.
Actually, the bug (which I just fixed) was that we weren't telling the other
node to wait *on* the journal flush for a busy directory. Once I fixed it, I
haven't had any directory contents consistency issues. See svn revision 1302
for the patch.

> And after the lock release message is sent, the meta data cache on
> another node can not be
> throw away any more.So we must ensure all data is synced to disk on this
> node before sending message.
Again, JBD handles this for us via journal_flush. If you're seeing metadata
inconsistency it's much more likely that it's a DLM bug (in the case of the
readdir) or a caching issue.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
