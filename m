From: Lars Marowsky-Bree <lmb@suse.de>
Date: Wed, 1 Feb 2006 16:29:31 +0100
Subject: [Ocfs2-devel] [Linux-ha-dev] Re: [PATCH 00/11] ocfs2: implement
	userspace clustering interface
In-Reply-To: <43E0D25D.9080105@unix.sh>
References: <20060109223942.GA8721@locomotive.unixthugs.org>
	<20060110042959.GJ3313@ca-server1.us.oracle.com>
	<43C33D62.1000804@suse.com>
	<20060110104319.GU14816@marowsky-bree.de>
	<20060110190847.GS3313@ca-server1.us.oracle.com>
	<20060201122718.GD28936@marowsky-bree.de>
	<43E0D25D.9080105@unix.sh>
Message-ID: <20060201152931.GI28936@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2006-02-01T08:23:09, Alan Robertson <alanr@unix.sh> wrote:

> Except that you CANNOT mount, umount, or mkfs before the CRM starts. 
> This means you can't put it in fstab like people conventionally do. 
> (Unless of course, the CRM somehow gets started really early - this 
> would likely be messy)

Well of course. That is quite true. You can't access a cluster
filesystem before the cluster stack is up. 

And just like other Filesystem instances or any other resource on our
control, we require that it not be started before us; ie, not mounted
auotmatically on boot. 

But, if the admin wishes, this could be implemented similar to ocfs2
already does it - namely, it already has to delay mounting until after
the network is up (like NFS), and would thus delay until hb is up. 

Thanks for the clarification.

This is not much of an issue unless we aim for "shared root" on a
cluster filesystem, in which case we'd need to get fancy with
initrd/initramfs and initialize (maybe in a low-cost read/only mode)
access to the root fs. This is something I'm right now not that
interested in because of the pain this implies at various places and
would require changes to the whole distribution.

And sorry for running off on this tangent ;-) Just important to keep at
the back of the mind, even if not relevant yet.

> Lars already knows this - but for the rest of you:  This would be 
> relatively easily implemented in our current architecture.  We already 
> have a special class of resource agent which does this (STONITH). 
> Adding a "general" one would be relatively easy.  Just need to make sure 
> we design the API in an extensible way so we don't have a bunch of churn 
> later on.

Right, there's even an open bugzilla to track this feature already.


Sincerely,
    Lars Marowsky-Br?e

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
