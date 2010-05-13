From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 13 May 2010 16:51:14 -0700
Subject: [Ocfs2-devel] Quota locking fixes for OCFS2
In-Reply-To: <1273780683-3638-1-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
Message-ID: <20100513235114.GE13692@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 13, 2010 at 09:57:56PM +0200, Jan Kara wrote:
> Currently ocfs2 with quotas survives fsstress and fsx runs without oopsing

	When you say "currently," do you mean mainline ocfs2 or
ocfs2 with these patches? ;-)  I'm guessing you mean with these patches.

> The patch set is on top of:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6 for_next
> 
> Since it really depends on some of the cleanups I have there we have to
> somehow resolve how to merge it. Either I can do it after getting your
> acks or if you wish to wait with the changes until after the merge window,
> I can merge all the generic quota bits and ocfs2 patches can be pulled
> into ocfs2 tree after that.

	I'm fine with Acking this series for you to send with your
cleanups.  They're all going in the merge window, right?

Joel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
