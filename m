From: Dave Chinner <david@fromorbit.com>
Date: Fri, 5 Oct 2018 15:28:39 +1000
Subject: [Ocfs2-devel] [PATCH 03/15] xfs: zero posteof blocks when
	cloning above eof
In-Reply-To: <153870029414.29072.6572683664719818617.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
	<153870029414.29072.6572683664719818617.stgit@magnolia>
Message-ID: <20181005052839.GC12041@dastard>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 05:44:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're reflinking between two files and the destination file range
> is well beyond the destination file's EOF marker, zero any posteof
> speculative preallocations in the destination file so that we don't
> expose stale disk contents.  The previous strategy of trying to clear
> the preallocations does not work if the destination file has the
> PREALLOC flag set.
> 
> Uncovered by shared/010.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Bugzilla-id: https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.kernel.org_show-5Fbug.cgi-3Fid-3D201259&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Jt3V3HpXf-NaJTVVKEWK881PgcOTureFbFgSqu7fhDQ&s=S0cjIrf21ndOPm5VlFKcHb9vya2G2W-ZcpF0qJjBHM4&e=
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david at fromorbit.com
