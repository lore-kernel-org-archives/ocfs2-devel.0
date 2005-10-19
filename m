From: Lars Marowsky-Bree <lmb@suse.de>
Date: Wed Oct 19 08:35:48 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051018234757.GD25876@ca-server1.us.oracle.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018234757.GD25876@ca-server1.us.oracle.com>
Message-ID: <20051019133542.GJ24589@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-18T16:47:57, Mark Fasheh <mark.fasheh@oracle.com> wrote:

> Do you mean that the user would have to add a configuration entry for every
> single OCFS2 mount on their machine? Unless that's done automatically and
> transparently (perhaps from mount.ocfs2), it's pretty much a non starter.

> We've always wanted the users path (once the cluster stack is
> installed and configured) to be as easy as a local filesystem:
> mkfs.ocfs2 /dev/foo; mount /dev/foo /ocfs2.

Well, I think we're approximately on the same page here.

Your "mkfs ; mount" approach works because you are looking at a special
case; you just have the filesystem, nothing else it depends on, nothing
else depends on it.

I think you expect the mount command as above to register the filesystem
with the cluster manager automatically, while our approach is sort-of
the other way around.

The admin has to add the configuration entry to the CRM because in our
model, the filesystem mount is a cluster resource; if he wants us to be
aware of it (which means that we know to mount it before trying to start
Oracle on that node, for example, to give it membership events etc -
for that we need to not only know about the filesystem itself, but also
about how it depends on other components (SAN reservations, fencing...)
and how other components depend on it), he needs to tell us.

Yes, the configuration is a bit of a hassle. The admin in this case has
to model the relationship of the clustered resources to one another. We
need to make this easier as far as that is possible.

And yes, auto-discovery of these relations would rock; if we could query
what resources are active on the node, what they depend on, ... we could
create a cluster configuration automatically. CIM/WBEM might actually go
into that direction. But right now, I consider this a research problem
still.


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
