From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 6 Oct 2008 18:04:29 -0700
Subject: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
In-Reply-To: <20081006233248.GA9337@mit.edu>
References: <20080917232629.GB20752@mail.oracle.com>
	<20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu>
	<20081006213754.GA26632@mail.oracle.com>
	<20081006214251.GB26632@mail.oracle.com>
	<20081006233248.GA9337@mit.edu>
Message-ID: <20081007010429.GF26632@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>
Cc: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org

On Mon, Oct 06, 2008 at 07:32:48PM -0400, Theodore Tso wrote:
> pieces work.  Andrew Morton is right; Stephen Tweedie wrote some
> *very* clever code

	sct is very good at doing that, and even better at going off
afterwards :-)

> it all works.  So I suspect one of is going to have take a deep dive
> into the code, grok how the trifecta of b_committed_data,
> b_frozen_data, and b_data interact, and which functions make what
> assumptions, and then write up a lot of explanatory documentation....
> 
> Unfortunately, I'm not sure I'm going to have time for at least the
> next couple of weeks.  Do you think you could take a crack at it?

	I think I just did some of it in the previous email, so I
suppose I should do some more.  Let me see if I can squeeze it in.

Joel

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
