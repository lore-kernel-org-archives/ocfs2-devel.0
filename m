From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Feb  6 14:13:36 2004
Subject: [Ocfs2-devel] important: ocfs2 version number bump
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A568A6@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A568A6@orsmsx403.jf.intel.com>
Message-ID: <20040206201332.GF26331@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I haven't seen this particular behavior after the tuneocfs command... Where
is it hanging? btw, you guys know how to turn on tracing, right?
	--Mark

On Fri, Feb 06, 2004 at 10:49:09AM -0800, Villalovos, John L wrote:
> Okay maybe I'm doing something wrong.
> 
> But I just compiled up the latest code for ocfs2 and ocfs-tools.
> 
> I did the:
> 
> tuneocfs -c 2 /dev/sda1
> 
> When I try to mount my filesystem it now just hangs :(
> 
> Anyone else seeing this?  The previous revision of the code was working
> for mounting and unmounting.
> 
> I don't see any messages in my /var/log/messages.
> 
> This is a Fedora Core 1 UniProcessor system with all the updates
> applied.
> 
> John
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
