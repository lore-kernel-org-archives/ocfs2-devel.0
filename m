From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sun Sep 24 16:28:59 2006
Subject: [Ocfs2-devel] Re: [git patches] ocfs2 post 2.6.18 features
In-Reply-To: <Pine.LNX.4.64.0609241532140.3952@g5.osdl.org>
References: <20060924221115.GF32106@ca-server1.us.oracle.com>
	<Pine.LNX.4.64.0609241532140.3952@g5.osdl.org>
Message-ID: <20060924232854.GG32106@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Trond Myklebust <trond.myklebust@fys.uio.no>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>

On Sun, Sep 24, 2006 at 03:36:14PM -0700, Linus Torvalds wrote:
> 
> Ok, pulled, and pushed out.
Great, thanks!


> And btw, I appreciate how you separately explained the fs/namei.c change, 
> together with the diff for just that part. This is a prime example of how 
> to make things easier for me to verify, when I see something touching a 
> generic file. Thanks.
Oh, excellent - I'm glad that worked out. I asked Andrew a couple weeks back
how we should handle that patch, and he indicated that I could push it if I
clearly noted its existence in my e-mail.


> I do have a small nit: when you ask me to pull, you did:
> 
> > Please pull from 'upstream-linus' branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
> 
> I really prefer to see the branch-name at the end of the line (don't worry 
> if it's more than 80 characters), because that way I don't make the 
> mistake of cutting-and-pasting the git URL, and forgetting the branch.
No problem - script updated. I copied the format from one of Jeff's more
recent pull mails:

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
upstream-linus

Hope that works for you.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
