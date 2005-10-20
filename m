From: Lars Marowsky-Bree <lmb@suse.de>
Date: Thu Oct 20 05:58:09 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051019224221.GB4305@redhat.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<43558422.9040607@suse.com>
	<20051019195654.GQ24589@marowsky-bree.de>
	<20051019224221.GB4305@redhat.com>
Message-ID: <20051020105755.GE11726@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-19T17:42:21, David Teigland <teigland@redhat.com> wrote:

> Just catching up on this after being away for a while.  Not only has cman
> moved entirely to user space, but a large portion of gfs (everything
> related to cman and clustering) has also moved to user space.  So, a user
> space gfs daemon (call it gfs_clusterd) interacts with the other user
> space clustering systems and drives the bits of gfs in the kernel. 

Morning David, thanks for your insights!

> Here are the main "knobs" gfs_clusterd uses to control a specific fs:
> 
> /sys/fs/gfs2/<fs_name>/lock_module/
>                                    block
>                                    mounted
>                                    jid
>                                    recover
> 
> When a gfs fs is mounted on a node:
> 
> . the mount process enters gfs-kernel
> . the mount process sends a simple uevent to gfs_clusterd
> . the mount process waits for gfs_clusterd to write 1 to /sys/.../mounted
> 
> . gfs_clusterd gets the mount uevent from gfs-kernel
> . gfs_clusterd joins the cluster-wide "group" that represents the
>   specific fs being mounted [1]
> . gfs_clusterd tells gfs-kernel which journal the local node will use by
>   writing the journal id to /sys/.../jid
> . gfs_clusterd tells the mount process it can continue by writing 1
>   to /sys/.../mounted
> . the local node now has the fs mounted

The /sys/.../mounted flag seems to be exactly the thing I don't like.
Sigh. ;-) It seems, however, that there's actual demand for this
functionality.

OK. I'll now make a 180 degree turn and say that we need to do this and
agree to figure out how ;-)

Ignoring the specific steps gfs_clusterd performs (which would be
different on our stack, of course), the main issue I'm not liking this
much is the hoop through kernel space for the uevent and the
notification.

(Also, your outline doesn't contain the possibility that the cluster
says "No, you CAN'T mount this. Rejected!" - is this for ease of
describing the case, or how is that implemented? Writing "2" to the
.../mounted flag or something?)

I'd much rather have all of this done in user-space prior to the actual
mount syscall being issued.

"mount" would need a generic hook by which it could call into the
cluster stuff (whatever it is) to a) have it authorize the mount, b)
_know_ about the mount, c) prepare the mount if needed - by bringing
online all pre-requisites on that node et cetera. 

Actually this is quite powerful. This hook could also be used for _non
cluster filesystems_ - the cluster could deny mounting of filesystems on
shared storage which are active on another node.

Same for umount. A nice side-effect for the umount would be that it
could actually ask the cluster "hey, admin wants this unmounted, stop
everything which depends on it on that node too! Migrate!".

Two issues:

- This is a special case for filesystems. It'd be nice if we had a
  generic mechanism by which this also worked for all kinds of
  resources; as I've said, CIM seems to be going into that direction.
  Then also this could be unified with the mechanism for example the
  clustered LVMs use; the C-LVM2 already has such a mechanism internally
  too.
  
  However, filesystems are a fairly important case, and when we have
  more than one implementation of this mechanism (LVM + filesystem)
  we'll have a better idea of what such a generic mechanism would look
  like.

- Trapping this in user-space of course isn't as powerful as
  intercepting each and every mount syscall(); somebody calling directly
  would get a reject. This however seems acceptable to me?


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
