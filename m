From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 7 Jun 2006 20:46:00 -0700
Subject: [Ocfs2-devel] Extended Attribute Support?
In-Reply-To: <355a4e960606071747n7ae0ea88u8a1d155586c85fe9@mail.gmail.com>
References: <355a4e960606070435q69e1413fga5c30869d38caf31@mail.gmail.com>
	<20060607164519.GM3082@ca-server1.us.oracle.com>
	<355a4e960606071747n7ae0ea88u8a1d155586c85fe9@mail.gmail.com>
Message-ID: <20060608034600.GO3082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 07, 2006 at 06:47:13PM -0600, EKC wrote:
> Speaking of Lustre, how does OCFS2 compare in terms of scalability?
I'm no Lustre expert, so please take what I say with a grain of salt :) That
said, Lustre seems to like to exist at the very high end of things -
thousands of nodes where OCFS2 is much more limited.

> My understanding of OCFS2 is that it is limited to a maximum of 254
> cluster nodes. However, most of the OCFS2 documentation that I've read
> uses node slots per volume in the single digits. Are there any
> practical limitations to using 254 node slots per volume on OCFS2, and
> creating an OCFS2 cluster with 254 nodes (each node with 254 volumes
> mounted on it)?
We test regularly on 16 node clusters here at Oracle. You would be correct
however that the majority of usage we see is on the tens of nodes scale. As
far as practical limitations to scaling, I think it may depend on your
usage. What is your intended application for the cluster? Also, I'm curious
as to what your shared storage will reside on.

Off the top of my head, issues that might arise in a large cluster could be
disk heartbeat overhead, lock mastery, and if you're doing lots of
concurrent meta data updates to shared directories/files you would incur a
performance hit as the meta data is synced to disk.

> Since OCFS2 doesn't provide a unified namespace amongst volumes, I
> would like to be able to mount the same volume across all of my
> cluster nodes (up to 254). OCFS2 is attractive because of how clean
> the code is, and its inclusion in the mainline kernel.
Well thanks for the kind words regarding our code :) By the way, would you
be using mainline kernels, or something provided by a distribution vendor
(i.e., SUSE, Red Hat, etc)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
