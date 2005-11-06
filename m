From: Christoph Hellwig <hch@lst.de>
Date: Sun Nov  6 23:01:20 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <4358A6C1.C5C7.00CF.0@novell.com>
References: <20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
	<20051020102358.GB11726@marowsky-bree.de>
	<20051020150341.GC11488@ca-server1.us.oracle.com>
	<20051020152606.GB16745@redhat.com>
	<20051020154244.GD11488@ca-server1.us.oracle.com>
	<20051021090937.GA30904@lst.de> <4358A6C1.C5C7.00CF.0@novell.com>
Message-ID: <20051107050117.GA17440@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 21, 2005 at 08:28:50AM -0600, Robert Wipfel wrote:
> That would be nice - presumably it might also help solve the problem
> of protecting non-cluster aware file systems too, that are today
> protected
> against conflicting mounts by userspace conventions, that don't always
> guard against an admin manually mounting a file system on one node
> that
> might've been mounted by a cluster resource on some other node.

Umm, no.  not at all :) what I meant was routines for parsing mount
options so far.  when we find additional code useful for mount helpers
we can move it there aswell, but I'm not interested in new functionally,
especially not such things.
