From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 18 Dec 2009 13:30:53 -0800
Subject: [Ocfs2-devel] Add FIEMAP_EXTENT_SHARED flag
In-Reply-To: <2D18A332-D252-455A-B0DC-BFC1E2E4C8A2@sun.com>
References: <1259873212-20107-1-git-send-email-sunil.mushran@oracle.com>
	<20091218051040.GB20149@mail.oracle.com>
	<2D18A332-D252-455A-B0DC-BFC1E2E4C8A2@sun.com>
Message-ID: <4B2BF48D.1080600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, ext4 development <linux-ext4@vger.kernel.org>, Joel Becker <Joel.Becker@oracle.com>, ocfs2-devel@oss.oracle.com

Andreas Dilger wrote:
> Hi Joel,
> are there any plans to submit an e2fsprogs patch to print out the 
> "shared" extent flag from "filefrag"?
>
> At first glance it would also seem to make sense to set this flag for 
> ext2/3/4 xattrs that are sharing an external extent block.

Yes, I do have a patch for filefrag which I will push after this
gets into mainline.
