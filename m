From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Fri Feb  6 14:27:48 2004
Subject: [Ocfs2-devel] important: ocfs2 version number bump
In-Reply-To: <20040206201332.GF26331@ca-server1.us.oracle.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A568A6@orsmsx403.jf.intel.com>
	<20040206201332.GF26331@ca-server1.us.oracle.com>
Message-ID: <20040206202505.GA5312@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 06, 2004 at 12:13:32PM -0800, Mark Fasheh wrote:
> I haven't seen this particular behavior after the tuneocfs command... Where
> is it hanging? btw, you guys know how to turn on tracing, right?
> 	--Mark

Hmmm... I didn't see this last night, but I do see it now when I attempt to
mount the drive.  (Now I wonder if I was loading the correct module last night.)

Let me turn on tracing and try again.  I'll report what I find.

(Oh yea, I'm also running on the same UP Fedora kernel.)

    --rusty
> 
> On Fri, Feb 06, 2004 at 10:49:09AM -0800, Villalovos, John L wrote:
> > Okay maybe I'm doing something wrong.
> > 
> > But I just compiled up the latest code for ocfs2 and ocfs-tools.
> > 
> > I did the:
> > 
> > tuneocfs -c 2 /dev/sda1
> > 
> > When I try to mount my filesystem it now just hangs :(
> > 
> > Anyone else seeing this?  The previous revision of the code was working
> > for mounting and unmounting.
> > 
> > I don't see any messages in my /var/log/messages.
> > 
> > This is a Fedora Core 1 UniProcessor system with all the updates
> > applied.
