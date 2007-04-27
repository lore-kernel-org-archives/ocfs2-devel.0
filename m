From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Apr 27 10:54:37 2007
Subject: [Ocfs2-devel] configfs: possible recursive locking detected
In-Reply-To: <46321C3F.5060902@suse.com>
References: <46321C3F.5060902@suse.com>
Message-ID: <20070427175430.GJ21982@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 27, 2007 at 11:52:31AM -0400, Jeff Mahoney wrote:
> I recently rebuilt my mainline kernel with lockdep enabled since I've
> been getting reports of reiserfs lockdep warnings. When I booted, I got
> the following warning from configfs. I haven't done any triage at all on
> it, but one of the shortcomings of lockdep IMO is the false positives.
> The ones for reiserfs just need better annotation. There's no error
> condition. This might be the same.

Without looking at the trace, I'm going to take a guess that it probably
just needs more annotation. There's a bunch of false positives in configfs
and ocfs2 right now which need fixing. I got a couple of them a while back,
but that didn't scratch the surface it seems :/
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
