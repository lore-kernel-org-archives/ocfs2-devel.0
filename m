From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Sep 2009 13:16:14 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090917183806.4c9d1849@infradead.org>
References: <20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
	<alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
	<20090917183806.4c9d1849@infradead.org>
Message-ID: <alpine.LFD.2.01.0909171312270.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjan van de Ven <arjan@infradead.org>
Cc: Joel Becker <Joel.Becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com



On Thu, 17 Sep 2009, Arjan van de Ven wrote:
> 
> or make it one level simpler?
> Have a "wait for all started copies" call only.... saves a ton of book
> keeping, and is likely what people will use it for in the end  anyway.

No. That wouldn't work. For a few reasons:

 - the case I didn't show was the "graphical file manager client" thing 
   that wants to show the copy as it progresses. It needs to know how much 
   is left, and for which file.

 - if errors happen, you need to indicate which file had an error. Again, 
   my example code didn't show that, since it was written as an example 
   and obviously just while writing email anyway. But it's a major 
   requirement for any sane and reliable filesystem model!

 - even in my example, I wanted to show how you don't want to wait for 
   _all_ of them in the middle, you just want to wait for some of them. If 
   you wait for all of them - just to make room for more - you're going to 
   have hickups in your IO patterns and you cannot saturate your server or 
   disks well.

So I really think there needs to be a cookie per outstanding file copy (of 
course, the kernel is likely to not allow a single user more than 'n' 
outstanding copies anyway, but that's a separate issue).

		Linus
