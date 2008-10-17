From: Theodore Tso <tytso@mit.edu>
Date: Fri, 17 Oct 2008 08:28:40 -0400
Subject: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
In-Reply-To: <20081016194011.GA4748@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com>
	<20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu>
	<20081006213754.GA26632@mail.oracle.com>
	<20081006214251.GB26632@mail.oracle.com>
	<20081006233248.GA9337@mit.edu>
	<20081007010154.GE26632@mail.oracle.com>
	<20081008231752.GA5310@mail.oracle.com>
	<20081016174241.GH12962@mit.edu>
	<20081016194011.GA4748@mail.oracle.com>
Message-ID: <20081017122840.GD21503@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org, mfasheh@suse.com

On Thu, Oct 16, 2008 at 12:40:11PM -0700, Joel Becker wrote:
> 	Actually, I've had the fixed up patch for a week, tested even.
> You caught me this morning as I was rebasing against Linus.  Sorry I
> didn't send it out sooner.   The only difference from your version, that
> I can tell, is that I unconditionally call the commit trigger function -
> it handles checking for empty b_trigger, etc.
> 

Looks good to me.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Given that OCFS2 is going to be the first user of this patch, I guess
it would make sense for you to push it to Linus in an ocfs2 branch?
Or would you like me to send it to Linus?

							- Ted
