From: Lars Marowsky-Bree <lmb@suse.de>
Date: Tue Jul 19 11:24:23 2005
Subject: [Ocfs2-devel] [RFC] nodemanager, ocfs2, dlm
In-Reply-To: <20050718061553.GA9568@redhat.com>
References: <20050718061553.GA9568@redhat.com>
Message-ID: <20050719155214.GG13246@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Teigland <teigland@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-cluster@redhat.com, ocfs2-devel@oss.oracle.com

On 2005-07-18T14:15:53, David Teigland <teigland@redhat.com> wrote:

> Some of the comments about the dlm concerned how it's configured (from
> user space.)  In particular, there was interest in seeing the dlm and
> ocfs2 use common methods for their configuration.
> 
> The first area I'm looking at is how we get addresses/ids of other nodes.
> Currently, the dlm uses an ioctl on a misc device and ocfs2 uses a
> separate kernel module called "ocfs2_nodemanager" that's based on
> configfs.
> 
> I've taken a stab at generalizing ocfs2_nodemanager so the dlm could use
> it (removing ocfs-specific stuff).  It still needs some work, but I'd like
> to know if this appeals to the ocfs group and to others who were
> interested in seeing some similarity in dlm/ocfs configuration.

Hi Dave, I finally found time to read through this.

Yes, I most definetely like where this is going!

> +/* TODO:
> +   - generic addresses (IPV4/6)
> +   - multiple addresses per node

The nodeid, I thought, was relative to a given DLM namespace, no? This
concept seems to be missing here, or are you suggesting the nodeid to be
global across namespaces?

Also, eventually we obviously need to have state for the nodes - up/down
et cetera. I think the node manager also ought to track this.

How would kernel components use this and be notified about changes to
the configuration / membership state?


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
