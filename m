From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Aug 11 13:01:17 2004
Subject: [Ocfs2-devel] [BUG] system hang when copying with reading
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8405167C14@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8405167C14@pdsmsx403>
Message-ID: <20040811180112.GB11257@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Aug 07, 2004 at 09:29:40AM +0800, Ling, Xiaofeng wrote:
> 
> Step:
> node A: copy a file "bb.txt" of 200M to ocfs root
> node B: cd ocfs root, run "head bb.txt"
> Result:
> node B hangs.
> by kdb, three process went into "D" status. head, ocfs2cmt, kjourand
> in head, it is in ocfs_notify_truncate_on_wopen, 
> in ocfs2cmt, it is in ocfs_commit_cache.
I'm working on this right now btw...
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
