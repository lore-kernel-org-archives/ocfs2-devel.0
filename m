From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 9 Jan 2014 10:23:02 +0000
Subject: [Ocfs2-devel] What's the need of OCFS2_INODE_MAYBE_ORPHANED?
In-Reply-To: <52CE3409.8080108@oracle.com>
References: <CAJtY7HVQue79bLEUPXnN=fSbvcKS_mA8FUQbmaNE0dipSp1XoA@mail.gmail.com>
	<52CDFB7F.5010200@oracle.com> <52CE13AF.5080107@suse.de>
	<52CE3409.8080108@oracle.com>
Message-ID: <20140109102301.GD10565@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Unlink can happen from anywhere, but only the last closing node can
actually remove the file.  MAYBE_ORPHANED tells the node to try for
removal at close time.  It is absolutely necessary.

Joel

On Wed, Jan 08, 2014 at 09:30:49PM -0800, Srinivas Eeda wrote:
> On 01/08/2014 07:12 PM, Goldwyn Rodrigues wrote:
> > Hi Srini,
> >
> > On 01/08/2014 07:29 PM, Srinivas Eeda wrote:
> >> Hi Goldwyn,
> >>
> >> On 01/08/2014 04:12 PM, Goldwyn Rodrigues wrote:
> >>> Hi,
> >>>
> >>> >From the comments in fs/ocfs2/inode.h:90 it seems, this was used in
> >>> legacy ocfs2 systems when a node received unlink votes. Since unlink
> >>> votes has been done away with and replaced with open locks, is this
> >>> flag still required? If yes, why?
> >> My understanding is that unlink voting protocol was heavy. So the
> >> following was done to address it.
> >>
> >> To do an unlink, dentry has to be removed. In order to do that the node
> >> has to get EX lock on the dentry which means all other nodes have to
> >> downconvert. In general EX lock on dentry is acquired only in unlink and
> >> I assume rename case. So all nodes which down convert the lock mark
> >> their inode OCFS2_INODE_MAYBE_ORPHANED. The only problem with this is
> >> that dentry on a node can get purged because of memory pressure which
> >> marks inode as OCFS2_INODE_MAYBE_ORPHANED even when no unlink was done
> >> on this inode.
> >>
> >
> > I think you are getting confused between dentry_lock (dentry_lockres) 
> > and open lock (ip_open_lockres). AFAICS, dentry locks are used to 
> > control the remote dentries.
> I was trying to answer why we need OCFS2_INODE_MAYBE_ORPHANED flag, I 
> guess I wasn't clear. I'll make an other attempt :).
> 
> One way for node A to tell node B that an unlink had happened on node A 
> is by sending an explicit message(something similar to what we had in 
> old release). When node B received such communication it marked inode 
> with OCFS2_INODE_MAYBE_ORPHANED flag if it still had the inode in use.
> 
> The other way(current implementation) is to indirectly tell it by asking 
> node B to purge dentry lockres. Once node B has been informed that 
> dentry lock has to be released, it assumes inode might have been 
> unlinked somewhere and marks the inode with OCFS2_INODE_MAYBE_ORPHANED flag.
> 
> So, we need OCFS2_INODE_MAYBE_ORPHANED flag to tell node B that it 
> should finish the second phase of unlink(remove the inode from file 
> system) when it closes the file.
> 
> >
> >>
> >>> >From my ongoing investigation of unlink() times, it seems this flag is
> >>> causing the delay with releasing the open locks while downconverting
> >>> dentry locks. The flag is set  _everytime_ a dentry downconvert is
> >>> performed even if the file  is not scheduled to be deleted. If not, we
> >>> can be smartly evict the inodes which are *not* to be deleted
> >>> (i_nlink>0) by not offloading to ocfs2_wq. This way open lock will
> >>> release faster speeding up unlink on the deleting node.
> >>>
> >>>
> >> Are you referring to the delay caused by ocfs2_drop_dentry_lock queueing
> >> dentry locks to dentry_lock_list ?. If that's the case, have you tried
> >> removing following patches which introduced that behavior ? I think that
> >> quota's deadlock bug might have to be addressed differently ?
> >>
> >> ea455f8ab68338ba69f5d3362b342c115bea8e13
> >
> > Yes, that should make some difference. Let me try that. However, I was 
> > suggesting we do not set the OCFS2_INODE_MAYBE_ORPHANED flag in 
> > ocfs2_dentry_convert_worker as well, but I am not sure of the 
> > consequences and that is the reason I asked why it is used.
> >
> >> eb90e46458b08bc7c1c96420ca0eb4263dc1d6e5
> >> bb44bf820481e19381ec549118e4ee0b89d56191
> >
> > I did not find these gits. Which tree are you referring to?
> 
> Sorry, my bad. Those commit id's were from my local repo. I meant
> f7b1aa69be138ad9d7d3f31fa56f4c9407f56b6a and
> 5fd131893793567c361ae64cbeb28a2a753bbe35
> >
> >>
> >> The above patches were leaving orphan files around which was causing a
> >> big problem to some applications that removes lot of files which inturn
> >> caused intermittent hangs
> >>
> >
> >
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 
