From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Feb  6 16:42:03 2004
Subject: [Ocfs2-devel] important: ocfs2 version number bump
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A568A8@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A568A8@orsmsx403.jf.intel.com>
Message-ID: <20040206224156.GG26331@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

echo -1 > /proc/sys/kernel/ocfs2/debug_context
echo -1 > /proc/sys/kernel/ocfs2/debug_level

In case you got tired of reading proc.c ;)
It also sometimes helps to turn off some of the VERBOSE_*_TRACE macros in
src/Makefile -- a few of those can seriously flood your logs!
	--Mark

On Fri, Feb 06, 2004 at 12:44:58PM -0800, Villalovos, John L wrote:
> I don't have all the info about the tracing.
> 
> I know that I need to change some values in /proc/...
> 
> I just need to go read the code a little bit more to figure it out :)
> 
> John


--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
