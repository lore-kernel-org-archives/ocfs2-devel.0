From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Sep 20 13:44:52 2007
Subject: [Ocfs2-devel] [PATCH 10/15] ocfs2: Cleanup dirent size check
In-Reply-To: <20070920191400.GM30391@tasint.org>
References: <200709192012.l8JKCGOe029334@rgmgw2.us.oracle.com>
	<20070920191400.GM30391@tasint.org>
Message-ID: <20070920204449.GE21356@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 20, 2007 at 12:14:00PM -0700, Joel Becker wrote:
> On Thu, Sep 13, 2007 at 04:29:01PM -0700, Mark Fasheh wrote:
> > The check to see if a new dirent would fit in an old one is pretty ugly, and
> > it's done at least twice. Clean things up by putting this in it's own
> > easier-to-read function.
> > 
> > Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
> 
> de_really_needed sounds like it's the new needed, which confused me
> (de_really_needed + new_rec_len sounds like "new needed + new needed",
> which of course makes no sense).  Can you rename de_really_needed to
> de_really_used, de_old_used, or de_old_needed?  That captures the sense
> of "how much space in the old dirent is actually used".

Yeah, that variable naming even confuses me when I look at it :(

I'm going to spin the wheel of variable names and land at....
de_really_used!
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
