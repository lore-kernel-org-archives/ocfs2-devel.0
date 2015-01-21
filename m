From: Dave Chinner <david@fromorbit.com>
Date: Thu, 22 Jan 2015 08:38:26 +1100
Subject: [Ocfs2-devel] [PATCH 0/17 v3] quota: Unify VFS and XFS quota
	interfaces
In-Reply-To: <1421412471-4747-1-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
Message-ID: <20150121213826.GL16510@dastard>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Fri, Jan 16, 2015 at 01:47:34PM +0100, Jan Kara wrote:
>   Hello,
> 
>   this is another iteration of patches to unify VFS and XFS quota interfaces so
> that XFS quotactls work for filesystems with VFS quotas and vice versa.  This
> is useful so that userspace doesn't have to care that much about which
> filesystem it is using at least when using basic quota functionality. In
> particular we should be able to reuse project quota tests in xfstests for ext4.
> 
> The patches are based on quota cleanup series [1] and XFS cleanup series [2]
> I've sent previously and based on 3.19-rc4 + for-next branch of XFS tree.  I
> could further split this series into per-quotactl series but frankly I don't
> think it will help reviewers in any way (the patches in the current series are
> already ordered by quotactl).

Hi Jan,

Do you have a this series in a git tree somewhere so it's easy to
merge and test?

> All the comments to the first version of the series are hopefully addressed,
> except for Dave's request to reduce number of copying of dquot information -
> I have benchmarked that reducing number of copies from 3 to 2 brings just 2%
> improvement in speed in my test setup and getting quota information isn't IMHO
> so performance critical that it would be worth the complications of the code.

I think the numbers address my concern adequately ;)

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
