From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Sep 2009 16:27:59 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090914221434.GA4507@mail.oracle.com>
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	<20090914221434.GA4507@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com



On Mon, 14 Sep 2009, Joel Becker wrote:
> 
> 	It's a link(2) analogue.  symlink(2) has the loosest coupling,
> and reflink(2) the highest.  We're not going to add freflink[at]().
> It's a snap, not a copy.  It can be used to implement a copy, and
> copyfile() in libc can be written with reflinkat(2), but it isn't just a
> copy.

From all but a performance standpoint, it's a copy. It has absolutely 
_zero_ "link" semantics. When you do a symlink or a hardlink, you see it 
in the resulting semantics: changing one changes the other. 

This 'reflink' has no such semantics that I can tell. It has purely copy 
semantics, never mind that it's optimized.

And the thing to note is that it doesn't even have to be optimized as a 
"link". Think about network filesystems: maybe they want to implement this 
thing as a server-side "copy" operation (with atomicity guarantees).

In other words, I can well imagine that for some filesystems, there really 
is no refcounting or linking implied, and that's why I think naming should 
be about semantics, not some random implementation issue that just happens 
to be true for some particular class of filesystems.

So tell me - are there actually any non-copying semantics as far as the 
_user_ is concerned? Is there some reason why a NFS server might not 
implement this as a server-side copy? Is there something fundamentally in 
this all that is about reference counting as far as a user is concerned?

I also still didn't get any answer to the "freflink()" question. You just 
said that we wouldn't do it, with no explanation. Why? We've discussed 
'flink()' in the past, I just want to know that when we do a new system 
call there is some _reason_ why it's not going to explode into many 
different variants later...

			Linus
