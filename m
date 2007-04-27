From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Apr 27 12:44:34 2007
Subject: [Ocfs2-devel] configfs: possible recursive locking detected
In-Reply-To: <46321C3F.5060902@suse.com>
References: <46321C3F.5060902@suse.com>
Message-ID: <20070427194429.GY27857@ca-server1.us.oracle.com>
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

	Without looking deeply, that stack is pretty much where we
expect to see recursive locking that needs annotation.  It's carefully
designed, but I haven't gotten around to learning how to annotate it.

Joel

-- 

"The doctrine of human equality reposes on this: that there is no
 man really clever who has not found that he is stupid."
	- Gilbert K. Chesterson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
