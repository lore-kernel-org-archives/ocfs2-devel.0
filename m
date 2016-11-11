From: Eric Ren <zren@suse.com>
Date: Fri, 11 Nov 2016 11:15:57 +0800
Subject: [Ocfs2-devel] [PATCH 0/6] ocfs2: wire up {clone, copy,
	dedupe}_range
In-Reply-To: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
References: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
Message-ID: <4d01515b-7511-22f7-4c71-ae76eab0ec47@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>, mfasheh@versity.com, jlbec@evilplan.org
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi,

On 11/10/2016 06:51 AM, Darrick J. Wong wrote:
> Hi all,
>
> These patches wire up the existing ocfs2 reflinking capabilities to
> the new(ish) VFS {copy,clone,dedupe}_range interface.  The first few
> patches clean up some minor bugs that I found; the last kernel patch
> contains the new code.
>
> A few minor fixes to xfstests are needed to make more of the tests
> run.  I'll tack that patch on the end.

FYI, reflink testcases from ocfs2-test both on single and multiple node(s)
all passed with your patches. At least, it shows that no obvious regression issue
is observed so far ;-)

Eric
>
> --D
>
> [1] https://github.com/djwong/linux/tree/ocfs2-vfs-reflink
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
