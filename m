From: Greg KH <gregkh@suse.de>
Date: Tue, 29 Jan 2008 17:47:28 -0000
Subject: [Ocfs2-devel] [git pull] Fix recent Ocfs2 breakage
In-Reply-To: <20080129055825.GG23506@ca-server1.us.oracle.com>
References: <20080129033307.GE23506@ca-server1.us.oracle.com>
	<20080129050804.GA2285@suse.de>
	<20080129055825.GG23506@ca-server1.us.oracle.com>
Message-ID: <20080129175013.GB15043@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>

On Mon, Jan 28, 2008 at 09:58:25PM -0800, Mark Fasheh wrote:
> On Mon, Jan 28, 2008 at 09:08:04PM -0800, Greg KH wrote:
> > And please please please please document stuff like this, and all of the
> > different files you have in this subdirectory in Documentation/ABI/ so
> > those of us who are trying to figure out the code (and there's still
> > parts of the kobject usage I'm pretty sure is not correct) can have a
> > chance to understand exactly how this stuff is being used and expected
> > to work.
> 
> No problem. I'll get us some patches to symlink things, and add docs in
> Documentation/ABI/ explaining how Ocfs2 and userspace communicate. In the
> future, as we add ABI it'll be documented there.

Great, that would be wonderful.

thanks,

greg k-h
