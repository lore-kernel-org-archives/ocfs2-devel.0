From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 14 Sep 2009 15:14:35 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
Message-ID: <20090914221434.GA4507@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Sep 14, 2009 at 02:32:36PM -0700, Linus Torvalds wrote:
> On Fri, 11 Sep 2009, Joel Becker wrote:
> >
> > Linus, et al,
> > 	Here are the ocfs2 feature changes for 2.6.32.  The big ticket
> > item is the reflinkat(2) system call and ocfs2's support for it.  The
> > ocfs2 support accounts for all but a handful of the changes.  The
> > remaining few patches are fixes.
> 
> I _really_ want some kind of ack's for new filesystem system calls like 
> this. I'm not going to pull a new 'reflink[at]()' system call just based 
> on a single filesystem.

	I'll get specific acks.  I sent it via ocfs2.git because others
recommended I not send it upstream in June but instead wait until
I had at least one filesystem implementing it.

> Yes, there's clearly been _some_ discussion, but (a) I've not seen it 
> (since it's been on 'fsdevel', which is one of those single-topic mailing 
> lists that I'm totally uninterested in, since they tend to become clique 
> groups) and (b) you don't even say whether the thing has been acked by 
> things like the security angle etc.

	Fair enough.  Don't worry, the security folks were involved.
I'll get direct acks.

> I also don't understand why it's called 'reflink'. Why not 'copyfile'? We 
> should not name things by implementation, we should name things by what 
> they _do_. And I'm not seeing what is so 'reflink' about this that it's 
> not a 'copyfile'. I also am not entirely clear on why you need the source 
> name, and not - for example - an 'fd'.
> 
> Are we going to add 'freflink[at]()' at some point?

	It's a link(2) analogue.  symlink(2) has the loosest coupling,
and reflink(2) the highest.  We're not going to add freflink[at]().
It's a snap, not a copy.  It can be used to implement a copy, and
copyfile() in libc can be written with reflinkat(2), but it isn't just a
copy.

Joel

-- 

"There is shadow under this red rock.
 (Come in under the shadow of this red rock)
 And I will show you something different from either
 Your shadow at morning striding behind you
 Or your shadow at evening rising to meet you.
 I will show you fear in a handful of dust."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
