From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Sep 2009 14:32:36 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090911200458.GA15416@mail.oracle.com>
References: <20090911200458.GA15416@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com



On Fri, 11 Sep 2009, Joel Becker wrote:
>
> Linus, et al,
> 	Here are the ocfs2 feature changes for 2.6.32.  The big ticket
> item is the reflinkat(2) system call and ocfs2's support for it.  The
> ocfs2 support accounts for all but a handful of the changes.  The
> remaining few patches are fixes.

I _really_ want some kind of ack's for new filesystem system calls like 
this. I'm not going to pull a new 'reflink[at]()' system call just based 
on a single filesystem.

Yes, there's clearly been _some_ discussion, but (a) I've not seen it 
(since it's been on 'fsdevel', which is one of those single-topic mailing 
lists that I'm totally uninterested in, since they tend to become clique 
groups) and (b) you don't even say whether the thing has been acked by 
things like the security angle etc.

So I'm not pulling this. Not until I get the feeling that there is 
consensus.

I also don't understand why it's called 'reflink'. Why not 'copyfile'? We 
should not name things by implementation, we should name things by what 
they _do_. And I'm not seeing what is so 'reflink' about this that it's 
not a 'copyfile'. I also am not entirely clear on why you need the source 
name, and not - for example - an 'fd'.

Are we going to add 'freflink[at]()' at some point?

So I want explanations for the naming, I want sign-offs from other 
filesystem (and security) people, etc. What I do _not_ want is to get a 
"please pull" request for a filesystem, and notice that it's suddenly not 
all about just that particular filesystem, without any indication of who 
you've been talking to etc etc.

			Linus
