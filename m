From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 21 Aug 2011 21:23:31 -0700
Subject: [Ocfs2-devel] ocfs2 cleanups,
 bug fixes for Linux kernel 3.1 - final drop
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110822042330.GC31134@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 14, 2011 at 03:50:11PM -0700, Sunil Mushran wrote:
> Joel,
> 
> Hopefully this is the final drop before the 3.1 merge window. I had posted most
> of the patches before. In fact the first 12 are exactly the same. The 13th one
> is modified and 14,15,16 are new.

Hey Sunil,
	These changes are now in the 'fixes' branch of ocfs2.git.  Sorry
this took so long.  I plan to send the SEEK_HOLE patch along, and if
Linus wants it out I will take it out.
	My only comment on the series, which is otherwise quite nicely
put together, is that new mlog()s should be replaced by trace events.
I'm going to let them in for this time, but please consider updating
them in another patch.

Joel

-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

			http://www.jlbec.org/
			jlbec at evilplan.org
