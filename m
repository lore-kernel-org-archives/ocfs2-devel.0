From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 10 13:39:52 2007
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Local alloc window size
	changeable via mount option
In-Reply-To: <1196467193-24983-2-git-send-email-sunil.mushran@oracle.com>
References: <1196467193-24983-1-git-send-email-sunil.mushran@oracle.com>
	<1196467193-24983-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071210213923.GV28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 30, 2007 at 03:59:53PM -0800, Sunil Mushran wrote:
> Local alloc is a performance optimiztion in ocfs2 in which a node
> takes a window of bits from the global bitmap and then uses that for
> all small local allocations. This window size is fixed to 8MB currently.
> This patch allows users to specify the window size in MB including
> disabling it by passing in 0. If the number specified is too large,
> the fs will use the default value of 8MB.
> 
> mount -o localalloc=X /dev/sdX /mntpoint
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/localalloc.c |   41 +++++++++++++++++++++++++++++------------
>  fs/ocfs2/ocfs2.h      |    1 +
>  fs/ocfs2/ocfs2_fs.h   |    8 ++++++++
>  fs/ocfs2/suballoc.c   |    5 +++--
>  fs/ocfs2/super.c      |   17 +++++++++++++++++
>  5 files changed, 58 insertions(+), 14 deletions(-)

We need to update the "Mount options" list in
Documentation/filesystems/ocfs2.txt as well.

Otherwise, this looks fine.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
