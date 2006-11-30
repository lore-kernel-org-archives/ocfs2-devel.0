From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Nov 30 09:37:41 2006
Subject: [Ocfs2-devel] [patch 1/1] ocfs2-timeout-protocol.patch
In-Reply-To: <608ABF1E-301E-4CCA-9A2C-0C515FFFE03F@suse.de>
References: <20061129085130.004252000@suse.de>
	<20061129090355.473139000@suse.de>
	<20061129233145.GP30647@ca-server1.us.oracle.com>
	<608ABF1E-301E-4CCA-9A2C-0C515FFFE03F@suse.de>
Message-ID: <20061130173735.GQ30647@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 30, 2006 at 01:24:29PM +0100, Andrew Beekhof wrote:
> >Can you not re-write the function prototypes unless they're actually
> >changing please? It clutters up the patch and makes it harder to  
> >find the
> >actual code to check (see below).
> 
> ah, bad habit i picked up working on smaller projects.
> is it ok in a separate patch?  or have I got my wrap points set too  
> small by default?
In general if you see something that's inconsisent with
Documentation/CodingStyle, then yeah fixing it in a seperate patch is fine.

As far as those functions are concerned, if you're not happy with the
indentation, then it would be nicest if you got them right in the patch
which introduced them.


> >>+		if (sc->sc_page_off == sizeof(struct o2net_handshake)) {
> >>+			o2net_check_handshake(sc);
> >>+			if(sc->sc_handshake_ok == 0) {
> >>+				BUG_ON(sizeof(struct o2net_handshake)
> >>+				       == sizeof(struct o2net_msg));
> >Is this necessary?
> 
> I wasnt sure at the time - see below - so i wanted to make sure it at  
> least died sanely
> apparently i still needed education on how that is done :)
> 
> >Didn't we fix the logic such that the relative sizes
> >don't matter any more? If it _is_ necessary, then it should be a
> >BUILD_BUG_ON() in a more visible place,
> 
> ah, I was not familiar with that macro yet
Yeah, I'm mostly going on your description of the patch, and Zach's
description of the problem. I'll have to look more closely to see if this is
still something we need to trap or not.


> >with a nice fat comment explaining
> >why...
> >
> >>+				ret = -EPROTO;
> >>+			}
> >>+			goto out;
> >Do you mean to move that goto within the
> >
> >if (sc->sc_handshake_ok == 0) {
> >
> >block? I _think_ it's ok for us to continue otherwise...
> 
> i did - but if we never want to process an o2net_msg if the handshake  
> has not been completed, then i can structure things a little  
> differently/clearly
Hmm, yeah... It looks like what'd happen if we don't get a properly sized
handshake is that we'd continue to process the o2net_msg, which I don't
think we want to do. If we skipped that, then we don't have to depend on the
sizes not matching... Which is fine because I don't think we ought to be
processing messages from nodes which haven't properly connected to us yet.


> I'll resubmit once we sort out the  o2net_msg / o2net_handshake  
> situation
Great, thanks alot Andrew!
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
