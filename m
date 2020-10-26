From: Dominique Martinet <asmadeus@codewreck.org>
Date: Mon, 26 Oct 2020 18:14:10 +0100
Subject: [Ocfs2-devel] [PATCH 1/7] 9P: Cast to loff_t before multiplying
In-Reply-To: <20201004180428.14494-2-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
	<20201004180428.14494-2-willy@infradead.org>
Message-ID: <20201026171410.GA31121@nautica>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org

Matthew Wilcox (Oracle) wrote on Sun, Oct 04, 2020:
> On 32-bit systems, this multiplication will overflow for files larger
> than 4GB.
> 
> Cc: stable at vger.kernel.org
> Fixes: fb89b45cdfdc ("9P: introduction of a new cache=mmap model.")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I realize I hadn't sent a mail -- FWIW this 9p patch has been merged,
thanks!
-- 
Dominique
