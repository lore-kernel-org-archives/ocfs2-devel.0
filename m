From: Lars Marowsky-Bree <lmb@suse.de>
Date: Tue Oct 18 18:03:30 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051018221849.GN11488@ca-server1.us.oracle.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
Message-ID: <20051018230323.GE2813@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-18T15:18:49, Joel Becker <Joel.Becker@oracle.com> wrote:

I'm too tired to go into the filesystem details and I have a better
understanding of the user-space parts than the fs layer ;-) I'll wade
through the rest tomorrow morning to see whether I can add something
useful to that part of the discussion too.

> 	Given that heartbeat regions can and should be shared, you need
> a way to describe this.  We don't have userspace doing global heartbeat
> yet, but there is no reason that all OCFS2 volumes can't share one
> heartbeat region (see
> http://oss.oracle.com/projects/ocfs2-tools/src/branches/global-heartbeat/documentation/o2cb/).

Good point, but I think part of Jeff's proposal is to pull-out the
heartbeating from OCFS2 into user-space, so OCFS2 no longer would
maintain its own heartbeat, and thus no heartbeat region.

Membership events (nodes up, down) would be provided to OCFS2
post-fencing.

> 	Have you also considered what this will or won't do to possible
> interaction with the CMan stack?  We'd love OCFS2 to handle both stacks.

This is hard for us to judge, but given that CMan in recent mailing list
discussions seems to be moving towards a user-space driven membership
too, it's fairly likely useable here too.

The main semantic difference I can make out between the RHAT DLM and the
one which OCFS2 uses are the way how the events are delivered across the
cluster; while OCFS2 doesn't seem to care much, RHAT's DLM requires a
"suspend all nodes - reconfigure / submit events - tell all nodes to
resume" three-phase protocol.

Our user-space stack is capable of driving both, as it happens. Funny,
actually - we have been working on the assumption that our user-space
stack needs to be able to drive all CFS implementations, and now you
bring up that you want your CFS to be driven by both stacks. ;-)

> 	Finally, have you considered the user barriers to this?  The
> absolute bottom-line goal of O2CB is the minimum input by the user.  For
> this to work, the user should not have to see the plethora of XML config
> files that heartbeat has (or at least, used to have).  I'm talking about
> the user-visible part here, not the technical reality.  The O2CB
> frontend or some other piece of software can take the user's name:ip
> node mapping and turn it into whatever XML it needs, but the user
> shouldn't have to do anything more than ocfs2console requires them
> today.

heartbeat used to have 3 straightforward config files; the XML based
configuration file (one of them, actually) is pretty new. "Plethora of
XML configuration files" certainly isn't true of heartbeat 2.x, and
never was. The XML configuration file is even automatically replicated
across cluster nodes so the user can't get them desync'ed ;-)

My goal is for the user to only add a single resource entry (a so-called
"clone" resource type) to the configuration for each OCFS2 filesystem,
and then he'd be done; the cluster would auto-generate everything else.

(As it happens, another group at Novell already has demoed this with
Novell Clustering Services; the OCFS2 configuration file is generated
from the LDAP-based cluster configuration automatically. Something
similar is what I'm aiming for here: tell us on which nodes to mount the
filesystem on (all or a subset), point us at a storage, tell us the
network to use, say "go".)

Admittedly, until heartbeat 2.x has a nice GUI, that will imply an XML
blurb to be fed to one of our tools. And yes, heartbeat 2.x's
configuration file is as simple as possible (if one ignores the XML
verbosity), but still, it is a quite powerful tool. 

But, as far as heartbeat 2.x based clusters is concerned, this will be
as easy as it can get. Trust me; I'm on the receiving end of support
cases, and I don't want it to make easier to misconfigure, and so the
less configuration possible, the better. Support has my cell phone
number and is not afraid to use it, I'm afraid... Does that make my
motivation sincerely believable? ;-)

Of course, this brings up a valid point; currently, OCFS2 can run "stand
alone" w/o any supporting user-space stack. Uhm. As RAC doesn't
interoperate with _any_ other stack, I assume this is a property which
needs to be preserved.

I'm not sure our proposal covers that case adequately; I'm thinking we
were thinking "rip & replace!" when it comes to membership/fencing, not
"either - or", but I might be wrong. This however might not be too
difficult to extend, because we only modify the heartbeat/fencing stack
- instead of ripping it out, we need to make it switchable.

So, going back to your original question, in the stand-alone mode as it
is now, the node membership would simply be "global" - all filesystems
would inherit membership from the same 'cluster'. While in our case, we
might run each filesystem with its own membership - that could be as
simple as a pointer in the per-fs data structures.

Before I write too much more crap I better get some sleep now ;-)


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
