From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 24 Aug 2009 11:20:21 -0700
Subject: [Ocfs2-devel] [PATCH 17/41] ocfs2: Add CoW support.
In-Reply-To: <1251126252-8276-1-git-send-email-tao.ma@oracle.com>
References: <20090821205800.GC4330@mail.oracle.com>
	<1251126252-8276-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090824182021.GA7698@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 24, 2009 at 11:04:12PM +0800, Tao Ma wrote:
> This patch try CoW support for a refcounted record.
> 
> the whole process will be:
> 1. Calculate how much clusters we need to CoW and where we start.
>    Currently we will CoW 1MB at most.
> 2. Do CoW for the clusters with the help of page cache.
> 3. Change the b-tree structure with the new allocated clusters.

	Looks good except for the commit header.  (1) is really
"Calculate how many clusters we need to CoW and where we start.  Extents
that are not completely encompassed by the write will be broken on 1MB
boundaries" or something like it.

Joel

-- 

Life's Little Instruction Book #69

	"Whistle"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
