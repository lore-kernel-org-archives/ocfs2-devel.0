From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Jul 20 13:39:38 2005
Subject: [Clusters_sig] RE: [Linux-cluster] Re: [Ocfs2-devel] [RFC]
	nodemanager, ocfs2, dlm
In-Reply-To: <20050720180918.GU5416@marowsky-bree.de>
References: <3689AF909D816446BA505D21F1461AE404167CFB@cacexc04.americas.cpqcorp.net>
	<20050720180918.GU5416@marowsky-bree.de>
Message-ID: <20050720183938.GM16618@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux clustering <linux-cluster@redhat.com>
Cc: "Walker, Bruce J (HP-Labs)" <bruce.walker@hp.com>, David Teigland <teigland@redhat.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, clusters_sig@lists.osdl.org

On Wed, Jul 20, 2005 at 08:09:18PM +0200, Lars Marowsky-Bree wrote:
> On 2005-07-20T09:55:31, "Walker, Bruce J (HP-Labs)" <bruce.walker@hp.com> wrote:
> 
> > Like Lars, I too was under the wrong impression about this configfs
> > "nodemanager" kernel component.  Our discussions in the cluster
> > meeting Monday and Tuesday were assuming it was a general service that
> > other kernel components could/would utilize and possibly also
> > something that could send uevents to non-kernel components wanting a
> > std. way to see membership information/events.
> 
> Let me clarify that this was something we briefly touched on in
> Walldorf: The node manager would (re-)export the current data via sysfs
> (which would result in uevents being sent, too), and not something we
> dreamed up just Monday ;-)

	In turn, let me clarify a little where configfs fits in to
things.  Configfs is merely a convenient and transparent method to
communicate configuration to kernel objects.  It's not a place for
uevents, for netlink sockets, or for fancy communication.  It allows
userspace to create an in-kernel object and set/get values on that
object.  It also allows userspace and kernelspace to share the same
representation of that object and its values.
	For more complex interaction, sysfs and procfs are often more
appropriate.  While you might "configure" all known nodes in configfs,
the node up/down state might live in sysfs.  A netlink socket for
up/down events might live in procfs.  And so on.

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
