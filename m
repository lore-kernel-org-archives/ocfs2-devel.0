From: Steve French <smfrench@gmail.com>
Date: Mon, 20 Jan 2020 18:58:05 -0600
Subject: [Ocfs2-devel] [LFS/MM TOPIC] fs reflink issues,
	fs online scrub/check, etc
In-Reply-To: <20160210191848.GC6346@birch.djwong.org>
References: <20160210191715.GB6339@birch.djwong.org>
	<20160210191848.GC6346@birch.djwong.org>
Message-ID: <CAH2r5mtM2nCicTKGFAjYtOG92TKKQdTbZxaD-_-RsWYL=Tn2Nw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: lsf-pc@lists.linux-foundation.org, xfs <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com

Since SMB3 protocol has at least three ways to do copy offload (server
side copy),
the reflink topic is of interest to me and likely useful to discuss
for Samba server as
well as client (cifs.ko)

On Wed, Feb 10, 2016 at 1:19 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> [resend, email exploded, sorry...]
>
> Hi,
>
> I want to discuss a few FS related topics that I haven't already seen on
> the mailing lists:
>
>  * Shared pagecache pages for reflinked files (and by extension making dax
>    work with reflink on xfs)
>
>  * Providing a simple interface for scrubbing filesystem metadata in the
>    background (the online check thing).  Ideally we'd make it easy to discover
>    what kind of metadata there is to check and provide a simple interface to
>    check the metadata, once discovered.  This is a tricky interface topic
>    since FS design differs pretty widely.
>
>  * Rudimentary online repair and rebuilding (xfs) from secondary metadata
>
>  * Working out the variances in the btrfs/xfs/ocfs2/nfs reflink implementations
>    and making sure they all get test coverage
>
> I would also like participate in some of the proposed discussions:
>
>  * The ext4 summit (and whatever meeting of XFS devs may happen)
>
>  * Integrating existing filesystems into pmem, or hallway bofs about designing
>    new filesystems for pmem
>
>  * Actually seeing the fs developers (well, everyone!) in person again :)
>
> --Darrick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=q8l3XFIJYuhNKEvJLvPgg8PS0iHhoWvEsy3tK5D714U&s=pI3OMIMeV9-GoE4ncu5_LxznmF3yuGFBmeKaf7Td2Wo&e= 



-- 
Thanks,

Steve
