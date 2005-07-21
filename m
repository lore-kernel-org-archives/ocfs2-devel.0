From: Lars Marowsky-Bree <lmb@suse.de>
Date: Thu Jul 21 18:22:43 2005
Subject: [Clusters_sig] RE: [Linux-cluster] Re: [Ocfs2-devel] [RFC]
	nodemanager, ocfs2, dlm
In-Reply-To: <20050720183938.GM16618@ca-server1.us.oracle.com>
References: <3689AF909D816446BA505D21F1461AE404167CFB@cacexc04.americas.cpqcorp.net>
	<20050720180918.GU5416@marowsky-bree.de>
	<20050720183938.GM16618@ca-server1.us.oracle.com>
Message-ID: <20050721232235.GJ24464@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux clustering <linux-cluster@redhat.com>, "Walker, Bruce J (HP-Labs)" <bruce.walker@hp.com>, David Teigland <teigland@redhat.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, clusters_sig@lists.osdl.org

On 2005-07-20T11:39:38, Joel Becker <Joel.Becker@oracle.com> wrote:

> 	In turn, let me clarify a little where configfs fits in to
> things.  Configfs is merely a convenient and transparent method to
> communicate configuration to kernel objects.  It's not a place for
> uevents, for netlink sockets, or for fancy communication.  It allows
> userspace to create an in-kernel object and set/get values on that
> object.  It also allows userspace and kernelspace to share the same
> representation of that object and its values.
> 	For more complex interaction, sysfs and procfs are often more
> appropriate.  While you might "configure" all known nodes in configfs,
> the node up/down state might live in sysfs.  A netlink socket for
> up/down events might live in procfs.  And so on.

Right. Thanks for the clarification and elaboration, for I am sure
not entirely clear as to how all these mechanisms relate in detail and
what is appropriate just where, and when to use something more classic
like ioctl etc... ;-)

FWIW, we didn't mean to get uevents out via configfs of course.


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
