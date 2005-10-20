From: Lars Marowsky-Bree <lmb@suse.de>
Date: Thu Oct 20 05:24:15 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <4356BBE8.2080904@suse.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
Message-ID: <20051020102358.GB11726@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-19T17:34:32, Jeff Mahoney <jeffm@suse.com> wrote:

> > Actually a good point. I don't think the heartbeat hierarchy is needed
> > if driven by a user-space membership.
> If we're to provide membership information on a per file system basis,
> we'll need some way to distinguish between them. The hierarchy may not
> matter in the case of the o2cb global heartbeat, but it does for the
> userspace heartbeat.

User-spaces knows which membership it needs to supply to which
filesystem UUID anyway though. The heartbeat/ subdirectory (if that's
what we are talking about) only matters for in-kernel membership as like
now.

> > OCFS2 doesn't register with us in this model; _we_ drive OCFS2 and
> > provide it with the events; we manage it, so we know it's there.
> No, OCFS2 needs to register with userspace.
> 
> The userspace heart beat should only care about nodes where the file
> system is actually mounted. Otherwise, if a random node that has the
> ability to mount a file system but doesn't actually have it mounted
> could cause heartbeat events across the cluster. That shouldn't happen.

You're thinking like a filesystem-and-nothing-else guy, can't blame you
for that ;-)

> In order to do this, I think that at mount time, we should call out to
> user space to tell it to start caring about this node for a particular
> heart beat group. When the file system is umounted, we call out again
> and tell it to stop caring.
> 
> Only using the cluster manager to mount or umount a file system isn't an
> acceptable use pattern. OCFS2 shouldn't become so special cased that
> it's a pain to work with.

This is the only way of managing cluster resources. Cluster resources
must be solely controlled via the CRM. Just like now, cluster users are
quite used to that, it's a basic property of all existing cluster
stacks: the user is for example NOT allowed to mount a non-shared
filesystem just because he sees the SAN; he needs to use the CRM, or
various constraints can no longer be guaranteed.

A common model how resources can register with a CRM doesn't exist yet.
As I pointed at the future: CIM/WBEM might one day offer something like
this, but we aren't there yet. Random subsystems registering with us w/o
them telling us their dependencies just doesn't work.

"mount the filesystem as a normal filesystem" is a use pattern which
works if your filesystem is the only thing which the cluster manages.
But what does it depend on? Is the node allowed to mount the filesystem
at all, based on the current active policy rules? Does it require
fencing? ...

And most especially, I don't want this event to come from the kernel to
user-space, I think.

What might just be about possible is that "mount" is patched to know
that it has to go through some special steps to "mount" an OCFS2 fs;
namely, not do it itself directly, but tell the CRM "Hey, user wants
this mounted, see what you can do".

As you're not allowed to mount the filesystem if you're not a proper
cluster member, the requirement for the cluster stack to be running
isn't anything new.

> There should be a default OCFS2 configuration that we can use for
> common mounts, and then special cased configurations for more advanced
> topologies. We can pass out the UUID as a parameter; I don't think
> this should be too difficult to do.

The "default" case is that the filesystem is mounted on all nodes (as
part of the cluster startup) all the time, and all nodes are equal.
Still, this requires the cluster to be told. And it needs to be told
that the filesystem needs to be started before the application etc.

See, the user has to tell us about the applications and other services
already anyway; as part of that configuration, he also tells us about
the filesystem. That's all consistent. I don't want to special case
OCFS2; the mount extension pointed at above might be a path to get both
approaches joined.


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
